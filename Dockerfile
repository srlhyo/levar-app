# 1) PHP dependencies (build stage, composer only)
FROM php:8.3-fpm-alpine AS php-deps
ENV COMPOSER_ALLOW_SUPERUSER=1
RUN apk add --no-cache git libzip-dev oniguruma-dev libpng-dev icu-dev libxml2-dev \
  && docker-php-ext-install pdo pdo_mysql mbstring zip intl xml gd opcache
RUN { echo 'opcache.enable=1'; echo 'opcache.enable_cli=1'; echo 'opcache.validate_timestamps=0'; \
      echo 'opcache.max_accelerated_files=10000'; echo 'opcache.memory_consumption=128'; \
      echo 'opcache.interned_strings_buffer=8'; } > /usr/local/etc/php/conf.d/opcache.ini
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
WORKDIR /var/www/html
COPY composer.json composer.lock ./
RUN composer install --no-dev --no-interaction --prefer-dist --optimize-autoloader --no-scripts

# 2) Frontend build (Vite)
FROM node:20-alpine AS assets
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# 3) Runtime: Nginx + PHP-FPM from Alpine packages (with DOM)
FROM alpine:3.20
RUN apk add --no-cache \
      nginx supervisor \
      php83 php83-fpm php83-opcache \
      php83-pdo php83-pdo_mysql php83-mbstring php83-zip php83-intl \
      php83-xml php83-gd php83-curl \
      tzdata bash
# ^ php83-xml provides DOMDocument

RUN mkdir -p /var/www/html /run/nginx /var/log/supervisor

# Use the opcache settings from build stage as a convenience (optional)
# If you prefer, you can instead echo these to /etc/php83/conf.d/*.ini
# COPY --from=php-deps /usr/local/etc/php/conf.d/opcache.ini /etc/php83/conf.d/opcache.ini

WORKDIR /var/www/html
COPY . .
COPY --from=php-deps /var/www/html/vendor ./vendor
COPY --from=assets /app/public/build ./public/build
COPY nginx.conf /etc/nginx/nginx.conf

# Run artisan commands now that the full app + php83-* are present
RUN php artisan package:discover --ansi || true \
 && php artisan storage:link || true \
 && php artisan config:cache \
 && php artisan route:cache \
 && php artisan view:cache

RUN printf "[supervisord]\nnodaemon=true\n\n[program:php-fpm]\ncommand=/usr/sbin/php-fpm83 -F\n\n[program:nginx]\ncommand=/usr/sbin/nginx -g 'daemon off;'\n" > /etc/supervisord.conf

EXPOSE 8080
ENV APP_ENV=production APP_DEBUG=false LOG_CHANNEL=stderr
CMD ["/usr/bin/supervisord","-c","/etc/supervisord.conf"]
