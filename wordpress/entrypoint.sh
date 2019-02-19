#!/bin/bash

# mute CMD from official wordpress image
sed -i -e 's/^exec "$@"/#exec "$@"/g' /usr/local/bin/docker-entrypoint.sh

# execute bash script from official wordpress image
source /usr/local/bin/docker-entrypoint.sh

# Reset permissions on the site in the event any have been changed due to mounts
chown -R www-data:www-data /var/www/html

# execute CMD
exec "$@"