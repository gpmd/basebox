#!/usr/bin/env bash

# Add PHP package repo - contains 5.5, 5.6, and 7
echo "--- Adding PHP package repo"
add-apt-repository ppa:ondrej/php

# update
echo "--- Updating APT"
apt-get update

# Install Apache
echo "--- Installing Apache"
apt-get -y install apache2

# enable modrewrite
echo "--- Enabling Apache mod_rewrite"
a2enmod rewrite 

# append AllowOverride to Apache Config File
echo "--- Creating Apache config file"
echo "
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/$1/$2
    ServerName $1.dev
    ServerAlias www.$1.dev

    <Directory '/var/www/$1/$2'>
        Options Indexes FollowSymLinks MultiViews
        AllowOverride All
        Order allow,deny
        allow from all
    </Directory>
</VirtualHost>
" > /etc/apache2/sites-available/$1.conf

echo "ServerName localhost" >> /etc/apache2/apache2.conf 

# Enabling Site
echo "--- Enabling Site"
a2ensite $1.conf

# Setting Locales
echo "--- Setting Locales"
locale-gen en_GB en_GB.UTF-8 pl_PL pl_PL.UTF-8
dpkg-reconfigure locales

# Install MySQL 5.6
echo "--- Installing MySQL"
export DEBIAN_FRONTEND=noninteractive
apt-get -q -y install mysql-server-5.6 mysql-client-5.6

# Create Database instance
echo "--- Creating Database"
mysql -u root -e "create database $1;"

# Install PHP 5.6
echo "--- Installing PHP"
apt-get -y install php5

# Install Required PHP extensions
echo "--- Installing PHP Extensions"
apt-get -y install php5-mhash php5-mcrypt php5-curl php5-cli php5-mysql php5-gd php5-intl php5-common php-pear php5-dev php5-xsl

# Mcrypt issue
echo "--- PHP mcrypt Patch"
php5enmod mcrypt
service apache2 restart

# Set PHP Timezone
echo "--- Setting PHP Timezone"
echo "date.timezone = Europe/London" >> /etc/php5/cli/php.ini

# Cache NFS file access
echo "--- Installing cachefilesd"
apt-get install cachefilesd
echo -e "RUN=yes" | tee -a /etc/default/cachefilesd

# Install Git
echo "--- Installing Git"
apt-get -y install git
# Increase Git performance over NFS
git config --global core.preloadindex true

# Composer Installation
echo "--- Installing Composer"
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

# Front end tools
echo "--- Installing front end tools"

# Node/NPM
curl -sL https://deb.nodesource.com/setup_4.x | bash -
apt-get install -y nodejs
# Self update npm
npm install -g npm

# Grunt
npm install -g grunt-cli

# Bower
npm install -g bower

# Restart apache
echo "--- Restarting Apache"
service apache2 restart

# Post Up Message
echo "Vagrant Box ready!"
