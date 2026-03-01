FROM php:8.5-fpm-alpine

# persistent dependencies
RUN set -eux; \
    apk add --no-cache \
        bash \
        ghostscript \
        imagemagick \
        ffmpeg

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

# OPcache settings (tuned for PHP 8.5 + CMS/web app workloads)
RUN { \
    echo 'opcache.enable=1'; \
    echo 'opcache.enable_cli=0'; \
    echo 'opcache.memory_consumption=256'; \
    echo 'opcache.interned_strings_buffer=16'; \
    echo 'opcache.max_accelerated_files=20000'; \
    echo 'opcache.validate_timestamps=1'; \
    echo 'opcache.revalidate_freq=60'; \
    echo 'opcache.file_update_protection=0'; \
    echo 'opcache.save_comments=1'; \
    echo 'opcache.enable_file_override=1'; \
    echo 'opcache.huge_code_pages=0'; \
    echo 'opcache.max_wasted_percentage=10'; \
    echo 'opcache.jit=tracing'; \
    echo 'opcache.jit_buffer_size=128M'; \
} > /usr/local/etc/php/conf.d/opcache-recommended.ini

# PHP performance & upload settings
RUN { \
    echo 'memory_limit=256M'; \
    echo 'max_memory_limit=512M'; \
    echo 'max_execution_time=300'; \
    echo 'max_input_time=300'; \
    echo 'max_input_vars=5000'; \
    echo 'realpath_cache_size=4096K'; \
    echo 'realpath_cache_ttl=600'; \
    echo 'upload_max_filesize=64M'; \
    echo 'post_max_size=64M'; \
    echo 'output_buffering=4096'; \
    echo 'zlib.output_compression=On'; \
} > /usr/local/etc/php/conf.d/php-performance.ini

# security settings
RUN { \
    echo 'expose_php=Off'; \
    echo 'session.cookie_httponly=1'; \
    echo 'session.cookie_secure=1'; \
    echo 'session.use_strict_mode=1'; \
    echo 'session.cookie_samesite=Lax'; \
} > /usr/local/etc/php/conf.d/php-security.ini


# error logging
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

# PHP-FPM pool tuning (prevent memory leaks in long-running CMS processes)
# PHP 8.3+: zz-docker.conf no longer overrides listen, so explicit 0.0.0.0:9000 required for Docker networking
RUN sed -i \
    -e 's/^listen = .*/listen = 9000/' \
    -e 's/^pm.max_children.*/pm.max_children = 50/' \
    -e 's/^pm.start_servers.*/pm.start_servers = 5/' \
    -e 's/^pm.min_spare_servers.*/pm.min_spare_servers = 5/' \
    -e 's/^pm.max_spare_servers.*/pm.max_spare_servers = 35/' \
    /usr/local/etc/php-fpm.d/www.conf && \
    { \
        echo 'pm.max_requests = 500'; \
        echo 'request_terminate_timeout = 300'; \
        echo 'listen.backlog = 1024'; \
    } >> /usr/local/etc/php-fpm.d/www.conf
