FROM numendo/php:8.0.13-apache-buster

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
