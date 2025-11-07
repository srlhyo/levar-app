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
      git unzip tzdata bash ca-certificates \
      php83 php83-fpm php83-cli php83-opcache \
      php83-pdo php83-pdo_mysql php83-mbstring php83-zip php83-intl \
      php83-xml php83-xmlreader php83-xmlwriter php83-gd php83-curl \
      php83-tokenizer php83-fileinfo php83-ctype php83-iconv php83-session php83-phar \
      php83-gmp

# Ensure php CLI is php83
RUN ln -sf /usr/bin/php83 /usr/bin/php && update-ca-certificates

# Composer (official image)
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
ENV COMPOSER_ALLOW_SUPERUSER=1

# Prepare filesystem
RUN mkdir -p /var/www/html /run/nginx /var/log/supervisor
WORKDIR /var/www/html

# Install PHP deps first (better layer cache)
COPY composer.json composer.lock ./
RUN composer install --no-dev --no-interaction --prefer-dist --optimize-autoloader --no-scripts

# Copy application code and built assets
COPY . .
COPY --from=assets /app/public/build ./public/build

# Nginx config
COPY nginx.conf /etc/nginx/nginx.conf

# Ensure runtime write permissions for Laravel (php-fpm runs as 'nobody' on Alpine)
RUN mkdir -p storage/logs storage/framework/cache storage/framework/views storage/framework/sessions bootstrap/cache \
 && chown -R nobody:nginx storage bootstrap/cache \
 && chmod -R ug+rwX storage bootstrap/cache

# Minimal artisan steps that are safe at build time
RUN php -v \
 && php -m | grep -E 'dom|tokenizer|iconv|session|phar|gmp' \
 && php artisan package:discover --ansi || true \
 && php artisan storage:link || true

# Supervisor: run php-fpm + nginx
RUN printf "[supervisord]\nnodaemon=true\n\n[program:php-fpm]\ncommand=/usr/sbin/php-fpm83 -F\n\n[program:nginx]\ncommand=/usr/sbin/nginx -g 'daemon off;'\n" > /etc/supervisord.conf

EXPOSE 8080

# Defaults (you can also set these in DO env)
ENV APP_ENV=production \
    APP_DEBUG=false \
    LOG_CHANNEL=stderr \
    LOG_DEPRECATIONS_CHANNEL=null \
    LOG_LEVEL=info

CMD ["/usr/bin/supervisord","-c","/etc/supervisord.conf"]
