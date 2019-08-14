#! /usr/bin/env bash

echo -e "<::::: INSTALLING LAMP STACK :::::>"

echo -e "You can find the installation logs in data/vm_build.log"

echo -e "\n ---- 1 / 12 Updating Ubuntu ----"
# Update Ubuntu
apt-get -qq update
apt-get -qq upgrade

echo -e "\n ---- 2 / 12 Setting MySQL & PHPMyAdmin settings ----"
# Set MySQL params
debconf-set-selections <<< "mysql-server mysql-server/root_password password $DBPASSWD"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $DBPASSWD"

# Set PHPMyAdmin params
debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $DBPASSWD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $DBPASSWD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $DBPASSWD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect none"

echo -e "\n ---- 3 / 12 Installing Apache, MySQL & PHPMyAdmin ----"
apt-get install -y mysql-server phpmyadmin apache2 >> /var/www/html/vm_build.log 2>&1  || { echo 'Something went wrong, check the vm_build.log in ./data' ; exit 1; }

echo -e "\n ---- 4 / 12 Installing some other packages ----"
apt-get install -y git curl build-essential python-software-properties >> /var/www/html/vm_build.log 2>&1  || { echo 'Something went wrong, check the vm_build.log in ./data' ; exit 1; }

echo -e "\n ---- 5 / 12 Enabling mod-rewrite ----"
# Enable Apache Mods
a2enmod rewrite >> /var/www/html/vm_build.log 2>&1  || { echo 'Something went wrong, check the vm_build.log in ./data' ; exit 1; }

echo -e "\n ---- 6 / 12 Adding Ondrej's PPA ----"
# Add Onrej PPA Repo & update. Needed for PHP 7.2 installation
LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php >> /var/www/html/vm_build.log 2>&1  || { echo 'Something went wrong, check the vm_build.log in ./data' ; exit 1; }
apt-get -qq update

echo -e "\n ---- 7 / 12 Installing PHP & mods ----"
# Install PHP & mods
apt-get install -y php7.2 libapache2-mod-php7.2 php7.2-common php7.2-zip php7.2-mysql >> /var/www/html/vm_build.log 2>&1  || { echo 'Something went wrong, check the vm_build.log in ./data' ; exit 1; }


echo -e "\n ---- 8 / 12 Adding Apache rules ----"
# Allow Apache override to all
sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/apache2.conf

# Turn on PHP errors
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.0/apache2/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.0/apache2/php.ini

echo -e "\n ---- 9 / 12 Restarting Apache ----"
# Restart Apache
service apache2 restart >> /var/www/html/vm_build.log 2>&1  || { echo 'Something went wrong, check the vm_build.log in ./data' ; exit 1; }

echo -e "\n ---- 10 / 12 Installing WP-CLI ----"
# Install WP-CLI
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar >> /var/www/html/vm_build.log 2>&1  || { echo 'Something went wrong, check the vm_build.log in ./data' ; exit 1; }
chmod +x wp-cli.phar >> /var/www/html/vm_build.log 2>&1  || { echo 'Something went wrong, check the vm_build.log in ./data' ; exit 1; }
mv wp-cli.phar /usr/local/bin/wp >> /var/www/html/vm_build.log 2>&1  || { echo 'Something went wrong, check the vm_build.log in ./data' ; exit 1; }

echo -e "\n ---- 11 / 12 Installing NodeJS & NPM ----"
# Install NodeJS 10.x
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash - >> /var/www/html/vm_build.log 2>&1  || { echo 'Something went wrong, check the vm_build.log in ./data' ; exit 1; }
apt install -y nodejs >> /var/www/html/vm_build.log 2>&1  || { echo 'Something went wrong, check the vm_build.log in ./data' ; exit 1; }

echo -e "\n ---- 12 / 12 Installing Yarn ----"
# Install yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - >> /var/www/html/vm_build.log 2>&1  || { echo 'Something went wrong, check the vm_build.log in ./data' ; exit 1; }
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list >> /var/www/html/vm_build.log 2>&1  || { echo 'Something went wrong, check the vm_build.log in ./data' ; exit 1; }

apt-get -qq update
apt-get install yarn >> /var/www/html/vm_build.log 2>&1  || { echo 'Something went wrong, check the vm_build.log in ./data' ; exit 1; }

echo -e "<::::: LAMP STACK INSTALLED SUCCESFULLY :::::>"