FROM debian:bookworm

RUN apt update && apt install -y wget php php-mysql

RUN mkdir -p /var/www/html

WORKDIR /var/www/html

RUN wget -O index.php https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php && \
    chmod 644 index.php

EXPOSE 8081

CMD ["php", "-S", "0.0.0.0:8081", "-t", "/var/www/html"]