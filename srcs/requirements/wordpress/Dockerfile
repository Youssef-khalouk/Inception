FROM debian:bookworm

RUN apt-get update && apt-get install -y --no-install-recommends \
    php8.2 \
    php8.2-fpm \
    php8.2-mysql \
    php8.2-curl \
    php8.2-gd \
    php8.2-mbstring \
    php8.2-xml \
    php8.2-zip \
    php8.2-intl \
    php8.2-redis \
    curl \
    ca-certificates \
    tar \
    && rm -rf /var/lib/apt/lists/*


# Create necessary directories
RUN mkdir -p /var/www/html /run/php

# Copy WordPress installation script
COPY tools/install-wordpress.sh /install-wordpress.sh
RUN chmod +x /install-wordpress.sh

# Copy PHP-FPM configuration
COPY tools/www.conf /etc/php/8.2/fpm/pool.d/www.conf

WORKDIR /var/www/html

EXPOSE 9000

ENTRYPOINT ["/install-wordpress.sh"]
CMD ["php-fpm8.2", "-F"]
