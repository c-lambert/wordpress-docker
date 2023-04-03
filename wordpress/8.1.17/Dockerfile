FROM numendo/php:8.1.17-apache-buster

# install wp-cli
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar; \
	mv wp-cli.phar /usr/local/bin/wp
RUN chmod +x /usr/local/bin/wp

ENV WP_CLI_ALLOW_ROOT 1

#install other library
RUN apt-get update; \
    apt-get -qq -y install mariadb-client
RUN apt-get -qq -y install ssh
RUN apt-get -qq -y install sshpass
RUN apt-get -qq -y install rsync
