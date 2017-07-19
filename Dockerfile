FROM php:7-apache

MAINTAINER Jeremy RICHARD <jri@sciencespo.paris>

ENV LIMESURVEY_VERSION=2.67.2+170719

ENV LIMESURVEY_URL=http://download.limesurvey.org/latest-stable-release/limesurvey${LIMESURVEY_VERSION}.tar.gz

ENV ROOT_DIR=/var/www/html

RUN apt-get update \
# Install Postgre PDO
    &&  apt-get install -y libpq-dev \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo pdo_pgsql pgsql pdo_mysql \
# Install GD 
    && apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libpng12-dev \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd  \
# Install LDAP
    && apt-get install libldap2-dev -y \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
    && docker-php-ext-install ldap \
# Install zip
    && apt-get install -y zlib1g-dev \
    && docker-php-ext-install zip \
# Install imap
    && apt-get install -y libc-client-dev libkrb5-dev \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install imap \
# Clean
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Download and install Limesurvey
RUN cd $ROOT_DIR \
    && curl $LIMESURVEY_URL | tar xvz

# Move content to Apache root folder
RUN cp -rp $ROOT_DIR/limesurvey/* $ROOT_DIR && \
    rm -rf $ROOT_DIR/limesurvey && \
    chown -R www-data:www-data $ROOT_DIR  

VOLUME $ROOT_DIR/upload
VOLUME $ROOT_DIR/application/config
