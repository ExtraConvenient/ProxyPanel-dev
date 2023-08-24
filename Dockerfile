# syntax=docker/dockerfile:1

FROM php:8.1

# setup PHP
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

RUN apt-get update && apt-get install -y \
	zip unzip git cron libpng-dev libzip-dev default-mysql-client

# install extensions
RUN pecl install redis \
	&& docker-php-ext-enable redis
	
RUN docker-php-ext-install pcntl pdo_mysql gd zip bcmath

# copy scripts
COPY ./start-server.sh /start-server.sh
COPY ./queue.sh /queue.sh

# copy cron files (cron must be started manually)
COPY ./schedule-cron /etc/cron.d/schedule-cron
RUN chmod 0644 /etc/cron.d/schedule-cron
RUN crontab /etc/cron.d/schedule-cron

WORKDIR /app