FROM wordpress:php7.2-apache

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
		ssmtp \
		imagemagick \
		libmagickwand-dev \
		unzip \
		iproute2 \
		libicu-dev \
	&& pecl install imagick \
	&& docker-php-ext-enable imagick \
  && docker-php-ext-configure intl \
	&& docker-php-ext-install soap intl \
	&& echo "mailhub=mailcatcher:1025\nUseTLS=NO\nFromLineOverride=YES" > /etc/ssmtp/ssmtp.conf \
	&& apt-get remove -y libmagickwand-dev libxml2-dev libicu-dev \
	&& apt-get autoremove -y \
	&& apt-get clean

RUN pecl install xdebug \
  && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
  && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
  && echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/xdebug.ini \
  && echo "xdebug.remote_port=9212" >> /usr/local/etc/php/conf.d/xdebug.ini \
  && echo "xdebug.var_display_max_depth = 5" >> /usr/local/etc/php/conf.d/xdebug.ini \
  && echo "xdebug.var_display_max_children = 256" >> /usr/local/etc/php/conf.d/xdebug.ini \
  && echo "xdebug.var_display_max_data = 1024" >> /usr/local/etc/php/conf.d/xdebug.ini

# Set some php.ini defaults
RUN { \
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
