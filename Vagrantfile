# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
    config.ssh.insert_key = false
    config.vm.synced_folder '.', '/vagrant'
  
    # VirtualBox.
    config.vm.define "virtualbox" do |virtualbox|
      virtualbox.vm.hostname = "base-ubuntu2004"
      virtualbox.vm.box = "file://build/local-ubuntu2004.box"
      virtualbox.vm.network :private_network, ip: "172.16.3.21"
  
      config.vm.provider :virtualbox do |v|
        v.name = "local_ubuntu2004"
        v.gui = false
        v.memory = 4096
        v.cpus = 2
        v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        v.customize ["modifyvm", :id, "--ioapic", "on"]
      end
  
      config.vm.provision "shell", inline: "echo Hello, World"
    end
  
  end