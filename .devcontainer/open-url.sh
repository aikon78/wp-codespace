#!/bin/bash
# This script safely opens a URL without causing Codespace issues

# Log to a file for debugging
LOG_FILE="/tmp/wp-task-log.txt"
echo "$(date): Starting open-url.sh with args: $@" >> $LOG_FILE

# Function to safely exit
safe_exit() {
  echo "$(date): Exiting with status $1" >> $LOG_FILE
  exit $1
}

# Get Codespace environment variables
CODESPACE_NAME=${CODESPACE_NAME:-$(hostname)}
DOMAIN=${GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN:-app.github.dev}

echo "$(date): CODESPACE_NAME=$CODESPACE_NAME" >> $LOG_FILE
echo "$(date): DOMAIN=$DOMAIN" >> $LOG_FILE

# Make port 8080 public first
echo "$(date): Making port 8080 public..." >> $LOG_FILE
if command -v gh &> /dev/null; then
    if [ -n "$CODESPACE_NAME" ] && [ "$CODESPACE_NAME" != "$(hostname)" ]; then
        gh codespace ports visibility 8080:public --codespace $CODESPACE_NAME >> $LOG_FILE 2>&1 || \
        echo "$(date): Failed to set port visibility" >> $LOG_FILE
    else
        echo "$(date): Not in a detectable Codespace environment" >> $LOG_FILE
    fi
else
    echo "$(date): GitHub CLI not found" >> $LOG_FILE
fi

# Get the forwarding URL directly from GitHub CLI if possible
if command -v gh &> /dev/null && [ -n "$CODESPACE_NAME" ] && [ "$CODESPACE_NAME" != "$(hostname)" ]; then
    echo "$(date): Attempting to get forwarding URL from GitHub CLI..." >> $LOG_FILE
    FORWARDING_INFO=$(gh codespace ports --codespace $CODESPACE_NAME 2>> $LOG_FILE)
    echo "$(date): Forwarding info: $FORWARDING_INFO" >> $LOG_FILE
    
    # Extract the URL for port 8080
    if echo "$FORWARDING_INFO" | grep -q "8080"; then
        FORWARDING_URL=$(echo "$FORWARDING_INFO" | grep "8080" | awk '{print $3}')
        echo "$(date): Found forwarding URL: $FORWARDING_URL" >> $LOG_FILE
        BASE_URL=$FORWARDING_URL
    else
        echo "$(date): Could not find port 8080 in forwarding info, using fallback" >> $LOG_FILE
        BASE_URL="https://$CODESPACE_NAME-8080.$DOMAIN"
    fi
else
    # Fallback to constructed URL
    if [ -n "$CODESPACE_NAME" ] && [ "$CODESPACE_NAME" != "$(hostname)" ]; then
        BASE_URL="https://$CODESPACE_NAME-8080.$DOMAIN"
    else
        BASE_URL="http://localhost:8080"
    fi
    echo "$(date): Using fallback URL: $BASE_URL" >> $LOG_FILE
fi

# Determine the final URL based on the argument
if [ "$1" = "home" ]; then
    URL="$BASE_URL"
elif [ "$1" = "admin" ]; then
    URL="$BASE_URL/wp-admin"
else
    echo "$(date): Invalid argument: $1" >> $LOG_FILE
    echo "Usage: $0 {home|admin}" >> $LOG_FILE
    safe_exit 1
fi

echo "$(date): Opening URL: $URL" >> $LOG_FILE

# Print the URL to stdout (this will be captured by the task)
echo "$URL"

# Exit safely
safe_exit 0 