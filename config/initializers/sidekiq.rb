redis = ENV['REDISTOGO_URL'] || APP_CONFIG['redis']

Sidekiq.configure_server do |config|
  config.redis = { url: redis, size: 10 }
end

Sidekiq.configure_client do |config|
  config.redis = { url: redis, size: 1 }
end