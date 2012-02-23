#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require Rails.root.join('config', 'initializers', '01_airbrake') # hack for https://github.com/thoughtbot/airbrake/pull/12

Facepuncher::Application.load_tasks
