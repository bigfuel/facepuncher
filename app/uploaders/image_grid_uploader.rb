# encoding: utf-8

class ImageGridUploader < ImageUploader
  version :thumb do
    process :resize_to_fill => [107, 60]
  end

  version :large do
    process :resize_to_limit => [355, 200]
  end
end
