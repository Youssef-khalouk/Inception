#!/bin/bash
set -e

# MYSQL_HOST is for WordPress clients; MariaDB initialization must use its local socket.
unset MYSQL_HOST

DB_PASSWORD=$(cat /run/secrets/db_password)


: "${MYSQL_DATABASE:?MYSQL_DATABASE is not set}"
: "${MYSQL_USER:?MYSQL_USER is not set}"

if [ ! -d /var/lib/mysql/mysql ]; then
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
fi

service mariadb start

until mariadb-admin --no-defaults --protocol=socket --socket=/run/mysqld/mysqld.sock ping --silent; do
    echo "Waiting for MariaDB..."
    sleep 1
done

mariadb --no-defaults --protocol=socket --socket=/run/mysqld/mysqld.sock -u root <<SQL
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
ALTER USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
SQL

mysqladmin --no-defaults --protocol=socket --socket=/run/mysqld/mysqld.sock -u root shutdown

exec mariadbd --user=mysql --console --bind-address=0.0.0.0
