require 'fileutils'
require 'asset_sync'
require 'sprockets'

module Deploy
  ASSETS_PATH = Rails.root.join("tmp", "assets")
  PROJECTS_PATH = Rails.root.join("tmp", "projects")
  NUM_RETRIES = 3

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

    config = Rails.application.config

    # copy ssh keys
    # TODO: move this to an initializer
    FileUtils.cp_r(Rails.root.join('vendor', 'support', '.ssh'), ENV['HOME']) unless Dir.exists?(Pathname(ENV['HOME']).join(".ssh"))

    begin
      # set git clone path
      project_path = PROJECTS_PATH.join(project.name)

      # clone repo
      clone_repo(project_path, project.repo, release.branch)

      # TODO: Alert people

      begin
        copy_assets(project.name, project_path, ASSETS_PATH)
      rescue Timeout::Error => e
        release.status = e.message
        release.save
        raise
      end

      compile_assets(project.name)

      self.generate_views(project.name, project_path)

      release.go_live
      project.touch
    rescue => e
      release.status = e.message
      release.save
      raise
    end
  end

  def self.clone_repo(project_path, repo, branch)
    # clear temp git clone path
    FileUtils.rm_r(project_path, secure: true) if Dir.exists?(project_path)
    FileUtils.mkdir_p(project_path)

    # initialize grit
    grit = Grit::Git.new(project_path.to_s)

    result = ""
    # clone the release repo/branch, retry if it fails
    retriable on: [Timeout::Error, Grit::Git::GitTimeout], tries: NUM_RETRIES, interval: 1 do
      result = grit.clone({depth: 1, quiet: false, verbose: true, progress: true, branch: branch}, repo, project_path)
      raise Timeout::Error, "Couldn't clone repo. Please check the repo and branch and make sure they are correct" unless Dir.exists?(project_path)
    end

    result
  end

  def self.copy_assets(project_name, source_root_path, dest_root_path)
    FileUtils.mkdir_p(ASSETS_PATH)
    ["images", "stylesheets", "javascripts"].each do |dir|
      dest_path = dest_root_path.join(dir, project_name)
      FileUtils.rm_r(dest_path, secure: true) if Dir.exists?(dest_path)
      FileUtils.mkdir_p(dest_path)
      source_path = "#{source_root_path}/#{dir}/."
      FileUtils.cp_r(source_path, dest_path)
    end
  end

  def self.compile_assets(project_name)
    config = Rails.application.config
    public_asset_path = File.join(Rails.public_path, config.assets.prefix)
    FileUtils.rm_r(public_asset_path, secure: true)
    FileUtils.mkdir_p(public_asset_path)

    manifest_path = config.assets.manifest ? Pathname.new(config.assets.manifest).join(project_name) : Pathname.new(public_asset_path).join(project_name)
    manifest = File.join(manifest_path, "manifest.yml")
    compiler = Sprockets::StaticCompiler.new(Rails.application.assets,
                                             public_asset_path,
                                             config.assets.precompile,
                                             manifest_path: manifest_path,
                                             digest: true,
                                             manifest: true)

    compiler.compile

    # config.assets.digests = YAML.load_file(manifest) if File.exists?(manifest)
    # PageController.subclasses.each do |c|
    #   c.view_paths.each(&:clear_cache)
    # end

    raise "Couldn't find manifest.yml" unless File.exists?(manifest)
    AssetSync.sync
    Rails.cache.write("digests:#{project_name}", YAML.load_file(manifest))
  end

  def self.generate_views(project_name, project_path)
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