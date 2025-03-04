# WordPress Codespace Development Environment

A ready-to-use WordPress development environment that runs in GitHub Codespaces. Start developing for WordPress with just a single click - no local setup required!

## Features

- **Instant WordPress Setup**: WordPress is automatically installed and configured
- **Docker-based**: Uses Docker to isolate the WordPress and database environments
- **Task Buttons**: Convenient buttons in the status bar for common tasks
- **Enhanced Security**: Port is private by default and only made public when accessing the site
- **Persistent Storage**: Your changes persist between Codespace sessions


## 🔒 Security Considerations

Avoid storing sensitive information in this environment as it's intended for development purposes only.

- Port 8080 is **private by default** - HOWEVER, the port is made public temporarily when you click the WP Home or WP Admin buttons so that you may view the web pages in your web browser. Anyone that has the URL to your codespace will be able to access it any time you are able to access it with your web browser. You may cut off public access any time by by restarting the WP server using the `WP Restart` button in the status bar
- For additional security, consider changing the default admin password after setup



## Getting Started

### 1. Create a Codespace

Click the button below to create your own Codespace:

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://github.com/codespaces/new?hide_repo_select=true&ref=main&repo=586814971&devcontainer_path=.devcontainer%2Fdevcontainer.json&location=WestEurope)

The setup process will:
- Install WordPress and configure the database
- Set up Apache to serve your WordPress site
- Configure port forwarding with private access by default
- Install necessary tools and extensions

### 2. Access Your WordPress Site

Once the Codespace is ready, you can access your WordPress site using the status bar buttons:

- **WP Home**: Makes port 8080 public and opens the WordPress homepage
- **WP Admin**: Makes port 8080 public and opens the WordPress admin login page
- **PW Reset**: Resets the admin password if you're having trouble logging in
- **WP Restart**: Restarts the WordPress services and ensures port 8080 is private

### 3. WordPress Admin Credentials

Use these credentials to log in to the WordPress admin dashboard:

- **Username**: admin
- **Password**: password123
- **Email**: admin@example.com

## Development Workflow

### Accessing Your Site

Your WordPress site is accessible at:
```
https://<your-codespace-name>-8080.app.github.dev
```

The WordPress admin area is at:
```
https://<your-codespace-name>-8080.app.github.dev/wp-admin
```

**Important**: You must use the WP Home or WP Admin buttons to access these URLs, as they make the port public before opening the site.

### Making Changes

- WordPress files are located in the `/workspaces/wp-codespace/wordpress` directory
- You can install plugins and themes through the WordPress admin interface
- Changes to files are automatically reflected on your site

### Troubleshooting

If you encounter any issues:

1. Use the **WP Restart** button in the status bar to restart WordPress
2. If you can't log in, use the **PW Reset** button
3. If you can't access your site, make sure you're using the WP Home or WP Admin buttons which handle port visibility
4. Check the log file at `/tmp/wp-task-log.txt` for diagnostic information about task button operations

## Behind the Scenes

This Codespace setup includes:

- WordPress with a MariaDB database
- Apache web server
- WP-CLI for command-line WordPress management
- Docker for containerization
- Task buttons for common operations
- Automatic port visibility management for security

## Customization

You can customize this environment by:

- Editing `.devcontainer/devcontainer.json` to change Codespace settings
- Modifying `.devcontainer/docker-compose.yml` to adjust the Docker configuration
- Adding your own scripts to the `.devcontainer` directory

## Stopping and Restarting

When you stop and restart your Codespace, the WordPress services will automatically restart thanks to the `postStartCommand` in the devcontainer configuration. The port will remain private until you use the WP Home or WP Admin buttons.

---

Happy WordPress development!
