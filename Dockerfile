FROM alpine:latest

ENV NEXTCLOUD_VERSION 12.0.3

RUN apk update --no-cache && \
apk add --no-cache php7-fpm \
                   php7-ctype \
                   php7-dom \
                   php7-gd \
                   php7-iconv \
                   php7-json \
                   php7-xml \
                   php7-mbstring \
                   php7-posix \
                   php7-simplexml \
                   php7-xmlreader \
                   php7-xmlwriter \
                   php7-zip \
                   php7-zlib \
                   php7-pdo_mysql \
                   php7-pdo_pgsql \
                   php7-pdo_sqlite \
                   php7-curl \
                   php7-fileinfo \
                   php7-bz2 \
                   php7-intl \
                   php7-mcrypt \
                   php7-openssl \
                   php7-ldap \
                   php7-ftp \
                   php7-imap \
                   php7-exif \
                   php7-gmp \
                   php7-apcu \
                   php7-memcached \
                   php7-opcache \
                   php7-imagick \
                   php7-pcntl \
                   ffmpeg \
                   samba-client \
                   tzdata curl nginx supervisor && \
  mkdir  /var/www/localhost/htdocs/nextcloud && \
  curl -sL https://download.nextcloud.com/server/releases/nextcloud-${NEXTCLOUD_VERSION}.tar.bz2 | tar xj -C /var/www/localhost/htdocs/nextcloud --strip-components=1 && \
  mkdir -p /var/www/localhost/htdocs/nextcloud/data /run/nginx/  && \
  find /var/www/localhost/htdocs/ -type d -exec chmod 770 {} \; && \
  find /var/www/localhost/htdocs/ -type f -exec chmod 660 {} \; && \
  chown -R nginx:nobody  /var/www/localhost/htdocs/ && \
  apk del curl

RUN { \
  echo 'opcache.enable=1'; \
  echo 'opcache.enable_cli=1'; \
  echo 'opcache.interned_strings_buffer=8'; \
  echo 'opcache.max_accelerated_files=10000'; \
  echo 'opcache.memory_consumption=128'; \
  echo 'opcache.save_comments=1'; \
  echo 'opcache.revalidate_freq=1'; \
  } >> /etc/php7/conf.d/00_opcache.ini

RUN { \
        echo 'env[HOSTNAME] = $HOSTNAME'; \
        echo 'env[PATH] = /usr/local/bin:/usr/bin:/bin'; \
        echo 'env[TMP] = /tmp'; \
        echo 'env[TMPDIR] = /tmp'; \
        echo 'env[TEMP] = /tmp'; \
} >> /etc/php7/php-fpm.d/www.conf


COPY custom.conf /etc/nginx/conf.d/default.conf
COPY supervisord.conf /tmp/

EXPOSE 80

VOLUME /var/www/localhost/htdocs/nextcloud/data/
VOLUME /var/www/localhost/htdocs/nextcloud/config/

LABEL url=https://github.com/nextcloud/server/
LABEL version=${NEXTCLOUD_VERSION}

CMD /usr/bin/supervisord -c /tmp/supervisord.conf
