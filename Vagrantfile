# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
vagrantfile_api_version = "2"

# directory name is used for the VM hostname, and ansible role name
base_dir = File.basename(File.expand_path(File.dirname __FILE__))

# definitions for the machines provisioned by this vagrant file
box_params = {
    box: 'ubuntu-18.04',
    hostname: "#{base_dir.gsub('_', '-')}.local",
    playbook: 'playbook.yml',
    galaxy_role_file: 'dependencies.yml'
}

# make the vagrant machine(s)
Vagrant.configure(vagrantfile_api_version) do |config|
  config.vm.define box_params.fetch(:hostname) do |box|

    # specify the box, hostname, and ip address
    box.vm.box = box_params.fetch :box
    box.vm.hostname = box_params.fetch :hostname

    # create a random IP address using the hostname as a seed
    prng = Random.new(box_params.fetch(:hostname).bytes.join.to_i)
    box.vm.network :private_network, ip: "172.16.#{prng.rand(5...255)}.#{prng.rand(2...255)}"
    # box.vm.network "forwarded_port", guest: 80, host: 8080

    # give the box some resources
    box.vm.provider 'virtualbox' do |v|
      v.memory = 2048
      v.cpus = 2
    end

    # forward the ssh agent for things like git
    box.ssh.forward_agent = true

    # mount the base dir in /home/vagrant/src instead of /vagrant
    config.vm.synced_folder ".", "/vagrant", disabled: true
    config.vm.synced_folder ".", "/home/vagrant/src/#{base_dir}", owner: 'vagrant', group: 'vagrant'

    # Install Docker
    box.vm.provision "shell", path: "scripts/install-docker.sh"

  end # config.vm.define
end # Vagrant.configure
