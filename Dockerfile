FROM php:7.1-fpm

ENV PHP_INI_DIR /usr/local/etc/php
ENV PHP_CONF_DIR /usr/local/etc/php/conf.d

RUN apt-get update && apt-get install -y \
        zip \
        libbz2-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng12-dev \
        libssl-dev \
        libmcrypt-dev \
        libmemcached-dev \
	--no-install-recommends && rm -r /var/lib/apt/lists/*

RUN docker-php-ext-install iconv mcrypt
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
RUN docker-php-ext-install gd
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install mbstring
RUN docker-php-ext-install exif
RUN docker-php-ext-install bz2
RUN docker-php-ext-install bcmath
RUN docker-php-ext-install gettext
RUN docker-php-ext-install mysqli
RUN pecl install redis
RUN pecl install xdebug
RUN pecl install memcached-2.2.0
RUN pecl install memcache-2.2.7
RUN pecl install phar-2.0.0
RUN docker-php-ext-enable redis xdebug memcached memcache

RUN mkdir -p /home/packages/download && \
    wget -P /home/packages/download/ https://pecl.php.net/get/yaf-2.3.5.tgz && \
    tar zxvf /home/packages/download/yaf-2.3.5.tgz -C /home/packages/download/ && \
    cd /home/packages/download/yaf-2.3.5/ && \
    /usr/local/bin/phpize && \
    cd /home/packages/download/yaf-2.3.5/ && ./configure --with-php-config=/usr/local/bin/php-config && \
    make && make install

RUN ADD_EXT(){ echo -e "extension = ${1}.so;\n${2}" > "$PHP_CONF_DIR/${1}.ini"; } && \
    ADD_EXT yaf "[yaf]\nyaf.environ = develop\nyaf.use_namespace = 1"
    
EXPOSE 9000
CMD ["php-fpm"]
