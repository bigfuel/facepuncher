require 'fileutils'
require 'asset_sync'
require 'sprockets'

module Deploy
  module Errors
    class Error < StandardError; end
    class ProjectNotFoundError < Errors::Error; end
    class NoReleaseToDeployError < Errors::Error; end
    class CloneRepoError < Errors::Error; end
  end

  def self.perform(project_name)
    project = Project.find_by_name(project_name)
    raise Errors::ProjectNotFoundError, "Project not found." if project.nil?

    release = project.next_release
    raise Errors::NoReleaseToDeployError, "Not valid release to deploy." if release.nil?

    # clear the release message
    release.status = nil
    release.save

    Dir.mktmpdir(project.name) do |project_dir|
      repo_dir = File.join(project_dir, 'repo')
      FileUtils.mkdir_p(repo_dir)
      assets_dir = File.join(project_dir, 'assets')
      FileUtils.mkdir_p(assets_dir)
      public_dir = File.join(project_dir, 'public')
      FileUtils.mkdir_p(public_dir)

      begin
        # clone repo
        clone_repo(repo_dir, project.repo, release.branch)

        # TODO: Alert people
        begin
          copy_assets(repo_dir, File.join(assets_dir, project.name))
        rescue Timeout::Error => e
          release.status = e.message
          release.save
          raise
        end

        compile_assets(project.name, assets_dir, public_dir)

        self.generate_views(project.name, repo_dir)

        release.go_live
        project.touch
      rescue => e
        release.status = e.message
        release.save
        raise
      end
    end
  end

  def self.clone_repo(path, repo, branch)
    # initialize grit
    grit = Grit::Git.new(path)

    result = nil
    # clone the release repo/branch, retry if it fails
    retriable on: [Grit::Git::CommandFailed, Grit::Git::GitTimeout], tries: 3, interval: 1 do
      flags = {process_info: true, raise: true, progress: true, branch: branch}
      flags[:depth] = 1 unless !!(/^(?:https:).+(?:bitbucket.org)/ =~ repo) # workaround for https://bitbucket.org/site/master/issue/3799/cant-clone-a-repo-using-https-protocol-and
      result = grit.clone(flags, repo, path)
    end

    result
  end

  def self.copy_assets(source_path, dest_path)
    ["images", "stylesheets", "javascripts"].each do |dir|
      FileUtils.cp_r("#{source_path}/#{dir}/.", dest_path)
    end
  end

  def self.compile_assets(project_name, assets_dir, public_dir)
    app = Rails.application
    public_asset_path = File.join(Rails.public_path, app.config.assets.prefix)
    public_dir = Rails.root.join('tmp', 'public_assets', project_name) if Rails.env.development?

    manifest_path = app.config.assets.manifest ? File.join(app.config.assets.manifest, project_name) : File.join(public_dir, project_name)
    manifest = File.join(manifest_path, "manifest.yml")

    assets = app.assets.dup
    assets.instance_variable_set(:@trail, app.assets.instance_variable_get(:@trail).dup)
    assets.instance_variable_get(:@trail).instance_variable_set(:@paths, app.assets.instance_variable_get(:@trail).instance_variable_get(:@paths).dup)
    assets.append_path(assets_dir)

    digest = Rails.env.development? ? false : true

    compiler = Sprockets::StaticCompiler.new(assets,
                                             public_dir,
                                             app.config.assets.precompile,
                                             manifest_path: manifest_path,
                                             digest: digest,
                                             manifest: true)

    compiler.compile

    raise "Couldn't find manifest.yml" unless File.exists?(manifest)

    FileUtils.rm_r(File.join(public_asset_path, project_name), secure: true) if Dir.exists?(File.join(public_asset_path, project_name))
    FileUtils.cp_r("#{public_dir}/.", public_asset_path)
    AssetSync.sync unless Rails.env.development?
    Rails.cache.write("digests:#{project_name}", YAML.load_file(manifest))
  end

  def self.generate_views(project_name, project_path)
    project_path = Pathname.new(project_path)
    project = Project.find_by_name(project_name)
    project.view_templates.delete_all
    file_extensions = "erb,haml"
    Dir.glob(project_path.join("**", "*.{#{file_extensions}}")).each do |full_path|
      path = Pathname.new(full_path).relative_path_from(project_path)
      v = project.view_templates.new
      file = File.open(full_path)
      v.contents = file.read
      pieces = path.to_s.split(".")
      v.path = "#{project.name}/#{pieces.shift}"
      v.handlers = pieces.pop
      v.formats = pieces.last
      v.locale = "en"
      v.save!
      # TODO: Handle template save validation errors
    end
  end
end