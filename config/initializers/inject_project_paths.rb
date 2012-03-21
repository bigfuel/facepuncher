Rails.application.config.before_configuration do
  asset_directories = ["images", "stylesheets", "javascripts"]

  if Rails.env.development?
    local_assets_path = Rails.root.join("tmp", "local_assets")

    if Dir.exists?(local_assets_path)
      retriable on: Errno::ENOENT, tries: 3, interval: 3 do
        FileUtils.rm_r(local_assets_path, secure: true)
      end
    end

    FileUtils.mkdir_p(local_assets_path)

    project_path_directory = Pathname.new(APP_CONFIG['project_path'])
    asset_directories.each {|asset_dir| FileUtils.mkdir_p(local_assets_path.join(asset_dir))}
    Dir.glob(project_path_directory.join("*")).each do |project_dir|
      asset_directories.each do |asset_dir|
        absolute_project_asset_path = Pathname.new(project_dir).join(asset_dir)
        project_name = project_dir.split("/").last
        unless Dir.exists?(local_assets_path.join(asset_dir, project_name))
          FileUtils.ln_s(absolute_project_asset_path, local_assets_path.join(asset_dir, project_name))
        end
      end
    end
  end

  asset_directories.each do |asset_dir|
    Rails.application.config.assets.paths << local_assets_path.join(asset_dir) if Rails.env.development?
    Rails.application.config.assets.paths << Rails.root.join("tmp", "assets").join(asset_dir)
  end
end
