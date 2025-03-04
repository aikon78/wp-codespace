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

# Determine the URL based on the argument
if [ "$1" = "home" ]; then
    if [ -n "$CODESPACE_NAME" ] && [ "$CODESPACE_NAME" != "$(hostname)" ]; then
        URL="https://$CODESPACE_NAME-8080.$DOMAIN"
    else
        URL="http://localhost:8080"
    fi
elif [ "$1" = "admin" ]; then
    if [ -n "$CODESPACE_NAME" ] && [ "$CODESPACE_NAME" != "$(hostname)" ]; then
        URL="https://$CODESPACE_NAME-8080.$DOMAIN/wp-admin"
    else
        URL="http://localhost:8080/wp-admin"
    fi
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