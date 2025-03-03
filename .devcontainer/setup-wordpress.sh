#!/bin/bash
echo "Starting WordPress setup..."

# Wait for database
TIMEOUT=60
COUNT=0
echo "Waiting for database..."
until docker-compose exec -T wordpress nc -z db 3306 2>/dev/null; do
    sleep 2
    COUNT=$((COUNT + 2))
    echo "Waited $COUNT seconds..."
    if [ $COUNT -ge $TIMEOUT ]; then
        echo "Error: Database not ready after $TIMEOUT seconds."
        docker-compose logs db
        exit 1
    fi
done
echo "Database ready!"

# Install wp-cli in the wordpress container
docker-compose exec -T wordpress bash -c "if ! command -v wp; then apt-get update && apt-get install -y less && curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp; fi"

# Set URLs
echo "Configuring URLs..."
CODESPACE_URL="https://${CODESPACE_NAME}-8080.${GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN}"
docker-compose exec -T wordpress wp option update home "$CODESPACE_URL" --path=/var/www/html
docker-compose exec -T wordpress wp option update siteurl "$CODESPACE_URL" --path=/var/www/html

echo "WordPress setup complete!"
