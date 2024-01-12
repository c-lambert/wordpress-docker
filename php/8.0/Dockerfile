FROM php:8.0-apache-buster

RUN curl -sL https://deb.nodesource.com/setup_20.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get -qq -y install \
                   zip unzip \
                   git \
                   ssh \
                   openssh-client \
                   nodejs \
                   yarn \
                    && rm -rf /var/lib/apt/lists/*

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
    && docker-php-ext-configure gd \
    && docker-php-ext-install -j$(nproc) gd \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
	&& apt-get install -y \
		libicu-dev \
	&& docker-php-ext-install -j$(nproc) \
		intl \
	&& apt-get purge -y \
		libicu-dev \
    && rm -rf /var/lib/apt/lists/*

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
	&& pecl clear-cache \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
    	&& apt-get install -y \
    	libcurl4-openssl-dev \
    	&& docker-php-ext-install curl \
      && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install bcmath \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install soap \
    && docker-php-ext-install xml \
    && docker-php-ext-install exif \
    && docker-php-ext-install mysqli \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
    	&& apt-get install -y \
    	libzip-dev \
    	&& docker-php-ext-install zip \
        && rm -rf /var/lib/apt/lists/*


RUN pecl install -o -f redis \
    && docker-php-ext-enable redis \
    && pecl clear-cache \
    && rm -rf /var/lib/apt/lists/*


RUN php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer

COPY configs/000-default.conf /etc/apache2/sites-available/000-default.conf

RUN apt-get update && apt-get install -y ssl-cert && rm -rf /var/lib/apt/lists/*
RUN a2enmod ssl
RUN a2enmod rewrite
RUN a2ensite 000-default.conf
RUN a2ensite default-ssl.conf

# install xdebug
RUN yes | pecl install xdebug \
    && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.mode=coverage" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && pecl clear-cache

## ext-http
RUN apt-get update && apt-get install -y libssl-dev  \
    && rm -rf /var/lib/apt/lists/* \
    && pecl clear-cache

RUN pecl install raphf \
    && docker-php-ext-enable raphf \
    && rm -rf /var/lib/apt/lists/* \
    && pecl clear-cache

RUN pecl install pecl_http-4.2.1 \
    && pecl clear-cache

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
RUN apt-get update && apt-get install -y nano \
    && rm -rf /var/lib/apt/lists/*
