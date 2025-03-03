<?php
define('DB_NAME', getenv('WORDPRESS_DB_NAME'));
define('DB_USER', getenv('WORDPRESS_DB_USER'));
define('DB_PASSWORD', getenv('WORDPRESS_DB_PASSWORD'));
define('DB_HOST', getenv('WORDPRESS_DB_HOST'));
define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');
$table_prefix = 'wp_';

// Define keys and salts (replace with secure values)
define('AUTH_KEY',         'your-unique-phrase-here');
define('SECURE_AUTH_KEY',  'your-unique-phrase-here');
// ... other keys ...

// Dynamically set URL from Codespace environment variables
$codespace_url = 'https://' . getenv('CODESPACE_NAME') . '.' . getenv('GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN');
$base_url = !empty(getenv('CODESPACE_NAME')) && !empty(getenv('GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN')) ? $codespace_url : 'http://localhost:8080';

// Set WordPress URLs and host overrides
define('WP_HOME', $base_url);
define('WP_SITEURL', $base_url);
$_SERVER['HTTP_HOST'] = parse_url($base_url, PHP_URL_HOST);
$_SERVER['SERVER_NAME'] = parse_url($base_url, PHP_URL_HOST);

// Force HTTPS for Codespaces proxy
if (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https') {
    $_SERVER['HTTPS'] = 'on';
}

define('WP_DEBUG', true);
if (!defined('ABSPATH')) {
    define('ABSPATH', __DIR__ . '/');
}
require_once ABSPATH . 'wp-settings.php';