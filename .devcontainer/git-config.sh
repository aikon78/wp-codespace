#!/bin/bash

# Basic Git configurations
git config --global pull.rebase false
git config --global core.editor "code --wait"
git config --global init.defaultBranch main
git config --global credential.helper cache
git config --global color.ui auto
git config --global --add safe.directory "/workspaces/${PWD##*/}"

# Configure git based on environment
if [ -n "$GITHUB_USER" ]; then
  # In Codespaces, use the GitHub username
  git config --global user.name "$GITHUB_USER"
  git config --global user.email "$GITHUB_USER@users.noreply.github.com"
else
  # In local development, prompt for input if not configured
  if [ -z "$(git config --global user.name)" ]; then
    echo "Git user name not configured."
    read -p "Enter your name: " name
    git config --global user.name "$name"
  fi

  if [ -z "$(git config --global user.email)" ]; then
    echo "Git email not configured."
    read -p "Enter your email: " email
    git config --global user.email "$email"
  fi
fi

echo "Git configuration complete!" 