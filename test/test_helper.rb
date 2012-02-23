require 'simplecov'
SimpleCov.start 'rails'

ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require "minitest/autorun"
require 'capybara/rails'
require 'rails/test_help'

class Test::Unit::TestCase
  include RR::Adapters::TestUnit
end

class ActiveSupport::TestCase
  # Add more helper methods to be used by all tests here...
  setup do
    Mongoid.master.collections.select {|c| c.name !~ /system/ }.each { |c| c.drop }
    Resque.redis.flushall
    Rails.cache.clear
  end

  teardown do
    Mongoid.master.collections.select {|c| c.name !~ /system/ }.each { |c| c.drop }
    Resque.redis.flushall
    Rails.cache.clear
  end
end

class ActionController::TestCase
  include Devise::TestHelpers

  def json_response
    ActiveSupport::JSON.decode @response.body
  end
end

# Transactional fixtures do not work with Selenium tests, because Capybara
# uses a separate server thread, which the transactions would be hidden
# from. We hence use DatabaseCleaner to truncate our test database.
DatabaseCleaner.strategy = :truncation

class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL

  # Stop ActiveRecord from wrapping tests in transactions
  # self.use_transactional_fixtures = false

  teardown do
    DatabaseCleaner.clean       # Truncate the database
    Capybara.reset_sessions!    # Forget the (simulated) browser state
    Capybara.use_default_driver # Revert Capybara.current_driver to Capybara.default_driver
  end
end