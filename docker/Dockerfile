# Set the base image for subsequent instructions
FROM php:7.4-fpm
WORKDIR /var/www

# Update packages

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - \
    && apt-get update \
    && apt-get install -y zip libzip-dev unzip nodejs netcat libmcrypt-dev libjpeg-dev libpng-dev libfreetype6-dev libbz2-dev nodejs git \
    && apt-get clean

# Install extensions
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install gd
RUN docker-php-ext-install zip
RUN chmod -R 775 /var/www
# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer


COPY php/custom.ini /usr/local/etc/php/conf.d/
EXPOSE 9000
