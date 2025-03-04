#!/bin/bash

echo "Checking for changes in GitHub..."

# Fetch the latest changes
git fetch origin

# Check if there are differences between local and remote
if git diff --quiet HEAD origin/main; then
    echo "Your code is up to date with GitHub."
    exit 0
fi

# If we get here, there are differences
echo -e "\n⚠️  Changes detected in GitHub that aren't in your Codespace!"
echo -e "Would you like to:"
echo "1. Replace ALL your Codespace code with the GitHub version (any local changes will be lost)"
echo "2. Keep your Codespace code (but you may have issues pushing later)"
echo -n "Enter 1 or 2: "

read choice

case $choice in
    1)
        echo -e "\nReplacing Codespace code with GitHub version..."
        git reset --hard origin/main
        echo "✅ Done! Your code now matches GitHub."
        ;;
    2)
        echo -e "\n⚠️  Warning: You may have issues pushing your changes later."
        echo "When you're ready to push your changes, you might need help merging."
        ;;
    *)
        echo -e "\n❌ Invalid choice. Keeping your current code."
        echo "Warning: You may have issues pushing your changes later."
        ;;
esac 