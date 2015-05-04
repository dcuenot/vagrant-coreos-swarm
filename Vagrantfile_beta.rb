# -*- mode: ruby -*-
# vi: set ft=ruby :

# Specify Vagrant version and Vagrant API version
Vagrant.require_version ">= 1.6.0"
VAGRANTFILE_API_VERSION = "2"

# Require 'yaml', 'fileutils', and 'erb' modules
require 'yaml'
require 'fileutils'
require 'erb'

# Look for user-data file to configure/customize CoreOS boxes
# No changes should need to be made to this file
USER_DATA = File.join(File.dirname(__FILE__), "user-data")

# Read YAML file with VM details (box, CPU, RAM, IP addresses)
# Be sure to edit servers.yml to provide correct IP addresses
servers = YAML.load_file('servers.yml')

# Use config from YAML file to write out templates for etcd overrides
# template = File.join(File.dirname(__FILE__), 'etcd.defaults.erb')
# content = ERB.new File.new(template).read


# Create and configure the VMs
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Always use Vagrant's default insecure key
  config.ssh.insert_key = false

  config.vm.provider "virtualbox"
 
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
      
      # Configure VMs based on CoreOS box
      if srv.vm.box == "coreos-stable"
        srv.vm.box_url = "http://stable.release.core-os.net/amd64-usr/current/coreos_production_vagrant.json" 
        # Disable default synced folder for CoreOS VMs
        srv.vm.synced_folder ".", "/vagrant", disabled: false
        # Copy user_data file into CoreOS VM
        srv.vm.provision "file", source: "#{USER_DATA}", destination: "/tmp/vagrantfile-user-data"
        # Move user_data to correct location to be processed by cloud-init
        srv.vm.provision "shell", inline: "mv /tmp/vagrantfile-user-data /var/lib/coreos-vagrant/", privileged: true
      end
    end
  end
end


#REF
# docker run -d --name etcd -p 4001:4001 -p 7001:7001 coreos/etcd

# reference:4001/v2/keys/?recursive=true
#

# docker run -d -p 5000:5000 -v /tmp/registry:/tmp/registry --name=registry registry

#Nodes Jenkins
#docker run -d swarm join --addr=192.168.101.110:2375 etcd://reference:4001/swarm
# Jenkins master
# docker run -t -p 2121:2375 -t swarm manage etcd://reference:4001/swarm

# Swarm 1 working :
# docker -H tcp://jenkins-master:2121 info 
