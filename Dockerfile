# ============ 3) Runtime: Nginx + PHP-FPM (Alpine packages) ============
FROM alpine:3.20

RUN apk add --no-cache \
      nginx supervisor \
      php83 php83-fpm php83-cli php83-opcache \
      php83-pdo php83-pdo_mysql php83-mbstring php83-zip php83-intl \
      php83-xml php83-xmlreader php83-xmlwriter php83-gd php83-curl \
      tzdata bash

# ensure `php` runs php83 (overwrite if something else is there)
RUN ln -sf /usr/bin/php83 /usr/bin/php

RUN mkdir -p /var/www/html /run/nginx /var/log/supervisor

WORKDIR /var/www/html
COPY . .
COPY --from=php-deps /var/www/html/vendor ./vendor
COPY --from=assets /app/public/build ./public/build
COPY nginx.conf /etc/nginx/nginx.conf

# artisan now uses php83 with DOM enabled
RUN php -v \
 && php -m | grep -i dom \
 && php artisan package:discover --ansi || true \
 && php artisan storage:link || true \
 && php artisan config:cache \
 && php artisan route:cache \
 && php artisan view:cache

RUN printf "[supervisord]\nnodaemon=true\n\n[program:php-fpm]\ncommand=/usr/sbin/php-fpm83 -F\n\n[program:nginx]\ncommand=/usr/sbin/nginx -g 'daemon off;'\n" > /etc/supervisord.conf

EXPOSE 8080
ENV APP_ENV=production APP_DEBUG=false LOG_CHANNEL=stderr
CMD ["/usr/bin/supervisord","-c","/etc/supervisord.conf"]
