<?php
define('DB_NAME', getenv('WORDPRESS_DB_NAME'));
define('DB_USER', getenv('WORDPRESS_DB_USER'));
define('DB_PASSWORD', getenv('WORDPRESS_DB_PASSWORD'));
define('DB_HOST', getenv('WORDPRESS_DB_HOST'));
define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');
$table_prefix = 'wp_';

// Define keys and salts (replace with your secure values)
define('AUTH_KEY',         'your-unique-phrase-here');
define('SECURE_AUTH_KEY',  'your-unique-phrase-here');
// ... other keys ...

// Force correct URL regardless of request
define('WP_HOME', 'https://probable-space-capybara-vwwj67rgr6wh7rx-8080.app.github.dev');
define('WP_SITEURL', 'https://probable-space-capybara-vwwj67rgr6wh7rx-8080.app.github.dev');

// Use Codespace URL from environment variables if available
$codespace_url = 'https://' . getenv('CODESPACE_NAME') . '-8080.' . getenv('GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN');
if (!empty($codespace_url)) {
    define('WP_HOME', $codespace_url);
    define('WP_SITEURL', $codespace_url);
}

// Force HTTPS for Codespaces proxy
if (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https') {
    $_SERVER['HTTPS'] = 'on';
}

define('WP_DEBUG', true);
if (!defined('ABSPATH')) {
    define('ABSPATH', __DIR__ . '/');
}
require_once ABSPATH . 'wp-settings.php';