Whare Hauora Server
===================

Serves a REST api for the Whare Hauora Android application

Host user sign up, and password resets for end users


Status
------
[![Build Status](https://travis-ci.org/WhareHauora/wharehauora-server.svg?branch=master)](https://travis-ci.org/WhareHauora/wharehauora-server)


Installation
============

To set up a development environment
-----------------------------------

1. make your own fork, and clone

  `git clone [repo]`

2. `bundle install`

3. `rake db:create db:migrate`

4. `bundle exec rails s`


How to run the test suite
-------------------------

`bundle exec rspec`

Deployment
==========

This app is hosted on heroku. 

It wil be automatically deploymed to staging, whenevver the `master` branch changes, and Travis-CI build passes.

Production is manually approved, after testing on staging.
