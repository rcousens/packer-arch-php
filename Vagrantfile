# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "packer-arch-virtualbox"
  config.vm.box_url = "../build/packer-arch-virtualbox.box"

  config.vm.provider "virtualbox" do |v|
    v.cpus = 2
    v.gui = true
    v.memory = 2048
    v.name = "packer-arch-virtualbox"
    v.customize ["modifyvm", :id, "--rtcuseutc", "on"]
  end

  config.vm.network "private_network", type: "dhcp"

  config.vm.network "forwarded_port", guest: 80, host:8081 # nginx 
  config.vm.network "forwarded_port", guest: 3306, host:8082 # mysql

  config.vm.synced_folder "salt/roots/salt", "/srv/salt"
  config.vm.synced_folder "salt/roots/pillar", "/srv/pillar"
  #config.vm.synced_folder ".", "/srv/http/dev", type: "nfs", mount_options: ["noatime"], linux__nfs_options: ["async", "rw", "no_subtree_check", "all_squash"]
  
  config.vm.provision :salt do |salt|    
    salt.always_install = true
    salt.colorize = true
    #salt.install_args = "develop"
    salt.install_type = "stable"    
    salt.log_level = "info"
    salt.minion_config = "salt/minion"
    salt.run_highstate = true
    salt.verbose = true
  end  
end
