worker_processes 3 # amount of unicorn workers to spin up
timeout 30         # restarts workers that hang for 30 seconds
preload_app true
# pid "tmp/pids/unicorn.pid"

after_fork do |server, worker|
  Rails.cache.reconnect
end