redis = ENV['REDISTOGO_URL'] || APP_CONFIG['redis']

Sidekiq.configure_server do |config|
  config.redis = { url: redis, size: 10 }
  require 'sidekiq/middleware/server/unique_jobs'
  config.server_middleware do |chain|
    chain.add Sidekiq::Middleware::Server::UniqueJobs
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: redis, size: 1 }
  require 'sidekiq/middleware/client/unique_jobs'
  config.client_middleware do |chain|
    chain.add Sidekiq::Middleware::Client::UniqueJobs
  end
end
