if dpkg -s 'logrotate'; then
  echo 'logrotate already installed'
else
  apt-get update
  apt-get install -y logrotate
  echo 'done installing logrotate'
fi

cat > /etc/logrotate.d/nginx <<EOF
/opt/nginx/logs/*.log {
  daily
  missingok
  rotate 52
  compress
  delaycompress
  notifempty
  create 640 nginx adm
  sharedscripts
  postrotate
    [ -f /opt/nginx/logs/nginx.pid ] && kill -USR1 `cat /opt/nginx/logs/nginx.pid`
  endscript
}
EOF

cat > /etc/logrotate.d/rails <<EOF
/srv/*/log/*.log {
  daily
  rotate 31
  missingok
  notifempty
  delaycompress
  copytruncate
}
EOF

cat > /etc/cron.daily/logrotate <<EOF
#!/bin/sh

/usr/sbin/logrotate /etc/logrotate.conf
EXITVALUE=$?
if [ $EXITVALUE != 0 ]; then
    /usr/bin/logger -t logrotate "ALERT exited abnormally with [$EXITVALUE]"
fi
exit 0
EOF
