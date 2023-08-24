#!/bin/sh

php artisan queue:work redis --queue=default --timeout=120 --tries=3 -vvv
