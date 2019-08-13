# Variables #

# Needs to be the same as in install.sh
DBPASSWD=admin_123

# The theme name to be used
THEMENAME=SandBox

# Development url
URL=http://localhost:8080

# Change apache port to 8080
sudo sed -i 's/80/8080/' /etc/apache2/ports.conf
sudo service apache2 restart

cd /var/www/html
rm index.html

# Get WP files
wp core download

# Install WP
wp core config --dbuser=root --dbpass=$DBPASSWD --dbname=WordPress
wp db create
wp core install --url=$URL --title=Blog --admin_user=admin --admin_password=$DBPASSWD --admin_email=joku@jotain.com

# Install Aucor Core plugin
wp plugin install aucor-core --activate

# Get Aucor Starter theme in to folder that is not in sync
cd /var/www/
sudo git clone https://github.com/aucor/aucor-starter.git $THEMENAME

# Run Aucor Starter setup
# The variables mean:
## Theme Name
## Theme id (should be kept short, should be characters, numbers can fail)
## Development URL
## Author name
## Author url
## Y to "is this correct information ?"

cd /var/www/$THEMENAME
sudo sh setup.sh << END
$THEMENAME
snd
$URL
asd
asd.fi
y
END

# Move the theme in to wp-content/themes
sudo mv /var/www/$THEMENAME /var/www/html/wp-content/themes/

# Install packages
cd /var/www/html/wp-content/themes/$THEMENAME
yarn install

# Activate the theme
wp theme activate $THEMENAME