FROM quay.io/spivegin/apache

WORKDIR /var/www/html 

RUN apt-get update &&\
    apt-get install -y sqlite3 wget git zip default-libmysqlclient-dev libbz2-dev libmemcached-dev libsasl2-dev libfreetype6-dev libicu-dev libjpeg-dev libmemcachedutil2 libpng-dev libxml2-dev mariadb-client ffmpeg libimage-exiftool-perl python curl python-pip php7.0-zip php7.0-sqlite3 && \
    apt-get autoclean && apt-get autoremove &&\
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/* &&\
    a2enmod rewrite && a2enmod headers
# /var/www/cpalead-deployer/public/
RUN rm -rf /var/www/html && mkdir -p /var/www/html/cpalead-deployer
ADD https://www.cpalead.com/downloads/cpalead-deployer.zip /var/www/html/cpalead-deployer/cpalead-deployer.zip 

RUN cd /var/www/html/cpalead-deployer/ &&\
    unzip cpalead-deployer.zip &&\
    rm cpalead-deployer.zip &&\
    cd /var/www/ &&\
    chown -R www-data:www-data . &&\
    apt-get autoclean && apt-get autoremove &&\
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

EXPOSE 80
ADD files/apache2/sites-enabled/ /etc/apache2/sites-enabled/
ADD files/php/php.ini /etc/php/7.0/apache2/
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/opt/bin/entry.sh"]