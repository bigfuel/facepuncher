if defined? Airbrake
  Airbrake.configure do |config|
    config.api_key = ENV['AIRBRAKE_API_KEY'] || APP_CONFIG['airbrake_api_key']
  end
end