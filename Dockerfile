FROM php:7.2-fpm
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y apt-utils

RUN apt-get install -y bash \
    libfreetype6-dev \
    libmcrypt-dev \
    zlib1g-dev \
    libicu-dev \
    g++ \
    apt-transport-https \
    zip \
    unzip \
    libxml2-dev \
    wget \
    vim \
    git \
    libmemcached-dev \
    libpq-dev

RUN docker-php-ext-install -j$(nproc) iconv \
    bcmath \
    mbstring \
    pdo \
    pdo_pgsql

RUN docker-php-ext-configure intl && docker-php-ext-install intl \
    zip \
    soap

RUN apt-get update && apt-get install -y \
            libfreetype6-dev \
            libjpeg62-turbo-dev \
            libpng-dev \
        && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
        && docker-php-ext-install -j$(nproc) gd

RUN apt-get update && apt-get install -y \
        libmagickwand-dev --no-install-recommends

RUN pecl install imagick && docker-php-ext-enable imagick

RUN apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && composer global require "hirak/prestissimo:^0.3"

RUN mkdir /app
WORKDIR /app

EXPOSE 9000

