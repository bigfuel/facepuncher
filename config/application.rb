require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
# require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
# require "active_resource/railtie"
require "rails/test_unit/railtie"
require "sprockets/railtie"

# require 'mongoid/railtie' # need this to get the mongoid initializer
require 'rack/cache'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require *Rails.groups(assets: %w(development test staging production))

  # If you want your assets lazily compiled in production, use this line
  Bundler.require(:default, :assets, Rails.env)
end

# Load config/config.yml into APP_CONFIG
APP_CONFIG = YAML.load(ERB.new(IO.read(File.expand_path('../config.yml', __FILE__))).result)[Rails.env]

module Facepuncher
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Eastern Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password, :password_confirmation]

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    # Custom
    config.cache_store = :redis_store, ENV['REDISTOGO_URL'] || APP_CONFIG['redis']
    config.action_controller.asset_host = APP_CONFIG['asset_host'] if APP_CONFIG['asset_host']

    unless %W{development test}.include?(Rails.env)
      config.middleware.insert_before Rack::Cache, Rack::Static, urls: [config.assets.prefix], root: 'public'
      # config.middleware.insert_before Rack::Cache, ::ActionDispatch::Static, 'public', config.static_cache_control
    end

    config.middleware.use ::Rack::PerftoolsProfiler, default_printer: 'gif', bundler: true if defined? ::Rack::PerftoolsProfiler
    # config.middleware.use Rack::Deflater

    config.generators do |g|
      g.template_engine :haml
      g.stylesheet_engine :sass
      g.test_framework :mini_test, spec: true, fixture: false
      g.integration_tool :mini_test
      g.fixture_replacement :fabrication, dir: "test/fabricators"
    end

    config.to_prepare do
      Devise::SessionsController.layout "admin"
      Devise::RegistrationsController.layout "admin"
      Devise::ConfirmationsController.layout "admin"
      Devise::UnlocksController.layout "admin"
      Devise::PasswordsController.layout "admin"
    end
  end
end