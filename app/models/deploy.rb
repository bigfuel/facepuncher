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

    assets_dir = Rails.root.join('tmp', 'project_assets').to_s
    FileUtils.rm_r(assets_dir, secure: true) if Dir.exists?(assets_dir)
    FileUtils.mkdir_p(assets_dir)

    Dir.mktmpdir(project.name) do |project_dir|

      begin
        # clone repo
        clone_repo(project_dir, project.repo, release.branch)

        # TODO: Alert people
        begin
          copy_assets(project_dir, File.join(assets_dir, project.name))
        rescue Timeout::Error => e
          release.status = e.message
          release.save
          raise
        end

        compile_assets(project.name, assets_dir)

        generate_views(project.name, project_dir)

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

  def self.compile_assets(project_name, assets_dir)
    app = Rails.application
    public_asset_path = File.join(Rails.public_path, app.config.assets.prefix)

    assets = app.assets.index.instance_variable_get(:@environment)
    manifest_path = File.join(app.config.assets.manifest || public_asset_path, project_name)

    FileUtils.rm_r(public_asset_path, secure: true) if Dir.exists?(public_asset_path)
    FileUtils.mkdir_p(public_asset_path)

    compiler = Sprockets::StaticCompiler.new(assets.index,
                                             public_asset_path,
                                             app.config.assets.precompile,
                                             manifest_path: manifest_path,
                                             digest: !Rails.env.development?,
                                             manifest: true)

    compiler.compile

    manifest = File.join(manifest_path, "manifest.yml")
    raise "Couldn't find manifest.yml" unless File.exists?(manifest)

    AssetSync.dup.sync unless Rails.env.development?
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