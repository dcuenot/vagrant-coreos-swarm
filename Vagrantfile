# -*- mode: ruby -*-
# vi: set ft=ruby :

# Specify Vagrant version and Vagrant API version
Vagrant.require_version ">= 1.6.0"
VAGRANTFILE_API_VERSION = "2"

# Require 'yaml', 'fileutils', and 'erb' modules
require 'yaml'

# Read YAML file with VM details (box, CPU, RAM, IP addresses)
# Be sure to edit servers.yml to provide correct IP addresses
servers = YAML.load_file('servers.yml')

# Create and configure the VMs
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.provider "virtualbox"
  
  # set auto_update to false, if you do NOT want to check the correct 
  # additions version when booting this machine
  config.vbguest.auto_update = true

  # do NOT download the iso file from a webserver
  config.vbguest.no_remote = true
 
  # Iterate through entries in YAML file to create VMs
  servers.each do |servers|
    config.vm.define servers["name"] do |srv|
      # Don't check for box updates
      # srv.vm.box_check_update = false
      srv.vm.hostname = servers["name"]
      srv.vm.box = servers["box"]
      
      # Assign an additional static private network
      srv.vm.network "private_network", ip: servers["priv_ip"]
      
      # Configure VMs with RAM and CPUs per settings in servers.yml
      srv.vm.provider :virtualbox do |vb|
        vb.name   = servers["name"]
        vb.memory = servers["ram"]
        vb.cpus   = servers["vcpu"]
      end
      
      
      # Activate default synced folder for CoreOS VMs
      srv.vm.synced_folder ".", "/vagrant"

      config.vm.provision :shell, inline: servers["shell"]
      
    end
  end
end


#REF
# docker run -d --name etcd -p 4001:4001 -p 7001:7001 coreos/etcd

# reference:4001/v2/keys/?recursive=true
#

# docker run -d -p 5000:5000 -v /vagrant/registry:/tmp/registry --name=registry registry

#Nodes Jenkins
# docker run -d swarm join --addr=192.168.101.110:2375 etcd://reference:4001/swarm
# Jenkins master
# docker run -t -p 2121:2375 -t swarm manage etcd://reference:4001/swarm

# Swarm 1 working :
# docker -H tcp://jenkins-master:2121 info 
