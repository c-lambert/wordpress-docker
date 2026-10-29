FROM php:8.1-apache-bookworm

# CVE-2026-109618 et CVE-2026-109619 : PHP 8.1 n'est plus publié, correctif de la branche PHP-8.1-CVE-2026-109618-109619
ARG PHP_FIX_URL=https://github.com/php/php-src/commit/1d7dec178a094e6e75b229ce22754045f8c6070a.patch
ARG PHP_FIX_SHA256=c85ad0fddcbff7f2318617eeaa54d271135463b5bf70a01228447e3ed78de96e

RUN set -eux; \
    apt-get update; \
    apt-get upgrade -y; \
    savedAptMark="$(apt-mark showmanual)"; \
    apt-get install -y --no-install-recommends \
        apache2-dev \
        libargon2-dev \
        libcurl4-openssl-dev \
        libonig-dev \
        libreadline-dev \
        libsodium-dev \
        libsqlite3-dev \
        libssl-dev \
        libxml2-dev \
        zlib1g-dev \
        patch; \
    cd /usr/src; \
    curl -fsSL -o fix.patch "$PHP_FIX_URL"; \
    echo "$PHP_FIX_SHA256 *fix.patch" | sha256sum -c -; \
    mkdir php; \
    tar -xf php.tar.xz -C php --strip-components=1; \
    patch -d php -p1 < fix.patch; \
    rm -f fix.patch php.tar.xz php.tar.xz.asc; \
    tar -cJf php.tar.xz php; \
    rm -rf php; \
    export CFLAGS="$PHP_CFLAGS" CPPFLAGS="$PHP_CPPFLAGS" LDFLAGS="$PHP_LDFLAGS"; \
    docker-php-source extract; \
    cd /usr/src/php; \
    gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; \
    debMultiarch="$(dpkg-architecture --query DEB_BUILD_MULTIARCH)"; \
    ./configure \
        --build="$gnuArch" \
        --with-config-file-path="$PHP_INI_DIR" \
        --with-config-file-scan-dir="$PHP_INI_DIR/conf.d" \
        --enable-option-checking=fatal \
        --with-mhash \
        --with-pic \
        --enable-ftp \
        --enable-mbstring \
        --enable-mysqlnd \
        --with-password-argon2 \
        --with-sodium=shared \
        --with-pdo-sqlite=/usr \
        --with-sqlite3=/usr \
        --with-curl \
        --with-iconv \
        --with-openssl \
        --with-readline \
        --with-zlib \
        --disable-phpdbg \
        --with-pear \
        --with-libdir="lib/$debMultiarch" \
        --disable-cgi \
        --with-apxs2; \
    make -j "$(nproc)"; \
    find -type f -name '*.a' -delete; \
    make install; \
    find /usr/local -type f -perm '/0111' -exec sh -euxc 'strip --strip-all "$@" || :' -- '{}' +; \
    make clean; \
    cp -v php.ini-* "$PHP_INI_DIR/"; \
    cd /; \
    docker-php-source delete; \
    apt-mark auto '.*' > /dev/null; \
    [ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; \
    find /usr/local -type f -executable -exec ldd '{}' ';' \
        | awk '/=>/ { print $(NF-1) }' \
        | sort -u \
        | xargs -r dpkg-query --search \
        | cut -d: -f1 \
        | sort -u \
        | xargs -r apt-mark manual; \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
    rm -rf /var/lib/apt/lists/*; \
    php --version

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

# Extensions des paquets PHP Debian/Ubuntu (php-common, php-igbinary), absentes de l'image officielle
RUN docker-php-ext-install -j$(nproc) \
		calendar \
		gettext \
		shmop \
		sockets

RUN pecl install igbinary \
    && docker-php-ext-enable igbinary \
    && pecl clear-cache


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
# Ghostscript is required for rendering PDF previews \
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
