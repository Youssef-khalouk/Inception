#!/bin/sh
set -eu

# Read secrets
DB_PASSWORD=$(cat /run/secrets/db_password)

# Wait until the WordPress database user can connect.
until php -r '$db = @new mysqli(getenv("MYSQL_HOST"), getenv("MYSQL_USER"), trim(file_get_contents("/run/secrets/db_password")), getenv("MYSQL_DATABASE")); exit($db->connect_errno ? 1 : 0);' >/dev/null 2>&1; do
    echo "Waiting for MariaDB..."
    sleep 2
done


# Download WordPress if not already present
if [ ! -f /var/www/html/wp-config.php ]; then
    curl -fsSL https://wordpress.org/latest.tar.gz -o /tmp/wordpress.tar.gz
    tar -xzf /tmp/wordpress.tar.gz --strip-components=1 -C /var/www/html
    rm /tmp/wordpress.tar.gz
fi

# Configure WordPress
if [ ! -f /var/www/html/wp-config.php ]; then
    cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
    
    # Replace database configuration
    sed -i "s/database_name_here/${MYSQL_DATABASE}/g" /var/www/html/wp-config.php
    sed -i "s/username_here/${MYSQL_USER}/g" /var/www/html/wp-config.php
    sed -i "s/password_here/${DB_PASSWORD}/g" /var/www/html/wp-config.php
    sed -i "s/localhost/${MYSQL_HOST}/g" /var/www/html/wp-config.php

    # Add security keys,
    curl -s https://api.wordpress.org/secret-key/1.1/salt/ >> /var/www/html/wp-config.php

    # Set permissions
    chown -R www-data:www-data /var/www/html
    chmod -R 755 /var/www/html

    echo "install and configuration is Done."
fi

# Configure Redis (on every startup)
WP_CONFIG="/var/www/html/wp-config.php"

sed -i "/define('WP_REDIS_HOST'/d" "$WP_CONFIG"
sed -i "/define('WP_REDIS_PORT'/d" "$WP_CONFIG"

sed -i "/require_once ABSPATH . 'wp-settings.php';/i\\
define('WP_REDIS_HOST', 'redis');\\
define('WP_REDIS_PORT', 6379);\\
" "$WP_CONFIG"

exec "$@"
