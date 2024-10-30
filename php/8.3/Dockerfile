FROM php:8.3-apache-bullseye

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

RUN php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer

COPY configs/000-default.conf /etc/apache2/sites-available/000-default.conf

RUN apt-get update && apt-get install -y ssl-cert && rm -rf /var/lib/apt/lists/*
RUN a2enmod ssl
RUN a2enmod rewrite
RUN a2ensite 000-default.conf
RUN a2ensite default-ssl.conf

# install xdebug
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && pecl clear-cache

RUN apt-get update \
    	&& apt-get install -y \
        libxml2-dev \
        && docker-php-ext-install xml \
        && rm -rf /var/lib/apt/lists/*

# Install php extensions
RUN docker-php-ext-install bcmath \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install soap \
    && docker-php-ext-install exif \
    && docker-php-ext-install mysqli \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y nano \
    && rm -rf /var/lib/apt/lists/*

RUN echo 'numendo:x:1000:1000::/home/numendo:/bin/bash' >> /etc/passwd
