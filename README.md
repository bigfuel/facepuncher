Facepuncher
================================

Welcome to a Punch in the Face! Facepuncher is a platform for quickly bootstrapping deploying Facebook tabs.

Requirements
------------
Rails 3.2
MongoDB 1.8+
Redis 2.4+
git
ssh

Setup
-----

To setup Facepuncher:

    git clone git@github.com:bigfuel/facepuncher.git
    cd facepuncher
    bundle

Configure app and databases:

Rename config files:

    mv config/config.yml.example config/config.yml
    mv config/mongoid.yml.example config/mongoid.yml

and optionally:

    mv config/newrelic.yml.example config/newrelic.yml

Modify the configuration files to match your environment.

Setup the database:

    rake db:setup

Start the applicaiton:

    foreman start

Project repositories
--------------------

Facepuncher supports both `https` and `git` protocols for project repositories. The `https` protocol may require a username and password if it's a private repository, or if there's http authentication on top of the repo:

    https://username:password@github.com/bigfuel/example_private_repo.git

At Big Fuel we have private repositories on Github and Bit Bucket. What we do is create a deploy specific read-only account and we reference that in repository urls.

If you must use the `git` protocol, then you must install an SSH key and a known_hosts file with the host fingerprint of the repository's host. Add these to `vendor/support/.ssh` and they will be copied to your production environment upon deployment.

Resque workers
--------------

This application also requires resque and resque-scheduler workers to be started. These workers process background jobs, such as deployng project releases.

You should run this in a separate terminal window. The VERBOSE=1 option tells it to provide more debugging information so you know what's going on.

    VERBOSE=1 QUEUE=* rake resque:work

The scheduler worker schedules jobs that take place at later or at regular intervals.

    VERBOSE=1 rake resque:scheduler

