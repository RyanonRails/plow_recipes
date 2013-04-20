# Install unicorn-friendly vhost
#
# $APP_NAME - app_name
# $SSL_CRT - ssl_cert
# $SSL_KEY - ssl_key
#
# requires:
#   nginx

  rm -f /opt/nginx/sites-available/$APP_NAME
  cp ~/plow/files/unicorn_vhost /opt/nginx/sites-available/$APP_NAME
  ln -sf /opt/nginx/sites-available/$APP_NAME /opt/nginx/sites-enabled/$APP_NAME
  restart nginx


if [[ -e /etc/ssl/$SSL_CRT ]] && 
  diff -q /etc/ssl/$SSL_CRT ~/plow/files/$SSL_CRT > /dev/null 2>&1; then
  echo 'SSL cert already exists'
else
  cp ~/plow/files/$SSL_CRT /etc/ssl/
  cp ~/plow/files/$SSL_KEY /etc/ssl/
  restart nginx
fi
