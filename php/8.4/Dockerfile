FROM php:8.4-apache-trixie AS base

SHELL ["/bin/bash", "-l", "-c"]

ARG BUILD_DEPS="libmcrypt-dev libfreetype6-dev libjpeg62-turbo-dev libpng-dev libicu-dev libmagickwand-dev libcurl4-openssl-dev libzip-dev libssl-dev libjpeg-dev"
ARG RUNTIME_DEPS="curl zip unzip git ssh openssh-client ghostscript ssl-cert libmcrypt4 libzip5 libicu76 libmagickwand-7.q16-10"

USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    $BUILD_DEPS \
    $RUNTIME_DEPS && \
    docker-php-ext-configure gd && \
    docker-php-ext-install -j$(nproc) \
        bcmath \
        exif \
        gd \
        intl \
        mysqli \
        pcntl \
        pdo_mysql \
        soap \
        xml \
        zip && \
    pecl install apcu mcrypt imagick redis raphf && \
    docker-php-ext-enable apcu mcrypt imagick redis raphf && \
    pecl install pecl_http && \
    docker-php-ext-enable http && \
    apt-get purge -y --auto-remove $BUILD_DEPS && \
    rm -rf /var/lib/apt/lists/* && \
    pecl clear-cache

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php -r "if (hash_file('sha384', 'composer-setup.php') === 'ed0feb545ba87161262f2d45a633e34f591ebb3381f2e0063c345ebea4d228dd0043083717770234ec00c5a9f9593792') { echo 'Installer verified'.PHP_EOL; } else { echo 'Installer corrupt'.PHP_EOL; unlink('composer-setup.php'); exit(1); }" && \
    php composer-setup.php --install-dir=/usr/bin --filename=composer && \
    php -r "unlink('composer-setup.php');"

COPY configs/000-default.conf /etc/apache2/sites-available/000-default.conf
RUN a2enmod ssl rewrite && \
    a2ensite 000-default.conf default-ssl.conf

RUN chown -R www-data:www-data /var/www

WORKDIR /var/www/html

FROM base AS production
USER www-data

FROM base AS dev
RUN apt-get update && apt-get install -y --no-install-recommends nano && \
    pecl install xdebug && \
    docker-php-ext-enable xdebug && \
    rm -rf /var/lib/apt/lists/*

RUN echo "zend_extension=xdebug" > /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

USER www-data