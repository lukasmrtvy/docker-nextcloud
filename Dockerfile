FROM alpine:latest

RUN apk update --no-cache && \
apk upgrade --no-cache && \
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
                   php7-smbclient \
                   php7-ldap \  
                   php7-ftp \ 
                   php7-imap \
                   php7-exif \
                   php7-gmp \
                   php7-apcu \
                   php7-memcached \ 
                   php7-opcache \
                   php7-imagick \
                   ffmpeg \
                   php7-pcntl \
                   curl lighttpd bash libsmbclient libreoffice 

RUN  mkdir  /var/www/localhost/htdocs/nextcloud && \
     curl --insecure -s https://download.nextcloud.com/server/releases/latest.tar.bz2 | tar xj -C /var/www/localhost/htdocs/nextcloud --strip-components=1 &&  echo "<?php phpinfo(); ?>" > /var/www/localhost/htdocs/index.php &&  \
     echo 'include "mod_fastcgi_fpm.conf"' >> /etc/lighttpd/lighttpd.conf 

RUN { \
        echo 'opcache.memory_consumption=128'; \
        echo 'opcache.interned_strings_buffer=8'; \
        echo 'opcache.max_accelerated_files=10000'; \
        echo 'opcache.revalidate_freq=1'; \
        echo 'opcache.fast_shutdown=1'; \
        echo 'opcache.save_comments=1'; \
        echo 'opcache.enable_cli=1'; \
    } >> /etc/php7/conf.d/00_opcache.ini


EXPOSE 80

RUN  chown -R lighttpd:nobody  /var/www/localhost/htdocs/ &&  find /var/www/localhost/htdocs/ -type d -exec chmod 770 {} \; && find /var/www/localhost/htdocs/ -type f -exec chmod 660 {} \;

CMD php-fpm7 -D && lighttpd -D -f /etc/lighttpd/lighttpd.conf
