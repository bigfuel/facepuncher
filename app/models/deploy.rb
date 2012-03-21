require 'fileutils'
require 'asset_sync'
require 'sprockets'

module Deploy
  ASSETS_PATH = Rails.root.join("tmp", "assets")

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
      begin
        # clone repo
        clone_repo(project_dir, project.repo, release.branch)

        # TODO: Alert people

        begin
          copy_assets(project.name, project_dir, ASSETS_PATH)
        rescue Timeout::Error => e
          release.status = e.message
          release.save
          raise
        end

        compile_assets(project.name)

        self.generate_views(project.name, project_dir)

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

  def self.copy_assets(project_name, source_root_path, dest_root_path)
    ["images", "stylesheets", "javascripts"].each do |dir|
      dest_path = Pathname.new(dest_root_path).join(dir, project_name)
      FileUtils.rm_r(dest_path, secure: true) if Dir.exists?(dest_path)
      FileUtils.mkdir_p(dest_path)
      source_path = "#{source_root_path}/#{dir}/."
      FileUtils.cp_r(source_path, dest_path)
    end
  end

  def self.compile_assets(project_name)
      config = Rails.application.config
      public_asset_path = File.join(Rails.public_path, config.assets.prefix)

      manifest_path = config.assets.manifest ? Pathname.new(config.assets.manifest).join(project_name) : Pathname.new(public_asset_path).join(project_name)
      manifest = File.join(manifest_path, "manifest.yml")

      compiler = Sprockets::StaticCompiler.new(Rails.application.assets,
                                               public_asset_path,
                                               config.assets.precompile,
                                               manifest_path: manifest_path,
                                               digest: true,
                                               manifest: true)

      retriable on: Errno::ENOENT, tries: 5 do
        compiler.compile
      end

      # config.assets.digests = YAML.load_file(manifest) if File.exists?(manifest)
      # ProjectsController.view_paths.each(&:clear_cache)

      raise "Couldn't find manifest.yml" unless File.exists?(manifest)
      AssetSync.sync
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