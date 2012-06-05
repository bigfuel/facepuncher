source 'http://rubygems.org'

gem 'rails', '3.2.3'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# mongoid
gem 'mongoid'
gem 'bson_ext'
gem 'acts_as_list_mongoid'
gem 'mongoid_taggable_with_context'

gem 'haml'
gem 'haml-rails'
gem 'sass'
gem 'kaminari'
gem 'devise'
gem 'state_machine'
gem 'fog'
gem 'sinatra'
gem 'slim'
gem 'sidekiq'
gem 'koala'
gem 'mini_magick'
gem 'carrierwave'
gem 'carrierwave-mongoid', require: 'carrierwave/mongoid'
gem 'redis-store'
gem 'redis-rails'
gem 'feedzirra', '0.0.24'
gem 'profanity_filter'
gem 'grit', git: 'git://github.com/mojombo/grit.git' # process_info
gem 'validates_timeliness'
gem 'asset_sync'
gem 'database_views'
gem 'carmen'
gem 'retriable'
gem 'pry-rails'
gem 'bootstrap-sass'
gem 'responders'
gem 'ace-rails-ap'
gem 'rabl'
gem 'yajl-ruby'

# Use unicorn as the web server
gem 'unicorn'

group :test do
  gem 'turn'
  gem 'minitest'
  gem 'ffaker'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'simplecov', require: false
  gem 'guard-minitest'
  gem 'minitest-rails', git: 'git://github.com/rawongithub/minitest-rails.git', branch: 'gemspec' #rawongithub
  gem 'capybara_minitest_spec'
  gem 'minitest-matchers'
  gem 'valid_attribute'
  gem 'mocha', require: false
end

group :development do
  gem 'heroku'
  gem 'foreman'
  gem 'rails_best_practices'
  gem 'ruby-graphviz', require: 'graphviz'
  # gem 'metric_fu'
  # gem 'rack-perftools_profiler', :require => 'rack/perftools_profiler'
end

group :development, :test do
  gem 'awesome_print'
  gem 'fabrication'
  gem 'guard'
  gem 'rb-fsevent'
  gem 'ruby_gntp'
  gem 'ruby-prof'
  gem 'pry-nav'
  gem 'pry-stack_explorer'
  # gem 'ruby-debug19', require: 'ruby-debug'
  # gem 'cover_me', '>= 1.0.0.pre2', require: false
end

group :production, :staging do
  gem 'exceptional'
  # gem 'rpm_contrib'
end
