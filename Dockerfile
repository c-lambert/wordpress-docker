FROM wordpress:latest
RUN apt-get update

# install wp-cli
ADD wp-cli.phar .
RUN mv wp-cli.phar /usr/local/bin/wp
RUN chmod +x /usr/local/bin/wp

#install other library
RUN apt-get -qq -y install mysql-client
RUN apt-get -qq -y install ssh
RUN apt-get -qq -y install rsync
