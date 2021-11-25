FROM php:7.3-fpm-alpine

WORKDIR /var/www/html

RUN set -ex \
  && apk --no-cache add \
    postgresql-dev \
    libzip-dev \
    libpng-dev \
    libxml2-dev \
    postgresql-client \
    npm \
    nodejs

RUN docker-php-ext-install pdo pdo_pgsql intl pgsql json opcache zip mbstring bcmath xml gd

# Installing composer
RUN curl -sS https://getcomposer.org/installer -o composer-setup.php
RUN php composer-setup.php --install-dir=/usr/local/bin --filename=composer
RUN rm -rf composer-setup.php

# Building process
COPY ./ ./
RUN composer install --ignore-platform-reqs
RUN chown -R www-data:www-data /var/www/
RUN php artisan storage:link
RUN chmod -R 777 /var/www/html/public/storage
RUN apk add shadow && usermod -u 1000 www-data && groupmod -g 1000 www-data

#RUN npm rebuild node-sass
#RUN npm install
#RUN npm run production
