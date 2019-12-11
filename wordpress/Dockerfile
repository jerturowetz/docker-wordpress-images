FROM wordpress:php7.3-apache

LABEL version="1.0.0"
LABEL description="WordPress development environment with Xdebug"

RUN curl -L https://phar.phpunit.de/phpunit.phar > /tmp/phpunit.phar \
	&& chmod +x /tmp/phpunit.phar \
	&& mv /tmp/phpunit.phar /usr/local/bin/phpunit

# Install intl, this is mostly used on standard's install, but exists on wpengine
RUN set -ex; \
  \
  apt-get update; \
  apt-get install -y --no-install-recommends \
    ghostscript \
    zlib1g-dev \
    g++ \
    libgs-dev \
    git \
    subversion \
    wget \
    libxml2-dev \
    imagemagick \
    libmagickwand-dev \
    unzip \
    iproute2 \
    libicu-dev \
  && docker-php-ext-enable imagick \
  && docker-php-ext-configure intl \
  && docker-php-ext-install soap intl \
  && apt-get remove -y libmagickwand-dev libxml2-dev libicu-dev \
  && apt-get autoremove -y \
  && apt-get clean

ENV XDEBUG_PORT 9020

RUN yes | pecl install xdebug \
    && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_autostart=1" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.profiler_enable=1" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.profiler_output_name=cachegrind.out.%t" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.profiler_output_dir=/tmp" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "max_input_vars=2000" >> /usr/local/etc/php/conf.d/custom.ini \
    && rm -rf /usr/local/etc/php/conf.d/opcache-recommended.ini

EXPOSE 9020

# Set some php.ini defaults
RUN { \
    echo 'error_reporting = E_ERROR | E_WARNING | E_PARSE | E_CORE_ERROR | E_CORE_WARNING | E_COMPILE_ERROR | E_COMPILE_WARNING | E_RECOVERABLE_ERROR'; \
    echo 'display_errors = on'; \
    echo 'display_startup_errors = Off'; \
    echo 'log_errors = On'; \
    echo 'error_log = /dev/stderr'; \
    echo 'log_errors_max_len = 1024'; \
    echo 'ignore_repeated_errors = On'; \
    echo 'ignore_repeated_source = Off'; \
    echo 'html_errors = on'; \
    echo 'file_uploads = On'; \
    echo 'memory_limit = 512M'; \
    echo 'upload_max_filesize = 500M'; \
    echo 'post_max_size = 500M'; \
    echo 'max_execution_time = 3600'; \
  } > /usr/local/etc/php/conf.d/uploads.ini

# Reload apache server without killing the container
RUN kill -USR1 1

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN usermod -u 1000 www-data

WORKDIR /var/www/html
ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]
