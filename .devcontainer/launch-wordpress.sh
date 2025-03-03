#!/bin/bash

# Get Codespace environment variables
CODESPACE_NAME=${CODESPACE_NAME}
DOMAIN=${GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN:-app.github.dev}

# Construct the base URL
BASE_URL="https://$CODESPACE_NAME.$DOMAIN/"

# Check if in Codespace environment
if [ -n "$CODESPACE_NAME" ]; then
    case "$1" in
        "home")
            echo "$BASE_URL"
            ;;
        "admin")
            echo "$BASE_URL/wp-admin/"
            ;;
        *)
            echo "Usage: $0 {home|admin}"
            echo "Specify 'home' for the homepage or 'admin' for the admin login page."
            exit 1
            ;;
    esac
else
    echo "This script must be run in a GitHub Codespace. For local testing, visit:"
    echo "Homepage: http://localhost:8080/"
    echo "Admin: http://localhost:8080/wp-admin/"
    exit 1
fi