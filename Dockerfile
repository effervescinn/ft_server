FROM debian:buster

# installing different stuff
RUN apt-get update && apt-get install -y procps && apt-get install nano && apt-get install -y wget
RUN apt-get -y install php7.3-fpm php7.3-common php7.3-mysql php7.3-gmp php7.3-curl php7.3-intl php7.3-mbstring php7.3-xmlrpc php7.3-gd php7.3-xml php7.3-cli php7.3-zip php7.3-soap php7.3-imap
RUN apt-get -y install wget
RUN apt-get -y install nginx
RUN apt-get -y install mariadb-server

# phpmyadmin
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.2/phpMyAdmin-5.0.2-english.tar.gz && \
    tar -xzvf phpMyAdmin-5.0.2-english.tar.gz && \
    mv phpMyAdmin-5.0.2-english/ /var/www/html/phpmyadmin && \
    rm -rf phpMyAdmin-5.0.2-english.tar.gz
COPY ./srcs/config.inc.php /var/www/html/phpmyadmin

# wp
RUN wget https://wordpress.org/latest.tar.gz && \
    tar -xzvf latest.tar.gz && \
    mv wordpress /var/www/html/ && \
    rm -rf latest.tar.gz
COPY ./srcs/wp-config.php /var/www/html/wordpress

# nginx.conf
COPY ./srcs/nginx.conf /etc/nginx/sites-available/localhost
RUN ln -s /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled/nginx.conf
RUN rm var/www/html/index.nginx-debian.html

# main-page
# COPY ./srcs/index.html /var/www/html

COPY ./srcs/autoindex_off.sh /var/www/html
COPY ./srcs/nginx-autoindex-off.conf /var/www/html

# ssl
RUN openssl req -x509 -nodes -days 365 -subj "/C=RU/ST=Moscow/L=Moscow/O=School21/OU=School21-Moscow/CN=lnorcros" -newkey rsa:2048 -keyout /etc/ssl/nginx-selfsigned.key -out /etc/ssl/nginx-selfsigned.crt;

COPY ./srcs/init.sh ./
RUN chown -R www-data /var/www/*
RUN chmod -R 755 /var/www/*

EXPOSE 80 443

CMD bash init.sh
