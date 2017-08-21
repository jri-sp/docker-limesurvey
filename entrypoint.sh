#!/bin/bash
set -e

# Check WIZZARD_BYPASS to show LimeSurvey Wizzard or use config.php with docker environment variables.
if [ ! -z "$WIZARD_BYPASS" ] && [ "$WIZARD_BYPASS" == "true" ]
then
  /bin/cp $ROOT_DIR/application/config/config.docker.php $ROOT_DIR/application/config/config.php
fi

if [ ! -z "$BASE_URI" ]
then
  sed -i.original -e '/^<VirtualHost[ ]\*:80>/,/<\/VirtualHost>/ { /<\/VirtualHost>/ i\Alias ${BASE_URI} /var/www/html' -e '}' /etc/apache2/sites-enabled/000-default.conf
fi

# Hide PHP version
echo "expose_php=off" >> /usr/local/etc/php/conf.d/security.ini

# Apache things
# Hide version
sed -i "s/^ServerTokens OS$/ServerTokens Prod/" /etc/apache2/conf-available/security.conf
sed -i "s/^ServerSignature On$/ServerSignature Off/" /etc/apache2/conf-available/security.conf
echo "UseCanonicalName On" >> /etc/apache2/conf-available/security.conf

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- apache2-foreground "$@"
fi

exec "$@"
