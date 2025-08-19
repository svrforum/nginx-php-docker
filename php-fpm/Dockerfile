FROM php:8.4-fpm-alpine

# persistent dependencies and iconv fix
RUN set -eux; \
    apk add --no-cache \
        bash \
        ghostscript \
        imagemagick \
        ffmpeg \
        gnu-libiconv
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

# install the PHP extensions we need
RUN set -eux; \
    apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
        freetype-dev \
        icu-dev \
        imagemagick-dev \
        libjpeg-turbo-dev \
        libpng-dev \
        libwebp-dev \
        libzip-dev \
        libmemcached-dev \
        zlib-dev \
        cyrus-sasl-dev; \
    \
    docker-php-ext-configure gd \
        --with-freetype \
        --with-jpeg \
        --with-webp; \
    docker-php-ext-configure intl; \
    docker-php-ext-install -j"$(nproc)" \
        bcmath \
        exif \
        gd \
        intl \
        mysqli \
        zip \
        pdo \
        pdo_mysql; \
    \
    pecl install redis apcu imagick memcached; \
    docker-php-ext-enable redis apcu imagick memcached; \
    \
    runDeps="$( \
        scanelf --needed --nobanner --format '%n#p' --recursive /usr/local/lib/php/extensions \
            | tr ',' '\n' \
            | sort -u \
            | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
    )"; \
    apk add --no-cache --virtual .php-phpexts-rundeps $runDeps; \
    apk del --no-network .build-deps; \
    rm -r /tmp/pear; \
    ! { ldd /usr/local/lib/php/extensions/*.so | grep 'not found'; }; \
    err="$(php --version 3>&1 1>&2 2>&3)"; \
    [ -z "$err" ]

# set recommended PHP.ini settings
RUN set -eux; \
    docker-php-ext-enable opcache; \
    { \
        echo 'opcache.memory_consumption=128'; \
        echo 'opcache.interned_strings_buffer=8'; \
        echo 'opcache.max_accelerated_files=4000'; \
        echo 'opcache.revalidate_freq=2'; \
        echo 'opcache.fast_shutdown=1'; \
        echo 'opcache.enable=1'; \
        echo 'opcache.jit_buffer_size=100M'; \
        echo 'opcache.jit=tracing'; \
    } > /usr/local/etc/php/conf.d/opcache-recommended.ini

# configure error logging
RUN { \
    echo 'error_reporting = E_ERROR | E_WARNING | E_PARSE | E_CORE_ERROR | E_CORE_WARNING | E_COMPILE_ERROR | E_COMPILE_WARNING | E_RECOVERABLE_ERROR'; \
    echo 'display_errors = Off'; \
    echo 'display_startup_errors = Off'; \
    echo 'log_errors = On'; \
    echo 'error_log = /dev/stderr'; \
    echo 'log_errors_max_len = 1024'; \
    echo 'ignore_repeated_errors = On'; \
    echo 'ignore_repeated_source = Off'; \
    echo 'html_errors = Off'; \
} > /usr/local/etc/php/conf.d/error-logging.ini
