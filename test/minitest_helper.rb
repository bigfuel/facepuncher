require 'simplecov'
SimpleCov.start 'rails'

require "minitest/matchers"
require "minitest/autorun"
require "minitest/rails"
require "turn"

# Uncomment if you want awesome colorful output
# require "minitest/pride"
Turn.config.format = :outline

ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)

require 'capybara/rails'

class MiniTest::Spec
  before do
    DatabaseCleaner.start
    Rails.cache.clear
  end

  after do
    DatabaseCleaner.clean
    Rails.cache.clear
  end
end

class MiniTest::Rails::Spec
  # Uncomment if you want to support fixtures for all specs
  # or
  # place within spec class you want to support fixtures for
  # include MiniTest::Rails::Fixtures


  # Add methods to be used by all specs here
end

class MiniTest::Rails::Model
  # Add methods to be used by model specs here
  include ValidAttribute::Method
end

class MiniTest::Rails::Controller
  # Add methods to be used by controller specs here
  include Devise::TestHelpers

  def json_response
    ActiveSupport::JSON.decode @response.body
  end
end

class MiniTest::Rails::Helper
  # Add methods to be used by helper specs here
end

class MiniTest::Rails::Mailer
  # Add methods to be used by mailer specs here
end

class MiniTest::Rails::Integration
  # Add methods to be used by integration specs here
  include Capybara::DSL

  def sign_in(user)
    page.driver.post user_session_path, 'user[email]' => user.email, 'user[password]' => user.password
  end
end
