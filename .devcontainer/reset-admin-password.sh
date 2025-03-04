#!/bin/bash
set -e  # Exit on any error

# Default password
DEFAULT_PASSWORD="password123"

# Use provided password or default
PASSWORD=${1:-$DEFAULT_PASSWORD}

echo "Resetting WordPress admin password to: $PASSWORD"

# Reset the admin password
docker-compose -f .devcontainer/docker-compose.yml exec -T -u www-data wordpress wp user update 1 --user_pass="$PASSWORD" --path=/var/www/html

if [ $? -eq 0 ]; then
    echo "✅ Password reset successful!"
    echo "Username: admin"
    echo "Password: $PASSWORD"
else
    echo "❌ Password reset failed!"
    exit 1
fi 