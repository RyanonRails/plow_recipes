cat > ~/plow/templates/unicorn_vhost <<End-of-file
upstream app_server {
  server unix:/srv/$APP_NAME/tmp/sockets/unicorn.sock fail_timeout=0;
}

server {
  listen 80;
  listen 443 ssl;
  server_name $HOST_NAME;

  ssl_certificate      /etc/ssl/$APP_NAME.crt;
  ssl_certificate_key  /etc/ssl/$APP_NAME.key;
    
  rewrite ^(.*)$ \$scheme://www.$HOST_NAME\$1 permanent;
}

server {
  listen 80;
  server_name www.$HOST_NAME $SUB_HOST_NAME;

  client_max_body_size 4G;

  access_log /srv/$APP_NAME/log/access.log;
  error_log /srv/$APP_NAME/log/error.log;

  root /srv/$APP_NAME/public/;

  try_files \$uri/index.html \$uri.html \$uri @app;
  error_page 502 503 =503                  @maintenance;
  error_page 500 504 =500                  @server_error;

  location @app {
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_set_header Host \$http_host;
    proxy_redirect off;

    # enable this if and only if you use HTTPS, this helps Rack
    # set the proper protocol for doing redirects:
    # proxy_set_header X-Forwarded-Proto https;

    proxy_pass http://app_server;
  }

  location @maintenance {
    root /srv/$APP_NAME/public;
    try_files /503.html =503;
  }

  location @server_error {
    root /srv/$APP_NAME/public;
    try_files /500.html =500;
  }

  location = /favicon.ico {
    expires    max;
    add_header Cache-Control public;
  }
}

server {
  listen 443;
  server_name www.$HOST_NAME $SUB_HOST_NAME;
  ssl on;

  ssl_certificate      /etc/ssl/$APP_NAME.crt;
  ssl_certificate_key  /etc/ssl/$APP_NAME.key;

  client_max_body_size 4G;

  access_log /srv/$APP_NAME/log/access.log;
  error_log /srv/$APP_NAME/log/error.log;

  root /srv/$APP_NAME/public/;

  try_files \$uri/index.html \$uri.html \$uri @app;
  error_page 502 503 =503                  @maintenance;
  error_page 500 504 =500                  @server_error;

  location @app {
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_set_header Host \$http_host;
    proxy_redirect off;

    # enable this if and only if you use HTTPS, this helps Rack
    # set the proper protocol for doing redirects:
    proxy_set_header X-Forwarded-Proto https;

    proxy_pass http://app_server;
  }

  location @maintenance {
    root /srv/$APP_NAME/public;
    try_files /503.html =503;
  }

  location @server_error {
    root /srv/$APP_NAME/public;
    try_files /500.html =500;
  }

  location ^~ /assets/ {
    gzip_static on;
    expires max;
    add_header Cache-Control public;
  }

  location = /favicon.ico {
    expires    max;
    add_header Cache-Control public;
  }
}

server {
  listen 80;
  server_name assets.$HOST_NAME;

  root /srv/$APP_NAME/public/;

  access_log /srv/$APP_NAME/log/access-assets.log;
  error_log /srv/$APP_NAME/log/error-assets.log;

  location / {
    deny all;
  }

  location ^~ /assets/ {
    allow all;
    gzip_http_version 1.0;
    gzip_static  on;
    expires      365d;
    add_header   Last-Modified "";
    add_header   Cache-Control public;
  }
}
End-of-file