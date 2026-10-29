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
    docker-php-ext-configure ftp --with-ftp-ssl && \
    docker-php-ext-install -j$(nproc) \
        bcmath \
        calendar \
        exif \
        ftp \
        gd \
        gettext \
        intl \
        mysqli \
        pcntl \
        pdo_mysql \
        shmop \
        soap \
        sockets \
        xml \
        zip && \
    pecl install apcu mcrypt imagick redis raphf igbinary && \
    docker-php-ext-enable apcu mcrypt imagick redis raphf igbinary && \
    pecl install pecl_http && \
    docker-php-ext-enable http && \
    apt-get purge -y --auto-remove $BUILD_DEPS && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    pecl clear-cache

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php -r "if (hash_file('sha384', 'composer-setup.php') === 'c8b085408188070d5f52bcfe4ecfbee5f727afa458b2573b8eaaf77b3419b0bf2768dc67c86944da1544f06fa544fd47') { echo 'Installer verified'.PHP_EOL; } else { echo 'Installer corrupt. The composer hash might have changed, you can update it.'.PHP_EOL; unlink('composer-setup.php'); exit(1); }" && \
    php composer-setup.php --install-dir=/usr/bin --filename=composer && \
    php -r "unlink('composer-setup.php');"

COPY configs/000-default.conf /etc/apache2/sites-available/000-default.conf
RUN a2enmod ssl rewrite &&\
    a2enmod headers &&\
    a2ensite 000-default.conf
    #a2ensite 000-default.conf default-ssl.conf

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
