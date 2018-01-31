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
[![Stories in Ready](https://badge.waffle.io/WhareHauora/wharehauora-server.png?label=ready&title=Ready)](https://waffle.io/WhareHauora/wharehauora-server)
[ ![AwesomeCode Status for WhareHauora/wharehauora-server](https://awesomecode.io/projects/5f56562b-9317-4405-b45d-ec5b7a9b05f5/status)](https://awesomecode.io/projects/57)

Installation
============

To set up a development environment
-----------------------------------

1. make your own fork, and clone
  `git clone [repo]`

1. `cd wharehauora-server`

1. Add project upstream
  `git remote add upstream git@github.com:WhareHauora/wharehauora-server.git`

1. Set up environment variables
  `cp env-example .env`

1. `bundle install`

1. `rake db:create db:migrate`

1. `bundle exec rails s`


To populate to your database with some records to work with:

```
bundle exec rake db:seed
```

to create a continuous stream of incoming fake sensor readings:

```
bundle exec rake sensors:fake
```

To pull the latest changes from upstream
-----------------------------------------

This fill fetch the latest changes on the official wharehauora git repo, and merge them into
your master branch. Then push those changes up to your own fork.


```
git checkout master
git fetch upstream
git merge upstream/master
git push origin master
```

More info on how github forks work:
https://help.github.com/articles/fork-a-repo/


Code Quality
-------------

We use code linters. These check code adheres to our configured code styles and standards.
If your code doesn't match then the hound bot will comment on your pull request.

To check code style on your own code before commiting to git, install the overcommit get

```
gem install overcommit
overcommit --install
overcommit --sign
```

This will run the same linters are travis and hound. Note: Sometimes overcommit configuration
doesn't match, and overcommit allows code that will fail on a PR with hound. When this
happens please report as a bug to the wharehauora-server project.


How to run the test suite
-------------------------

`bundle exec rspec`


How to run the code linters
---------------------------

`overcommit -r`


Deployment
==========

This app is hosted on heroku.

It wil be automatically deployed to staging, whenever the `master` branch changes, and Travis-CI build passes.

Code is manually promoted from staging to produciton (using the button on heroku)
