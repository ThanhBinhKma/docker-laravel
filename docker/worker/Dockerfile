# Set the base image for subsequent instructions
FROM php:7.4-fpm
WORKDIR /var/www

ENV ACCEPT_EULA=Y

# Update packages
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - \
    && apt-get update \
    && apt-get install -y zip libzip-dev unzip netcat libmcrypt-dev libjpeg-dev libpng-dev libfreetype6-dev libbz2-dev nodejs git supervisor cron \
    && apt-get clean

RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN apt-get update
RUN ACCEPT_EULA=Y apt-get -y --no-install-recommends install msodbcsql17 unixodbc-dev
RUN pecl install sqlsrv
RUN pecl install pdo_sqlsrv
RUN docker-php-ext-enable sqlsrv pdo_sqlsrv

# Microsoft SQL Server Prerequisites
RUN apt-get update > /dev/null \
   && apt-get install -y --no-install-recommends gnupg2 > /dev/null \
   && apt-get update > /dev/null \
   && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
   && curl https://packages.microsoft.com/config/debian/9/prod.list \
       > /etc/apt/sources.list.d/mssql-release.list \
   && apt-get install -y --no-install-recommends \
       locales \
       apt-transport-https \
       > /dev/null \
   && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
   && locale-gen > /dev/null \
   && apt-get update > /dev/null \
   && apt-get -y --no-install-recommends install \
       unixodbc-dev \
       msodbcsql17 \
       > /dev/null

# Install & enable Microsoft SQL Server
RUN docker-php-ext-install pdo > /dev/null \
   && pecl install sqlsrv pdo_sqlsrv > /dev/null \
   && docker-php-ext-enable sqlsrv pdo_sqlsrv > /dev/null


# END V4

RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install gd
RUN docker-php-ext-install zip

COPY worker.conf /etc/supervisor/conf.d/
COPY php/custom.ini /usr/local/etc/php/conf.d/
COPY app_cron /etc/cron.d/
RUN chmod 0644 /etc/cron.d/* && crontab /etc/cron.d/app_cron
RUN chown -R www-data:www-data /var/www
RUN chmod -R 755 /var/www
RUN touch /var/log/crontab.log
COPY entrypoint.sh /entrypoint.sh
RUN ["chmod", "+x", "/entrypoint.sh"]
ENTRYPOINT ["/entrypoint.sh"]
