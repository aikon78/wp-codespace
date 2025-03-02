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
for mod in rewrite headers ssl; do
    sudo a2enmod $mod
done

# Test configuration before starting
echo "Testing Apache configuration..."
if ! sudo apache2ctl configtest; then
    echo "Apache configuration test failed:"
    sudo cat /var/log/apache2/error.log
    exit 1
fi

# Start Apache
echo "Starting Apache..."
if ! sudo service apache2 start; then
    echo "Failed to start Apache. Error log:"
    sudo cat /var/log/apache2/error.log
    exit 1
fi

# Verify Apache is running and listening
echo "Verifying Apache..."
sleep 2
if ! sudo apache2ctl -S; then
    echo "Apache verification failed. Error log:"
    sudo cat /var/log/apache2/error.log
    exit 1
fi

# Check if Apache is actually running
if ! sudo service apache2 status; then
    echo "Apache is not running. Error log:"
    sudo cat /var/log/apache2/error.log
    exit 1
fi

LOCALE="de_DE"

# WordPress Core install with increased memory limit
php -d memory_limit=256M /usr/local/bin/wp core download --locale=$LOCALE --path=wordpress
cd wordpress || exit 1  # Exit if cd fails
wp config create --dbname=wordpress --dbuser=wordpress --dbpass=wordpress --dbhost=db

# Create wp-config.php without hardcoded URLs
cat > wp-config-custom.php << EOL
define( 'FS_METHOD', 'direct' );
EOL

LINE_NUMBER=$(grep -n -m 1 'stop editing!' wp-config.php | cut -d ':' -f 1)
sed -i "${LINE_NUMBER}r wp-config-custom.php" wp-config.php
rm wp-config-custom.php

# Install WordPress with the correct URL format for Codespaces
wp core install --url=https://"$CODESPACE_NAME"-80.app.github.dev --title=WordPress --admin_user=admin --admin_password=admin --admin_email=mail@example.com

# Selected plugins
wp plugin delete akismet
wp plugin install show-current-template --activate
wp plugin activate wp-codespace

# Demo content for WordPress
wp plugin install wordpress-importer --activate
curl -s https://raw.githubusercontent.com/WPTT/theme-unit-test/master/themeunittestdata.wordpress.xml > demo-content.xml
wp import demo-content.xml --authors=create
rm -f demo-content.xml

# Xdebug
echo "xdebug.log_level=0" | sudo tee -a /usr/local/etc/php/conf.d/xdebug.ini

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