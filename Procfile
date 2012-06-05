web:       bundle exec unicorn -p $PORT -c ./config/unicorn.rb
worker:    bundle exec sidekiq
deployer:  bundle exec sidekiq -c 1 -q deployer