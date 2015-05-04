# -*- mode: ruby -*-
# vi: set ft=ruby :

# Specify Vagrant version and Vagrant API version
Vagrant.require_version ">= 1.6.0"
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
 
  config.vm.define "vertxdev" do |a|
    a.vm.provider "docker" do |d|
      d.image = "vertxdev:latest"
      d.ports = ["8080:8080"]
      d.name = "vertxdev"
      d.remains_running = true
      d.cmd = ["vertx", "run", "vertx-examples/src/raw/java/httphelloworld/HelloWorldServer.java"]
      d.volumes = ["/src/vertx/:/usr/local/src"]
      d.vagrant_machine = "dockerhost"
      d.vagrant_vagrantfile = "./DockerHostVagrantfile"
    end
  end
 
  config.vm.define "vertxdev-client" do |a|
    a.vm.provider "docker" do |d|
      d.image = "vertxdev:latest"
      d.name = "vertxdev-client"
      d.link("vertxdev:vertxdev")
      d.remains_running = false
      d.cmd = ["wget","-qO", "-","--save-headers","http://vertxdev:8080"]
      d.vagrant_machine = "dockerhost"
      d.vagrant_vagrantfile = "./DockerHostVagrantfile"
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
