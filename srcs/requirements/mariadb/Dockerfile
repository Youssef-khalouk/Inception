
FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y --no-install-recommends mariadb-server && \
    rm -rf /var/lib/apt/lists/*

# Create necessary directories
RUN mkdir -p /run/mysqld \
    && chown -R mysql:mysql /run/mysqld \
    && chmod 755 /run/mysqld

COPY tools/init-db.sh /usr/local/bin/init-db.sh

RUN chmod +x /usr/local/bin/init-db.sh

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/init-db.sh"]
