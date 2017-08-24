FROM php:5.6-fpm

MAINTAINER David Souvignon <david.souvignon@gmail.com>

ENV PHP_APCU_VERSION 4.0.6
ENV PHP_XDEBUG_VERSION 2.5.0

RUN apt-get update \
    && apt-get install -y \
        libicu-dev \
        zlib1g-dev \
        php-pear \

    && docker-php-source extract \
    && curl -L -o /tmp/apcu-$PHP_APCU_VERSION.tgz https://pecl.php.net/get/apcu-$PHP_APCU_VERSION.tgz \
    && curl -L -o /tmp/xdebug-$PHP_XDEBUG_VERSION.tgz http://xdebug.org/files/xdebug-$PHP_XDEBUG_VERSION.tgz \
    && tar xfz /tmp/apcu-$PHP_APCU_VERSION.tgz \
    && tar xfz /tmp/xdebug-$PHP_XDEBUG_VERSION.tgz \
    && rm -r \
        /tmp/apcu-$PHP_APCU_VERSION.tgz \
        /tmp/xdebug-$PHP_XDEBUG_VERSION.tgz \
    && mv apcu-$PHP_APCU_VERSION /usr/src/php/ext/apcu \
    && mv xdebug-$PHP_XDEBUG_VERSION /usr/src/php/ext/xdebug \
    && docker-php-ext-install \
        opcache \
        intl \
        mbstring \
        mysqli \
        pdo \
        pdo_mysql \
        xdebug \
        zip \
    && pecl install apcu-$PHP_APCU_VERSION \
    && docker-php-source delete \
    && php -r "readfile('https://getcomposer.org/installer');" | php -- --install-dir=/usr/local/bin --filename=composer \
    && chmod +x /usr/local/bin/composer

COPY ./assets/php.ini /usr/local/etc/php/conf.d/custom.ini