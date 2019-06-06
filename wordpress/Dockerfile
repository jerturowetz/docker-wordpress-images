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

ARG WITH_XDEBUG=true

RUN if [ $WITH_XDEBUG = "true" ] ; then \
        pecl install xdebug; \
        docker-php-ext-enable xdebug; \
        echo "error_reporting = E_ALL" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
        echo "display_startup_errors = On" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
        echo "display_errors = On" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
        echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
    fi ;

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
