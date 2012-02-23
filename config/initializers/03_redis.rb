rails_root = ENV['RAILS_ROOT'] || File.dirname(__FILE__) + '/../..'
rails_env = ENV['RAILS_ENV'] || 'development'

require 'resque_scheduler'

Dir[File.join(rails_root, 'app', 'jobs', '*.rb')].each { |file| require file }

Resque.redis = APP_CONFIG['redis']

Resque.schedule = YAML.load_file(rails_root + "/config/resque_schedule.yml")