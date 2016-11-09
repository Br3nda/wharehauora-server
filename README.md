Whare Hauora Server
===================

Serves a REST api for the Whare Hauora Android application

Host user sign up, and password resets for end users


Status
------
[![Build Status](https://travis-ci.org/WhareHauora/wharehauora-server.svg?branch=master)](https://travis-ci.org/WhareHauora/wharehauora-server)
[![Coverage Status](https://coveralls.io/repos/github/WhareHauora/wharehauora-server/badge.svg?branch=master)](https://coveralls.io/github/WhareHauora/wharehauora-server?branch=master)
[![Code Climate](https://codeclimate.com/github/WhareHauora/wharehauora-server/badges/gpa.svg)](https://codeclimate.com/github/WhareHauora/wharehauora-server)
[![Issue Count](https://codeclimate.com/github/WhareHauora/wharehauora-server/badges/issue_count.svg)](https://codeclimate.com/github/WhareHauora/wharehauora-server)
[![Stories in Ready](https://badge.waffle.io/WhareHauora/wharehauora-server.png?label=ready&title=Ready)](https://waffle.io/Br3nda/wharehauora-server)

Installation
============

To set up a development environment
-----------------------------------

1. make your own fork, and clone

  `git clone [repo]`

2. `bundle install`

3. `rake db:create db:migrate`

4. `bundle exec rails s`


Code Quality
-------------

We use rubocop, and overcommit. To check code style before commiting to git,
install the overcommit get

`gem install overcommit`


How to run the test suite
-------------------------

`bundle exec rspec`

Deployment
==========

This app is hosted on heroku.

It wil be automatically deploymed to staging, whenevver the `master` branch changes, and Travis-CI build passes.

Production is manually approved, after testing on staging.
