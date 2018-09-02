# Whare Hauora Server

Serves a REST api for the Whare Hauora Android application.
Host user sign up, and password resets for end users.


## Contributing

Whare Hauora would love Rails Devs contributing to this. To find somewhere to work on, have a look at Sprint backload in Waffle:
https://waffle.io/WhareHauora/wharehauora-server


## Status

[![Build Status](https://travis-ci.org/WhareHauora/wharehauora-server.svg?branch=master)](https://travis-ci.org/WhareHauora/wharehauora-server)
[![Coverage Status](https://coveralls.io/repos/github/WhareHauora/wharehauora-server/badge.svg?branch=master)](https://coveralls.io/github/WhareHauora/wharehauora-server?branch=master)
[![Code Climate](https://codeclimate.com/github/WhareHauora/wharehauora-server/badges/gpa.svg)](https://codeclimate.com/github/WhareHauora/wharehauora-server)
[![Issue Count](https://codeclimate.com/github/WhareHauora/wharehauora-server/badges/issue_count.svg)](https://codeclimate.com/github/WhareHauora/wharehauora-server)
[![Waffle.io - Columns and their card count](https://badge.waffle.io/WhareHauora/wharehauora-server.svg?columns=all)](https://waffle.io/WhareHauora/wharehauora-server)
[![AwesomeCode Status for WhareHauora/wharehauora-server](https://awesomecode.io/projects/5f56562b-9317-4405-b45d-ec5b7a9b05f5/status)](https://awesomecode.io/projects/57)

Want to contribute? Please give our
[contributing guideliness](docs/CONTRIBUTING.md) a read.
Info on current work is on [our wiki](https://github.com/WhareHauora/wharehauora-server/wiki).

## Installation

There are two ways to set up a dev environment.
You only need to pick one of these:

1. Installing all dependencies (Ruby + Postgres + Bundler) in your machine
1. Using a pre-build vagrant box

### Option one: Ruby + Bundler in your machine

#### Pre-requisites

You need to have these set up in your machine:

* Ruby (See the file `.ruby-version` for the exact version)
* Postgres

#### To set up a development environment

1. Make your own fork, and clone it

    ```bash
    git clone [repo]
    cd wharehauora-server
    git remote add upstream git@github.com:WhareHauora/wharehauora-server.git
    ```

1. Set up environment variables and bundle

    ```bash
    cp env-example .env
    bundle install
    rake db:create db:migrate
    ```

1. Run it

    ```bash
    bundle exec rails s
    ```

### Option two: Vagrant

#### Pre-requisites for Vagrant

You need to have these set up in your machine:

* [Vagrant](https://www.vagrantup.com/)
* [VirtualBox](https://www.virtualbox.org/)

There's a Vagrant file available with automatic provisioning of Ruby + Postgres
to make it easy to set up a dev environment.

#### To set up a development environment with Vagrant

1. Outside of the Vagrant box, make your own fork and clone the repo

    ```bash
    git clone [repo]
    cd wharehauora-server
    git remote add upstream git@github.com:WhareHauora/wharehauora-server.git
    cp env-example .env
    ```

1. Download and provision the box (it will take a while to download,
  but only the first time)

    ```bash
    vagrant up
    ```

1. Access the vagrant box

    ```bash
    vagrant ssh
    ```

1. Only in the first installation of the box, run these instructions
  step by step to install a few other requirements.
  These instructions are also in the [Vagrant file](Vagrantfile) right at the
  end if you want to have a deeper look.

    ```bash
    cd /vagrant     # this is where your code is synced to

    # install rvm
    gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
    curl -sSL https://get.rvm.io | sudo bash -s stable
    sudo usermod -a -G rvm `whoami`
    ```

1. Log out and log in again to vagrant ssh.

    ```bash
    cd /vagrant
    rvm install 2.4.1
    gem install bundler --no-rdoc --no-ri
    gem install pkg-config
    bundle install
    rake db:create db:migrate
    ```

1. Run the server after everything is installed

    ```bash
    bundle exec rails s -b 0.0.0.0
    ```

1. The server will be running now in your machine's browser at `http://127.0.0.1:3000/`

## Populate and fake data

To populate to your database with some records to work with:

```bash
bundle exec rake db:seed
```

to create a continuous stream of incoming fake sensor readings:

```bash
bundle exec rake sensors:fake
```

## To pull the latest changes from upstream

This fill fetch the latest changes on the official wharehauora git repo,
and merge them into your master branch.
Then push those changes up to your own fork.

```bash
git checkout master
git fetch upstream
git merge upstream/master
git push origin master
```

More info on how [github forks work](https://help.github.com/articles/fork-a-repo/).

## Code Quality

We use code linters. These check code adheres to our configured code styles
and standards. If your code doesn't match then the hound bot will comment
on your pull request.

To check code style on your own code before commiting to git,
install the overcommit get

```bash
gem install overcommit
overcommit --install
overcommit --sign
```

This will run the same linters are travis and hound. Note: Sometimes overcommit
configuration doesn't match, and overcommit allows code that will fail on a PR
with hound. When this happens please report as a bug to the wharehauora-server
project.

## How to run the test suite

`bundle exec rspec`

## How to run the code linters

`overcommit -r`

## Deployment

This app is hosted on heroku.

It will be automatically deployed to staging, whenever the `master` branch
changes, and Travis-CI build passes.

Code is manually promoted from staging to produciton (using the button on
heroku)
