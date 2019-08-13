# Update Ubuntu
apt-get update
apt-get upgrade

# Variables
DBPASSWD=admin_123

# Set MySQL params
debconf-set-selections <<< "mysql-server mysql-server/root_password password $DBPASSWD"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $DBPASSWD"

# Set PHPMyAdmin params
debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $DBPASSWD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $DBPASSWD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $DBPASSWD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect none"

# Install MySQL & PHPMyAdmin
apt-get install -y mysql-server phpmyadmin

# Install Apache2 & Git
apt-get install -y apache2 git curl build-essential python-software-properties

# Enable Apache Mods
a2enmod rewrite

# Add Onrej PPA Repo & update. Needed for PHP 7.2 installation
LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php
apt-get update

# Install PHP & mods
apt-get install -y php7.2 libapache2-mod-php7.2 php7.2-common php7.2-zip php7.2-mysql

# Allow Apache override to all
sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/apache2.conf

# Turn on PHP errors
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.0/apache2/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.0/apache2/php.ini

# Restart Apache
sudo service apache2 restart

# Install WP-CLI
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

# Install NodeJS and NPM
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
apt install -y nodejs

# Install yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

sudo apt-get update && sudo apt-get install yarn