Facepuncher
================================

Welcome to a Punch in the Face!

Setup
-----

To setup this Rails 3 application:

    git clone git@github.com:bigfuel/facepuncher.git
    cd facepuncher
    bundle
    rake db:setup
    foreman start

Resque workers
--------------

This application also requires resque and resque-scheduler workers to be started. These workers process background jobs, such as deployng project releases.

You should run this in a separate terminal window. The VERBOSE=1 option tells it to provide more debugging information so you know what's going on.

    VERBOSE=1 QUEUE=* rake resque:work

The scheduler worker schedules jobs that take place at later or at regular intervals.

    VERBOSE=1 rake resque:scheduler

