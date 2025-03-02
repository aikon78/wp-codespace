#! /bin/bash

# Dynamically get the repository name from the workspace path
REPO_NAME=$(basename "$PWD")
REPO_FOLDER="/workspaces/$REPO_NAME"

# Apache setup
echo "Configuring Apache..."
sudo chmod 777 /etc/apache2/sites-available/000-default.conf
sudo cp .devcontainer/000-default.conf /etc/apache2/sites-available/000-default.conf
sudo sed -i "s@/workspaces/wp-codespace@$REPO_FOLDER@g" /etc/apache2/sites-available/000-default.conf

# Stop Apache and clean up
echo "Stopping Apache and cleaning up..."
sudo service apache2 stop
sleep 2
sudo killall apache2 || true
sudo rm -f /var/run/apache2/apache2.pid

# Ensure Apache directories and permissions
echo "Setting up Apache directories..."
sudo mkdir -p /var/log/apache2
sudo touch /var/log/apache2/error.log
sudo chmod 777 /var/log/apache2/error.log
sudo mkdir -p /var/run/apache2
sudo chown www-data:www-data /var/run/apache2

# Enable modules and restart Apache
echo "Enabling Apache modules..."
sudo a2enmod rewrite headers
sudo a2enmod ssl

# Start Apache
echo "Starting Apache..."
sudo service apache2 start

LOCALE="de_DE"

# WordPress Core install with increased memory limit
php -d memory_limit=256M /usr/local/bin/wp core download --locale=$LOCALE --path=wordpress
cd wordpress || exit 1  # Exit if cd fails

# Create basic wp-config.php
wp config create --dbname=wordpress --dbuser=wordpress --dbpass=wordpress --dbhost=db --extra-php <<PHP
/* Enable direct file operations */
define( 'FS_METHOD', 'direct' );

/* Enable WordPress proxy support */
if (isset(\$_SERVER['HTTP_X_FORWARDED_PROTO']) && \$_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https') {
    \$_SERVER['HTTPS'] = 'on';
}
PHP

# Install WordPress with explicit port 443
wp core install --url="https://$CODESPACE_NAME-443.app.github.dev" --title=WordPress --admin_user=admin --admin_password=admin --admin_email=mail@example.com

# Update site URL to use port 443
wp option update home "https://$CODESPACE_NAME-443.app.github.dev"
wp option update siteurl "https://$CODESPACE_NAME-443.app.github.dev"

# Selected plugins
wp plugin delete akismet
wp plugin install show-current-template --activate
wp plugin activate wp-codespace

# Demo content for WordPress
wp plugin install wordpress-importer --activate
curl -s https://raw.githubusercontent.com/WPTT/theme-unit-test/master/themeunittestdata.wordpress.xml > demo-content.xml
wp import demo-content.xml --authors=create
rm -f demo-content.xml

# Install dependencies
cd "$REPO_FOLDER" || exit 1
npm install 
composer install

# Setup local plugin
cd "$REPO_FOLDER/wordpress/wp-content/plugins/wp-codespace" || exit 1
npm install && npx playwright install && npm run compile:css
code -r wp-codespace.php

# Setup bash
echo "export PATH=\"\$PATH:$REPO_FOLDER/vendor/bin:$REPO_FOLDER/node_modules/.bin/\"" >> ~/.bashrc
echo "cd $REPO_FOLDER/wordpress" >> ~/.bashrc
source ~/.bashrc