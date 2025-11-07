# ==============================
# 1) Build frontend (Vite)
# ==============================
FROM node:20-alpine AS assets
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# ==============================
# 2) Runtime: Nginx + PHP-FPM
# ==============================
FROM alpine:3.20

# OS + PHP runtime (CLI + FPM) and Laravel-required extensions
RUN apk add --no-cache \
      nginx supervisor \
      git unzip tzdata bash \
      php83 php83-fpm php83-cli php83-opcache \
      php83-pdo php83-pdo_mysql php83-mbstring php83-zip php83-intl \
      php83-xml php83-xmlreader php83-xmlwriter php83-gd php83-curl \
      php83-tokenizer php83-fileinfo php83-ctype php83-iconv php83-session

# Use php83 for CLI
RUN ln -sf /usr/bin/php83 /usr/bin/php

# Composer (official image)
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
ENV COMPOSER_ALLOW_SUPERUSER=1

# App directories
RUN mkdir -p /var/www/html /run/nginx /var/log/supervisor
WORKDIR /var/www/html

# Install PHP deps first for better build caching
COPY composer.json composer.lock ./
RUN composer install --no-dev --no-interaction --prefer-dist --optimize-autoloader --no-scripts

# Copy application code and built assets
COPY . .
COPY --from=assets /app/public/build ./public/build

# Nginx config
COPY nginx.conf /etc/nginx/nginx.conf

# Permissions for caches/storage (nginx user on Alpine is 'nginx'; php-fpm runs as 'nobody' by default)
RUN chown -R nginx:nginx storage bootstrap/cache || true \
 && chmod -R 775 storage bootstrap/cache || true

# Sanity + Laravel optimizations (DOM & tokenizer should be present)
RUN php -v \
 && php -m | grep -Ei 'dom|tokenizer|iconv|session' \
 && php artisan package:discover --ansi || true \
 && php artisan storage:link || true \
 && php artisan config:cache \
 && php artisan route:cache \
 && php artisan view:cache

# Supervisor to run php-fpm + nginx together
RUN printf "[supervisord]\nnodaemon=true\n\n[program:php-fpm]\ncommand=/usr/sbin/php-fpm83 -F\n\n[program:nginx]\ncommand=/usr/sbin/nginx -g 'daemon off;'\n" > /etc/supervisord.conf

EXPOSE 8080
ENV APP_ENV=production APP_DEBUG=false LOG_CHANNEL=stderr
CMD ["/usr/bin/supervisord","-c","/etc/supervisord.conf"]
