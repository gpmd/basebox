# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

# Load config file
CONF = YAML.load_file('vagrant-config.yml')

# Config variables
projectName = CONF['project_name']
hostName = CONF['host_name']
syncedDirectory = CONF['synced_directory']
webRoot = CONF['web_root']
vmProvider = CONF['vm_provider']
boxType = CONF['box_type']
boxMemory = CONF['box_memory']
boxCpus = CONF['box_cpus']
ipAddress = CONF['ip_address']

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

    # box type
    config.vm.box = boxType

    # box settings
    config.vm.provider vmProvider do |vb|
        vb.name = projectName
        vb.memory = boxMemory
        vb.cpus = boxCpus
    end

    ## IP to access box
    config.vm.network "private_network", ip: ipAddress

    # Synced directory
    config.vm.synced_folder "#{syncedDirectory}", "/var/www/#{hostName}/", :mount_options => ["dmode=777", "fmode=777"]

    ## Bootstrap script to provision box
    config.vm.provision "shell" do |s|
        s.path = "bootstrap.sh"
        s.args   = [hostName,webRoot]
    end
end
