FROM debian:buster

ENV DEBIAN_FRONTEND noninteractive

RUN echo "nameserver 8.8.8.8" > /etc/resolv.conf

# MYSQL INSTALLATION
RUN apt-get update && \
   apt-get install -y --no-install-recommends gnupg dirmngr && \
   apt-get install -y --no-install-recommends ca-certificates wget
#   key='A4A9406876FCBD3C456770C88C718D3B5072E1F5'; \
#        gpg --batch --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
#        gpg --batch --export "$key" > /etc/apt/trusted.gpg.d/mysql.gpg; \
#    gpgconf --kill all; \
#    echo 'deb http://repo.mysql.com/apt/debian/ buster mysql-8.0' > /etc/apt/sources.list.d/mysql.list; \
#    { \
#                echo mysql-community-server mysql-community-server/data-dir select ''; \
#                echo mysql-community-server mysql-community-server/root-pass password 'iferrer ??'; \
#                echo mysql-community-server mysql-community-server/re-root-pass password 'iferrer ??'; \
#                echo mysql-community-server mysql-community-server/remove-test-db select false; \
#        } | debconf-set-selections; \
#    apt-get update && \
#    apt-get install -y mysql-server;

# PHP 8 INSTALLATION 
RUN echo "deb https://packages.sury.org/php/ buster main" | tee /etc/apt/sources.list.d/sury-php.list && \
    wget -qO - https://packages.sury.org/php/apt.gpg | apt-key add - && \
    apt-get update && \
    apt-get install -y php8.0-fpm php8.0-common php8.0-mysql;

# NGINX INSTALLATION 
RUN apt-get update && \
    apt-get install -y nginx

#SERVICES INIT
CMD /etc/init.d/php8.0-fpm start && \
    nginx -t && \
    /etc/init.d/nginx start && \
    tail -f -n 0 /var/log/nginx/error.log & \
    tail -f -n 0 /var/log/nginx/access.log

