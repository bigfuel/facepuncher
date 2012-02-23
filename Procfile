web:    bundle exec unicorn -p $PORT -c ./config/unicorn.rb
worker: bundle exec rake resque:work QUEUE=deploy_project --trace
clock:  bundle exec rake resque:scheduler --trace