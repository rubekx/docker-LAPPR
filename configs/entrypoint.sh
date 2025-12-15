#!/bin/bash

# Change to the Apache sites-available directory
cd /etc/apache2/sites-available/

# Disable the default configuration file
a2dissite 000-default.conf

# Enable the host1 configuration file
a2ensite host.conf

# Change ownership of the /var/www/html directory to user 1000 and group www-data
chown -R 1000:www-data /var/www/html

# Change to the app directory
cd /var/www/html

# Install Laravel's dependencies
echo "Install Laravel's dependencies:"
composer install

# Copy the .docker.env file to .env
echo "Copy .env.example to .env:"
cp .env.example .env

# Generate Laravel's keys
echo "Install Laravel's keys:"
php artisan key:generate

# Set file permissions in Laravel for storage and bootstrap/cache directories
echo "Set the file permissions in Laravel:"
chgrp -R www-data storage bootstrap/cache

# Set file permissions in Laravel for storage and bootstrap/cache directories
echo "Set the file permissions in Laravel:"
chmod -R ug+rwx storage bootstrap/cache

# echo "restart completed."
# /etc/init.d/cron restart
# echo "Copy supervisor services."
# cp supervisor-services/laravel-worker.conf /etc/supervisor/conf.d/
# echo "Copy supervisor services."
# cp supervisor-services/laravel-websockets.conf /etc/supervisor/conf.d/
# echo "restart supervisord."
# /etc/init.d/supervisor start && supervisorctl reread && supervisorctl update

cd /var/www/html/
pm2 start ecosystem.config.cjs 

# Restart Apache
echo "Restart Apache:"
apache2-foreground

