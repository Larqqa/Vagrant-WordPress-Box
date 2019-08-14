808# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # Box settings
  config.vm.box = "ubuntu/xenial64"

  # Provider settings
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
    vb.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
  end

  # Network settings #

  # This host needs to match the wp localhost port
  config.vm.network "forwarded_port", guest: 8080, host: 8080

  # These match needed ports for BrowserSync
  config.vm.network "forwarded_port", guest: 3000, host: 3000
  config.vm.network "forwarded_port", guest: 3001, host: 3001
  config.vm.network "forwarded_port", guest: 3002, host: 3002

  # Fallback for using port 80
  config.vm.network "forwarded_port", guest: 80, host: 3003

  # Synced folder
  config.vm.synced_folder "./data", "/var/www/html" , type: "nfs", create: true

  # Provisions #

  # Run commands as root
  config.vm.provision "shell", path: "lamp.sh",
  env: {
    "DBPASSWD" => ENV["DBPASSWD"]
  }

  # Run commands as user
  # This is for running WordPress installation
  # With Aucor starter theme and Aucor core plugin
  config.vm.provision "shell", path: "wp.sh", privileged: false,
  env: {
    "DBPASSWD" => ENV["DBPASSWD"],
    "THEMENAME" => ENV["THEMENAME"],
    "ID" => ENV["ID"],
    "URL" => ENV["URL"],
    "AUTHOR" => ENV["AUTHOR"],
    "AUTHOR_URL" => ENV["AUTHOR_URL"]
  }

end
