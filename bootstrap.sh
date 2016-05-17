#!/usr/bin/env bash

# update
echo "--- Updating APT"
apt-get update

# Install Apache
echo "--- Installing Apache"
apt-get -y install apache2

# Creating folder
echo "--- Setting Folder Permissions"
chmod 0777 -R /var/www/$1

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

# Set Pecl php_ini location
echo "--- Configuring PECL"
pear config-set php_ini /etc/php5/apache2/php.ini

# Install Xdebug
echo "--- Installing Xdebug"
pecl install xdebug

# Install Pecl Config variables
echo "--- Configuring Xdebug"
echo "xdebug.remote_enable = 1" >> /etc/php5/apache2/php.ini
echo "xdebug.remote_connect_back = 1" >> /etc/php5/apache2/php.ini

# Install Git
echo "--- Installing Git"
apt-get -y install git

# Composer Installation
echo "--- Installing Composer"
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

# Other dependencies and build tools

# Curl
sudo apt-get update
sudo apt-get install curl

# Bzip2
sudo apt-get install bzip2

# Node/NPM
curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
sudo apt-get install -y nodejs

# Grunt
sudo npm install -g grunt-cli

# Gulp
sudo npm install -g gulp-cli

# Bower
sudo npm install -g bower

# Set Ownership and Permissions
echo "--- Setting ownership and permissions"
chown -R www-data /var/www/$1/
find /var/www/$1/ -type d -exec chmod 700 {} \;
find /var/www/$1/ -type f -exec chmod 600 {} \;

# Restart apache
echo "--- Restarting Apache"
service apache2 restart

# Post Up Message
echo "Vagrant Box ready!"
