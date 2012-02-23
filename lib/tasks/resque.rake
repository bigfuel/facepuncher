require 'resque/tasks'
require 'resque_scheduler/tasks'

task "resque:setup" => :environment do
  ENV['QUEUE'] = '*'

  Resque.after_fork do |job|
    Mongoid.master.connection.connect
  end
end