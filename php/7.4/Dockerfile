# PHP 7.4 : pas d'image officielle sur bookworm (OpenSSL 3), paquets du dépôt sury
FROM debian:bookworm-slim

ENV PHP_INI_DIR=/usr/local/etc/php
ENV PHP_INI_SCAN_DIR=:/usr/local/etc/php/conf.d
ENV APACHE_CONFDIR=/etc/apache2
ENV APACHE_ENVVARS=$APACHE_CONFDIR/envvars

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends ca-certificates curl; \
    curl -fsSLo /tmp/debsuryorg-archive-keyring.deb https://packages.sury.org/debsuryorg-archive-keyring.deb; \
    dpkg -i /tmp/debsuryorg-archive-keyring.deb; \
    rm /tmp/debsuryorg-archive-keyring.deb; \
    echo 'deb [signed-by=/usr/share/keyrings/debsuryorg-archive-keyring.gpg] https://packages.sury.org/php/ bookworm main' > /etc/apt/sources.list.d/php.list; \
    apt-get update; \
    apt-get upgrade -y; \
    apt-get install -y --no-install-recommends \
        apache2 \
        libapache2-mod-php7.4 \
        php7.4-cli \
        php7.4-apcu \
        php7.4-bcmath \
        php7.4-curl \
        php7.4-gd \
        php7.4-imagick \
        php7.4-intl \
        php7.4-mbstring \
        php7.4-mcrypt \
        php7.4-mysql \
        php7.4-propro \
        php7.4-raphf \
        php7.4-readline \
        php7.4-redis \
        php7.4-soap \
        php7.4-sqlite3 \
        php7.4-xdebug \
        php7.4-xml \
        php7.4-zip \
        ghostscript \
        ssl-cert \
        zip unzip \
        git \
        ssh \
        openssh-client \
        nano \
        xz-utils; \
    # CVE-2026-109618 et CVE-2026-109619 : corrigées à partir du paquet 7.4.33-31
    dpkg --compare-versions "$(dpkg-query -W -f '${Version}' php7.4-common)" ge '1:7.4.33-31'; \
    rm -rf /var/lib/apt/lists/*

# Même organisation que les images officielles php : php.ini et conf.d dans /usr/local/etc/php
RUN set -eux; \
    phpdismod -v 7.4 calendar ffi gettext opcache shmop sockets sysvmsg sysvsem sysvshm; \
    mkdir -p "$PHP_INI_DIR/conf.d"; \
    cp /usr/lib/php/7.4/php.ini-development /usr/lib/php/7.4/php.ini-production "$PHP_INI_DIR/"; \
    for sapi in apache2 cli; do ln -sf "$PHP_INI_DIR/php.ini" "/etc/php/7.4/$sapi/php.ini"; done; \
    ln -s /usr/bin/php7.4 /usr/local/bin/php; \
    { \
        echo 'xdebug.mode=debug'; \
        echo 'xdebug.client_host=host.docker.internal'; \
    } > "$PHP_INI_DIR/conf.d/docker-php-ext-xdebug.ini"

RUN set -eux; \
    sed -ri 's/^export ([^=]+)=(.*)$/: ${\1:=\2}\nexport \1/' "$APACHE_ENVVARS"; \
    . "$APACHE_ENVVARS"; \
    for dir in "$APACHE_LOCK_DIR" "$APACHE_RUN_DIR" "$APACHE_LOG_DIR"; do \
        rm -rvf "$dir"; \
        mkdir -p "$dir"; \
        chown "$APACHE_RUN_USER:$APACHE_RUN_GROUP" "$dir"; \
        chmod 1777 "$dir"; \
    done; \
    rm -rvf /var/www/html/*; \
    ln -sfT /dev/stderr "$APACHE_LOG_DIR/error.log"; \
    ln -sfT /dev/stdout "$APACHE_LOG_DIR/access.log"; \
    ln -sfT /dev/stdout "$APACHE_LOG_DIR/other_vhosts_access.log"; \
    chown -R --no-dereference "$APACHE_RUN_USER:$APACHE_RUN_GROUP" "$APACHE_LOG_DIR"; \
    a2dismod mpm_event; \
    a2enmod mpm_prefork; \
    { \
        echo '<FilesMatch \.php$>'; \
        echo '\tSetHandler application/x-httpd-php'; \
        echo '</FilesMatch>'; \
        echo; \
        echo 'DirectoryIndex disabled'; \
        echo 'DirectoryIndex index.php index.html'; \
        echo; \
        echo '<Directory /var/www/>'; \
        echo '\tOptions -Indexes'; \
        echo '\tAllowOverride All'; \
        echo '</Directory>'; \
    } | tee "$APACHE_CONFDIR/conf-available/docker-php.conf"; \
    a2enconf docker-php

COPY --from=php:8.2-apache-bookworm /usr/local/bin/docker-php-entrypoint /usr/local/bin/apache2-foreground /usr/local/bin/
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

COPY configs/000-default.conf /etc/apache2/sites-available/000-default.conf
RUN a2enmod ssl rewrite && \
    a2ensite 000-default.conf default-ssl.conf

WORKDIR /var/www/html

STOPSIGNAL SIGWINCH
EXPOSE 80
ENTRYPOINT ["docker-php-entrypoint"]
CMD ["apache2-foreground"]
