# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure('2') do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = 'ubuntu/bionic64'

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # To fix vagrant stopping at ssh
  # Have a look at https://github.com/hashicorp/vagrant/issues/8157 for more details or solutions
  config.vm.provider 'virtualbox' do |vb|
    vb.customize ['modifyvm', :id, '--cableconnected1', 'on']
  end
  # If the error still happens, you might want to try and uncomment the next line
  # config.vm.network "forwarded_port", guest: 22, host: 2222, host_ip: "127.0.0.1", id: 'ssh'

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  config.vm.network 'forwarded_port', guest: 3000, host: 3000
  # in the host, call this as http://0.0.0.0:3000 or http://localhost:3000

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  config.vm.provision 'shell', inline: <<-SHELL
    # first installation of requirements, this will run only once even if you change this file
    # installing ruby + postgres
    sudo apt-get update -y
    sudo apt-get install nodejs -y
    sudo ln -sf /usr/bin/nodejs /usr/local/bin/node
    sudo apt install postgresql postgresql-contrib libpq-dev -y    # for postgres
    sudo -u postgres createuser vagrant -s                         # permissions for postgres

    # And then install rvm (https://www.phusionpassenger.com/library/walkthroughs/deploy/ruby/ownserver/nginx/oss/install_language_runtime.html)
    # and get the server running!
    # This is commented out to make my life easier (not a Vagrant expert)
    # but as soon as you log into vagrant, you can run this commands and it should give you a working environment
      # cd /vagrant
      # gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
      # curl -sSL https://get.rvm.io | sudo bash -s stable
      # sudo usermod -a -G rvm `whoami`
      ## relogin to the server (you can logout and login to vagrant ssh again)
      #  cd /vagrant
      #  rvm install 2.4.1
      #  gem install bundler --no-rdoc --no-ri
      #  gem install pkg-config
      #  bundle install
      #  rake db:create db:migrate
      ## https://putshello.wordpress.com/2015/03/03/easy-rails-with-vagrant-virtualbox-on-windows/
      #  bundle exec rails s -b 0.0.0.0
      ## server is running now in your browser http://127.0.0.1:3000/
  SHELL
end
