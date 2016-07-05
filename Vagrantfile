# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

# Load config file
CONF = YAML.load_file('vagrant-config.yaml')

# Config variables
projectName = CONF['project_name']
hostName = CONF['host_name']
dbName = CONF['db_name']
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
        vb.customize [
            "storagectl", :id,
            "--name", "SATAController",
            "--hostiocache", "on"
        ]
    end

    # IP to access box
    config.vm.network "private_network", ip: ipAddress

    # Set up ssh forwarding
    config.ssh.forward_agent = true

    # Synced directory
    # Default mount options
    #config.vm.synced_folder "#{syncedDirectory}", "/var/www/#{hostName}/", :mount_options => ["dmode=777", "fmode=777"]
    # NFS mount options for better performance
    config.vm.synced_folder "#{syncedDirectory}", "/var/www/#{hostName}/", type: "nfs", :mount_options => ['rw', 'vers=3', 'udp', 'fsc', 'actimeo=1']

    ## Bootstrap script to provision box
    config.vm.provision "shell" do |s|
        s.path = "bootstrap.sh"
        s.args = [hostName,webRoot,dbName]
    end
end
