# Vagrant Basebox

> A simple Vagrant box, because most are not...

## Instructions

### 1. Config

Create a `vagrant-config.yml`. A sample file is provided containing the following defaults:

```yaml
project_name: 'Basebox'
host_name: 'basebox'
synced_directory: '../'
vm_provider: 'virtualbox'
box_type: 'ubuntu/trusty64'
box_memory: '4096'
box_cpus: '2'
ip_address: '192.168.33.10'
```

**Note:** I sync one level up from the `site` directory as I tend to include a `data` or `shared` directory there that contains config files, media assets etc.

### 2. Create the VM

Run `vagrant up`.

### 3. Create a vhost on your host machine

Add a vhost record on your host machine pointing to the `public_html/` directory, domain name (`<host_name>.dev`) and `<ip_address>` you specified in the config file

### 4. Log into VM

Run `vagrant ssh`.

## Other Info

The `Vagrantfile` provisions the VM, and `bootstrap.sh` installs all the 'things' - modify to your hearts content.

Project root in VM: `/var/www/<host_name>/`
Web root in VM: `/var/www/<host_name>/site/public_html/`
Database Username: `root`
Database Password: (none)
Database Name: `<host_name>`
URL of Instance: `http://<ip_address>/<host_name>/`
Host File Configuration: `<ip_address> www.<host_name>.dev <host_name>.dev`
