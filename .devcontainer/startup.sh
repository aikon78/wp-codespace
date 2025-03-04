#!/bin/bash
set -e  # Exit on any error

echo "🚀 Starting WordPress Codespace..."

# Start Docker containers
echo "📦 Starting Docker containers..."
docker-compose -f .devcontainer/docker-compose.yml up -d

# Check if Apache is installed and running
if command -v apache2ctl &> /dev/null; then
    echo "🌐 Restarting Apache..."
    sudo service apache2 restart || sudo apache2ctl restart || echo "⚠️ Failed to restart Apache - may not be installed"
else
    echo "ℹ️ Apache not found in this container - using Docker for WordPress"
fi

# Ensure port is private by default for security
echo "🔒 Setting port 8080 to private for security..."
if command -v gh &> /dev/null; then
    # Get current codespace name from environment
    if [ -n "$CODESPACE_NAME" ]; then
        echo "Using codespace: $CODESPACE_NAME"
        gh codespace ports visibility 8080:private --codespace $CODESPACE_NAME || echo "⚠️ Failed to set port visibility - please check manually"
    else
        echo "⚠️ CODESPACE_NAME not set - cannot set port visibility automatically"
    fi
else
    echo "⚠️ GitHub CLI not found - cannot set port visibility automatically"
fi

echo "✅ Startup complete! WordPress is ready. Use the WP Home or WP Admin buttons to access your site." 