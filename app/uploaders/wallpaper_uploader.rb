# encoding: utf-8

class WallpaperUploader < ImageUploader
  version :thumb do
    process :resize_to_limit => [90, 56]
  end

  version :preview do
    process :resize_to_limit => [270, 169]
  end

  version :gallery do
    process :resize_to_limit => [490, 306]
  end
end
