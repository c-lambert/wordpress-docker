FROM numendo/php:7.4-apache-buster


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


# install wp-cli
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar; \
	mv wp-cli.phar /usr/local/bin/wp
RUN chmod +x /usr/local/bin/wp

#install other library
RUN apt-get update; \
    apt-get -qq -y install mariadb-client
RUN apt-get -qq -y install ssh
RUN apt-get -qq -y install sshpass
RUN apt-get -qq -y install rsync