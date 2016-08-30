# Vagrant Basebox

> A simple shell script bootstrapped Vagrant box

Two sample bootstrap files are included. The primary difference between the two is that one installs PHP 5.6 and the other PHP 7. If you want to know what else they install have a look in [bootstrap-sample-php56.sh](https://github.com/gpmd/basebox/blob/master/bootstrap-sample-php56.sh) and [bootstrap-sample-php7.sh](https://github.com/gpmd/basebox/blob/master/bootstrap-sample-php7.sh).

## Instructions

### 1. Config

Create a `vagrant-config.yaml`. A sample file is provided containing the following defaults:

```yaml
project_name: 'Basebox'
host_name: 'basebox'
db_name: 'basebox'
synced_directory: './'
web_root: 'public_html/'
vm_provider: 'virtualbox'
box_type: 'ubuntu/trusty64'
box_memory: '4096'
box_cpus: '2'
ip_address: '192.168.33.10'
```

To see how each of these options is mapped, have a look at the **Other Info** section below.

**IMPORTANT:** You must create a webroot directory before you `vagrant up`.

### 2. Choose/create a bootstrap.sh file

Use one of the supplied example files and rename it to `bootstrap.sh`, or create your own - it's just a shell script.

### 3. Create the VM

Run `vagrant up`.

### 4. Create a vhost on your host machine

Add a vhost record on your host machine pointing to the `<web_root>`, domain name (`<host_name>.dev`) and `<ip_address>` you specified in the config file.

### 5. Log into VM

Run `vagrant ssh`.

## Other Info

The `Vagrantfile` provisions the VM, and `bootstrap.sh` installs all the 'things' - modify to your hearts content.

+ Project root in VM: `/var/www/<host_name>/`
+ Web root in VM: `/var/www/<host_name>/<web_root>`
+ Database Username: `root`
+ Database Password: (none)
+ Database Name: `<db_name>`
+ URL of Instance: `http://<ip_address>/<host_name>/`
+ Host File Configuration: `<ip_address> www.<host_name>.dev <host_name>.dev`

---

Based on and inspired by [Vagrant for Magento 2](https://github.com/ryanstreet/magento2-vagrant) by Ryan Street.
