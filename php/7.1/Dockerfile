FROM php:7.1-apache-buster

RUN apt-get update && apt-get -qq -y install \
                   zip unzip \
                   git \
                   ssh \
                   openssh-client \

RUN docker-php-ext-install bcmath \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install soap \
    && docker-php-ext-install exif \
    && docker-php-ext-install mysqli \
    && rm -rf /var/lib/apt/lists/*

RUN php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer

COPY configs/000-default.conf /etc/apache2/sites-available/000-default.conf

RUN apt-get update && apt-get install -y ssl-cert
RUN a2enmod ssl
RUN a2enmod rewrite
RUN a2ensite 000-default.conf
RUN a2ensite default-ssl.conf

RUN apt-get update && apt-get install -y nano
