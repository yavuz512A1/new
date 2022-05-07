FROM alpine:edge

RUN apk update
RUN apk add --no-cache curl \
    git \
    zip \
    unzip \
    ssmtp \
    perl \
    python3 \
    libc6-compat \
    tzdata
    
RUN apk add --no-cache php8 \
    php8-fpm \
    php8-cli \
    php8-pecl-mcrypt \
    php8-soap \
    php8-openssl \
    php8-gmp \
    php8-pdo_odbc \
    php8-json \
    php8-dom \
    php8-pdo \
    php8-zip \
    php8-pdo_mysql \
    php8-sqlite3 \
    php8-pdo_pgsql \
    php8-bcmath \
    php8-gd \
    php8-odbc \
    php8-pdo_sqlite \
    php8-gettext \
    php8-xmlreader \
    php8-bz2 \
    php8-iconv \
    php8-pdo_dblib \
    php8-curl \
    php8-ctype \
    php8-phar \
    php8-xml \
    php8-common \
    php8-mbstring \
    php8-tokenizer \
    php8-xmlwriter \
    php8-fileinfo \
    php8-opcache \
    php8-simplexml \
    php8-pecl-redis

RUN apk add --no-cache supervisor
RUN apk add --no-cache nginx && cp /etc/nginx/nginx.conf /etc/nginx/nginx.old.conf && rm -rf /etc/nginx/http.d/default.conf
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN adduser -D -u 1000 -g 'app' app
RUN addgroup nginx app
RUN mkdir /var/run/php && chown -R app:app /var/run/php
RUN mkdir /var/www/html
WORKDIR /var/www/html
COPY . /var/www/html
RUN chown -R app:app /var/www/html
RUN rm -rf /etc/php8/php-fpm.conf
RUN rm -rf /etc/php8/php-fpm.d/www.conf
RUN mv docker/supervisor.conf /etc/supervisord.conf
RUN mv docker/nginx.conf /etc/nginx/nginx.conf
RUN mv docker/php.ini /etc/php8/conf.d/php.ini
RUN mv docker/php-fpm.conf /etc/php8/php-fpm.conf
RUN mv docker/app.conf /etc/php8/php-fpm.d/app.conf
RUN chmod -R 755 /var/www/html

EXPOSE 8080
ENTRYPOINT ["supervisord", "-c", "/etc/supervisord.conf"]
