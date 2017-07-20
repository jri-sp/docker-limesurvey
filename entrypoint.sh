#!/bin/bash
set -e

# Check WIZZARD_BYPASS to show LimeSurvey Wizzard or use config.php with docker environment variables.
if [ ! -z "$WIZARD_BYPASS" ] && [ "$WIZARD_BYPASS" == "true" ]
then
  /bin/cp $ROOT_DIR/application/config/config.docker.php $ROOT_DIR/application/config/config.php
fi

# Apache things
# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- apache2-foreground "$@"
fi

exec "$@"
