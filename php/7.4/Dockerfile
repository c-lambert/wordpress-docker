FROM php:7.4-apache-buster

RUN apt-get update && apt-get -qq -y install \
                   zip unzip \
                   git \
                   ssh \
                   openssh-client

RUN pecl install apcu \
        && docker-php-ext-enable apcu \
        && pecl clear-cache

RUN apt-get update && apt-get install -y \
            libmcrypt-dev \
            && pecl install mcrypt \
            && docker-php-ext-enable mcrypt \
            && pecl clear-cache

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libwebp-dev \
    && docker-php-ext-configure gd --with-webp --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd

RUN apt-get update \
	&& apt-get install -y \
		libicu-dev \
	&& docker-php-ext-install -j$(nproc) \
		intl \
	&& apt-get purge -y \
		libicu-dev

RUN apt-get update \
	&& apt-get install -y \
		libmagickwand-dev --no-install-recommends \
		ghostscript --no-install-recommends \
	&& pecl install \
		imagick \
	&& docker-php-ext-enable \
		imagick \
	&& apt-get purge -y \
		libmagickwand-dev \
	&& pecl clear-cache

RUN apt-get update \
    	&& apt-get install -y \
    	libcurl4-openssl-dev \
    	&& docker-php-ext-install curl

RUN docker-php-ext-install bcmath
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install soap
RUN docker-php-ext-install xml

RUN apt-get update \
    	&& apt-get install -y \
    	libzip-dev \
    	&& docker-php-ext-install zip

RUN docker-php-ext-install exif
RUN docker-php-ext-install mysqli
#RUN docker-php-ext-install mbstring

RUN pecl install -o -f redis \
    && docker-php-ext-enable redis \
    && pecl clear-cache

RUN php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer

COPY configs/000-default.conf /etc/apache2/sites-available/000-default.conf

RUN apt-get update && apt-get install -y ssl-cert
RUN a2enmod ssl
RUN a2enmod rewrite
RUN a2ensite 000-default.conf
RUN a2ensite default-ssl.conf

## ext-http
RUN apt-get update && apt-get install -y libssl-dev

RUN pecl install raphf propro \
    && docker-php-ext-enable raphf propro
RUN pecl install pecl_http-3.2.4

## COPIED from https://github.com/docker-library/wordpress/blob/af6cc1c9637878a7d3c59c1a451f202533189b96/latest/php7.4/apache/Dockerfile
# persistent dependencies
RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
# Ghostscript is required for rendering PDF previews
		ghostscript \
	; \
	rm -rf /var/lib/apt/lists/*

# install the PHP extensions we need (https://make.wordpress.org/hosting/handbook/handbook/server-environment/#php-extensions)
RUN set -ex; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		libjpeg-dev \
	; \
	rm -rf /var/lib/apt/lists/*
### END COPIED

RUN apt-get update && apt-get install -y nano
