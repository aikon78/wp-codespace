#!/bin/bash
set -e  # Exit on any error

# Get Codespace environment variables
CODESPACE_NAME=${CODESPACE_NAME:-$(hostname)}
DOMAIN=${GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN:-app.github.dev}

# Debug information
echo "Debug: CODESPACE_NAME=$CODESPACE_NAME"
echo "Debug: DOMAIN=$DOMAIN"

# Construct the base URL (without trailing slash)
if [ -n "$CODESPACE_NAME" ] && [ "$CODESPACE_NAME" != "$(hostname)" ]; then
    # We're in a Codespace - use URL without port in hostname
    BASE_URL="https://$CODESPACE_NAME.$DOMAIN"
    echo "Debug: Using Codespace URL: $BASE_URL"
    
    # Make port 8080 public
    echo "Making port 8080 public for secure access..."
    if command -v gh &> /dev/null; then
        gh codespace ports visibility 8080:public --codespace $CODESPACE_NAME || echo "⚠️ Failed to set port visibility - you may need to make port 8080 public manually"
    else
        echo "⚠️ GitHub CLI not found - cannot set port visibility automatically"
        echo "Please make port 8080 public manually in the Ports tab"
    fi
else
    # We're not in a Codespace or can't detect it properly
    echo "⚠️ Not running in a detectable Codespace environment"
    echo "Using localhost URL instead"
    BASE_URL="http://localhost:8080"
fi

# Process the command argument
case "$1" in
    "home")
        echo "$BASE_URL"
        ;;
    "admin")
        echo "$BASE_URL/wp-admin"
        ;;
    *)
        echo "Usage: $0 {home|admin}"
        echo "Specify 'home' for the homepage or 'admin' for the admin login page."
        exit 1
        ;;
esac