#!/bin/bash

set -e

if [ ! $WORDPRESS_DB_NAME ]; then echo "Error: WORDPRESS_DB_NAME not set" && exit -1; fi
if [ ! $WORDPRESS_DB_USER ]; then echo  "Error: WORDPRESS_DB_USER not set" && exit -1; fi
if [ ! $WORDPRESS_DB_PASSWORD ]; then echo  "Error: WORDPRESS_DB_PASSWORD not set" && exit -1; fi
  if [ ! $WORDPRESS_DB_HOST ]; then echo "Error: WORDPRESS_DB_HOST not set" && exit -1; fi
if [ ! $SERVER ]; then echo "Error: SERVER not set" && exit -1; fi

apt-get update
apt-get install -y apache2 php5 php5-mysql mysql-client-core-5.5 htop tree

if [ ! -d /var/www/wordpress ]; then
  cd /var/www
  wget http://wordpress.org/latest.tar.gz
  tar -xzvf latest.tar.gz
  chown -R www-data:www-data wordpress
  cd wordpress
  mv /var/www/wordpress/wp-config-sample.php  /var/www/wordpress/wp-config.php
else
  echo "Wordpress already installed"
fi

sed -i "s/username_here/$WORDPRESS_DB_NAME/g" /var/www/wordpress/wp-config.php
sed -i "s/database_name_here/$WORDPRESS_DB_USER/g" /var/www/wordpress/wp-config.php
sed -i "s/password_here/$WORDPRESS_DB_PASSWORD/g" /var/www/wordpress/wp-config.php
sed -i "s/localhost/$WORDPRESS_DB_HOST/g" /var/www/wordpress/wp-config.php

cat >> /etc/apache2/sites-available/wordpress <<EOF
  <VirtualHost *:80>
     ServerName $SERVER
     DocumentRoot /var/www/wordpress
     DirectoryIndex index.php
     <Directory /var/www/wordpress/>
        AllowOverride All
        Order Deny,Allow
        Allow from all
     </Directory>
  </VirtualHost>
EOF

a2ensite wordpress && service apache2 restart

sudo vim /etc/apache2/sites-available/wordpress