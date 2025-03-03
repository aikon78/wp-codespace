#!/bin/bash
set -e  # Exit on any error
echo "Starting WordPress setup..."

# Install dependencies as root
echo "Installing dependencies..."
docker-compose -f .devcontainer/docker-compose.yml exec -T wordpress bash -c "apt-get update && apt-get install -y netcat-traditional less mariadb-client" || { echo "Failed to install dependencies"; exit 1; }

# Install wp-cli as root and set permissions
echo "Installing wp-cli..."
docker-compose -f .devcontainer/docker-compose.yml exec -T wordpress bash -c "if ! command -v wp; then curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp; fi" || { echo "Failed to install wp-cli as root"; exit 1; }
docker-compose -f .devcontainer/docker-compose.yml exec -T wordpress bash -c "chown www-data:www-data /usr/local/bin/wp && chmod 755 /usr/local/bin/wp" || { echo "Failed to set wp-cli permissions"; exit 1; }

# Wait for database
TIMEOUT=180
COUNT=0
echo "Waiting for database..."
until docker-compose -f .devcontainer/docker-compose.yml exec -T wordpress nc -z db 3306 2>/dev/null; do
    sleep 2
    COUNT=$((COUNT + 2))
    echo "Waited $COUNT seconds..."
    if [ $COUNT -ge $TIMEOUT ]; then
        echo "Error: Database not ready after $TIMEOUT seconds."
        docker-compose -f .devcontainer/docker-compose.yml logs db
        exit 1
    fi
done
echo "Database ready!"

# Define the correct Codespace URL
CODESPACE_URL="https://${CODESPACE_NAME}-8080.${GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN}"

# Reset and install WordPress using root for database setup
echo "Resetting and installing WordPress..."
docker-compose -f .devcontainer/docker-compose.yml exec -T wordpress mariadb -h db -u root -psomewordpress -e "DROP DATABASE IF EXISTS wordpress; CREATE DATABASE wordpress;" || { echo "Failed to reset database"; exit 1; }
docker-compose -f .devcontainer/docker-compose.yml exec -T wordpress mariadb -h db -u root -psomewordpress -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'%' IDENTIFIED BY 'wordpress'; FLUSH PRIVILEGES;" || { echo "Failed to set permissions"; exit 1; }
docker-compose -f .devcontainer/docker-compose.yml exec -T -u www-data wordpress wp core install \
    --path=/var/www/html \
    --url="$CODESPACE_URL" \
    --title="My WordPress Site" \
    --admin_user="admin" \
    --admin_password="password123" \
    --admin_email="admin@example.com" \
    --skip-email || { echo "Failed to install WordPress"; docker-compose -f .devcontainer/docker-compose.yml logs wordpress; exit 1; }
echo "WordPress installed!"

# Configure URLs and permalinks
echo "Configuring URLs and permalinks..."
docker-compose -f .devcontainer/docker-compose.yml exec -T -u www-data wordpress wp option update siteurl "$CODESPACE_URL" --path=/var/www/html || { echo "Failed to update siteurl"; docker-compose -f .devcontainer/docker-compose.yml logs wordpress; exit 1; }
docker-compose -f .devcontainer/docker-compose.yml exec -T -u www-data wordpress wp option update home "$CODESPACE_URL" --path=/var/www/html || { echo "Failed to update home URL"; docker-compose -f .devcontainer/docker-compose.yml logs wordpress; exit 1; }
docker-compose -f .devcontainer/docker-compose.yml exec -T -u www-data wordpress wp rewrite structure '/%postname%/' --path=/var/www/html || { echo "Failed to set permalink structure"; docker-compose -f .devcontainer/docker-compose.yml logs wordpress; exit 1; }
docker-compose -f .devcontainer/docker-compose.yml exec -T -u www-data wordpress wp rewrite flush --path=/var/www/html || { echo "Failed to flush permalinks"; docker-compose -f .devcontainer/docker-compose.yml logs wordpress; exit 1; }

echo "WordPress setup complete!"