#!/bin/sh

install_composer() {
	echo 'downloading composer'
	EXPECTED_CHECKSUM="$(php -r 'copy("https://composer.github.io/installer.sig", "php://stdout");')"
	php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
	ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

	if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]
	then
		>&2 echo 'ERROR: Invalid composer installer checksum'
		rm composer-setup.php
		exit 1
	fi

	echo 'installing composer...'
	php composer-setup.php --quiet
	rm composer-setup.php
}

# check for composer
if [ ! -f "composer.phar" ]; then
	install_composer
fi

# update project dependencies
echo 'updating dependencies'
php composer.phar update 

# run server
echo '//==========================================//'
echo 'running server...'
php artisan serve --host 0.0.0.0 --port 8000 -vvv
