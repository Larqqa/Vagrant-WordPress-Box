#! /usr/bin/env bash

echo -e "<::::: INSTALLING WORDPRESS :::::>"

echo -e "\n ---- 1 / 11 Changing Apache port to 8080 ----"
# Change apache port to 8080
sudo sed -i 's/80/8080/' /etc/apache2/ports.conf
sudo service apache2 restart  >> /var/www/html/vm_build.log 2>&1  || { echo 'Something went wrong, check the vm_build.log in ./data' ; exit 1; }

cd /var/www/html
rm index.html

echo -e "\n ---- 2 / 11 Getting WordPress files ----"
# Get WP files
wp core download  >> /var/www/html/vm_build.log 2>&1  || { echo 'Something went wrong, check the vm_build.log in ./data' ; exit 1; }

echo -e "\n ---- 3 / 11 Installing WordPress ----"
# Install WP
wp core config --dbuser=root --dbpass=$DBPASSWD --dbname=WordPress  >> /var/www/html/vm_build.log 2>&1  || { echo 'Something went wrong, check the vm_build.log in ./data' ; exit 1; }
wp db create  >> /var/www/html/vm_build.log 2>&1  || { echo 'Something went wrong, check the vm_build.log in ./data' ; exit 1; }
wp core install --url=$URL --title=Blog --admin_user=admin --admin_password=$DBPASSWD --admin_email=joku@jotain.com  >> /var/www/html/vm_build.log 2>&1  || { echo 'Something went wrong, check the vm_build.log in ./data' ; exit 1; }

echo -e "\n ---- 4 / 11 Installing WordPress plugins ----"
# Install Aucor Core plugin
wp plugin install advanced-custom-fields wordpress-seo redirection aucor-core --activate  >> /var/www/html/vm_build.log 2>&1  || { echo 'Something went wrong, check the vm_build.log in ./data' ; exit 1; }

echo -e "\n ---- 5 / 11 Removing Hello Dolly plugin ----"
# Install Aucor Core plugin
wp plugin delete hello >> /var/www/html/vm_build.log 2>&1  || { echo 'Something went wrong, check the vm_build.log in ./data' ; exit 1; }

echo -e "\n ---- 6 / 11 Getting Aucor Starter theme ----"
# Get Aucor Starter theme in to folder that is not in sync
cd /var/www/
sudo git clone https://github.com/aucor/aucor-starter.git $THEMENAME  >> /var/www/html/vm_build.log 2>&1 || { echo 'Something went wrong, check the vm_build.log in ./data' ; exit 1; }
sudo rm -rf .git

# Run Aucor Starter setup
echo -e "\n ---- 7 / 11 Running Aucor Starter Setup ----"
cd /var/www/$THEMENAME
sudo sh setup.sh >> /var/www/html/vm_build.log 2>&1 << END
$THEMENAME
$ID
$URL
$AUTHOR
$AUTHOR_URL
y
END

echo -e "\n ---- 8 / 11 Moving the theme to WordPress themes ----"
# Move the theme in to wp-content/themes
sudo mv /var/www/$THEMENAME /var/www/html/wp-content/themes/

echo -e "\n ---- 9 / 11 Installing NPM packages, for build tools ----"
# Install packages
# Using --no-bin-links is required for Yarn install to work in VBox on Windows  
# For needed commands ( like Gulp ) you need to install the packages globally
cd /var/www/html/wp-content/themes/$THEMENAME
yarn install --no-bin-links >> /var/www/html/vm_build.log 2>&1  || { echo 'Something went wrong, check the vm_build.log in ./data' ; exit 1; }

echo -e "\n ---- 10 / 11 Installing Gulp globally ----"
# Install Gulp as global
# Needed for dev environment in Aucor starter theme
sudo npm i -g gulp@^3.9.1  >> /var/www/html/vm_build.log 2>&1  || { echo 'Something went wrong, check the vm_build.log in ./data' ; exit 1; }

echo -e "\n ---- 11 / 11 Activating the theme ----"
# Activate the theme
wp theme activate $THEMENAME  >> /var/www/html/vm_build.log 2>&1  || { echo 'Something went wrong, check the vm_build.log in ./data' ; exit 1; }

# Add the theme as default path to speed up SSH login
echo "cd /var/www/html/wp-content/themes/$THEMENAME" >> /home/vagrant/.bashrc

echo -e "<::::: WORDPRESS INSTALLED SUCCESFULLY :::::>"