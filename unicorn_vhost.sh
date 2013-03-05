# Install unicorn-friendly vhost
#
# $APP_NAME - app_name
# $MY_AMA_CRT - ssl_cert
# $MY_AMA_KEY - ssl_key
#
# requires:
#   nginx

  rm -f /opt/nginx/sites-available/$APP_NAME
  cp ~/plow/templates/unicorn_vhost /opt/nginx/sites-available/$APP_NAME
  ln -sf /opt/nginx/sites-available/$APP_NAME /opt/nginx/sites-enabled/$APP_NAME
  restart nginx


if [[ -e /etc/ssl/$MY_AMA_CRT ]] && 
  diff -q /etc/ssl/$MY_AMA_CRT ~/plow/files/$MY_AMA_CRT > /dev/null 2>&1; then
  echo 'SSL cert already exists'
else
  cp ~/plow/files/$MY_AMA_CRT /etc/ssl/
  cp ~/plow/files/$MY_AMA_KEY /etc/ssl/
  restart nginx
fi