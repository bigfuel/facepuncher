CarrierWave.configure do |config|
  config.permissions = 0666
  config.storage = :fog
  config.fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => APP_CONFIG['aws_access_key_id'],
    :aws_secret_access_key  => APP_CONFIG['aws_secret_access_key']
  }
  config.fog_directory = APP_CONFIG['s3_bucket']
  config.fog_public = true
  config.cache_dir = "#{Rails.root}/tmp/uploads"

  config.fog_host = "https://#{APP_CONFIG['uploader_host']}"
end