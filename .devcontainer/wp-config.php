<?php
define('DB_NAME', getenv('WORDPRESS_DB_NAME'));
define('DB_USER', getenv('WORDPRESS_DB_USER'));
define('DB_PASSWORD', getenv('WORDPRESS_DB_PASSWORD'));
define('DB_HOST', getenv('WORDPRESS_DB_HOST'));
define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');
$table_prefix = 'wp_';

// Replace with secure keys from https://api.wordpress.org/secret-key/1.1/salt/
define('AUTH_KEY',         'your-unique-phrase-here');
define('SECURE_AUTH_KEY',  'your-unique-phrase-here');
// ... other keys ...

if (getenv('CODESPACE_NAME') && getenv('GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN')) {
    $host_port = 8080;
    $codespace_url = 'https://' . getenv('CODESPACE_NAME') . '-' . $host_port . '.' . getenv('GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN');
    define('WP_HOME', $codespace_url);
    define('WP_SITEURL', $codespace_url);
} else {
    define('WP_HOME', 'http://localhost:8080');
    define('WP_SITEURL', 'http://localhost:8080');
}

if (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https') {
    $_SERVER['HTTPS'] = 'on';
}

define('WP_DEBUG', true);
if (!defined('ABSPATH')) {
    define('ABSPATH', __DIR__ . '/');
}
require_once ABSPATH . 'wp-settings.php';
