FROM php:7.1-fpm

RUN apt-get update && \
    apt-get install -y wget \
                       zip \
                       libbz2-dev \
                       libfreetype6-dev \
                       libjpeg62-turbo-dev \
                       libpng12-dev \
                       libssl-dev \
                       libmcrypt-dev \
                       libmemcached-dev \
                       cron \
                       supervisor \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install iconv mcrypt && \
    docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
    docker-php-ext-install gd && \
    docker-php-ext-install pdo_mysql && \
    docker-php-ext-install mbstring && \
    docker-php-ext-install exif && \
    docker-php-ext-install bz2 && \
    docker-php-ext-install bcmath && \
    docker-php-ext-install gettext && \
    docker-php-ext-install mysqli && \
    pecl install redis && \
    pecl install xdebug && \
    pecl install memcached-2.2.0 && \
    pecl install memcache-2.2.7 && \
    pecl install phar-2.0.0 && \
    docker-php-ext-enable redis xdebug memcached memcache && \
    mkdir -p /home/packages/download && \
    wget -P /home/packages/download/ https://pecl.php.net/get/yaf-2.3.5.tgz && \
    tar zxvf /home/packages/download/yaf-2.3.5.tgz -C /home/packages/download/ && \
    cd /home/packages/download/yaf-2.3.5/ && \
    /usr/local/bin/phpize && \
    cd /home/packages/download/yaf-2.3.5/ && ./configure --with-php-config=/usr/local/bin/php-config && \
    make && make install

EXPOSE 9000
CMD ["php-fpm"]
