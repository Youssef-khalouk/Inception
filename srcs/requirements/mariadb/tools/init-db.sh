#!/bin/bash
set -e

# Initialize the database system if needed.
if [ ! -d /var/lib/mysql/mysql ]; then
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
fi

# Start MariaDB temporarily to configure the database.
service mariadb start

# Create the WordPress database and user.
mariadb -u root <<SQL
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
SQL

# Stop the temporary server.
mysqladmin -u root shutdown

# Keep MariaDB running in the foreground.
exec mariadbd --user=mysql --console --bind-address=0.0.0.0
