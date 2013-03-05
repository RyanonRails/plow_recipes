# Install runit
#
# $APP_NAME - app_name
# $DEPLOY_USER_NAME - deploy_user
#
# requires:
#   deployer

configure_run_script() {
  RUN_DIR=/etc/sv/$APP_NAME
  mkdir -p $RUN_DIR
  cat > $RUN_DIR/run <<EOF
#!/bin/bash
#
exec 2>&1 sudo -H -u $DEPLOY_USER_NAME \
bash -l -c "runsvdir -P /home/$DEPLOY_USER_NAME/service 'log: ...................................\
..................................................................................\
..................................................................................\
..................................................................................\
...............................................'"
EOF
  chmod  +x $RUN_DIR/run
}

configure_log_script() {
  LOG_DIR=/var/log/runsvdir-$APP_NAME
  SV_DIR=/etc/sv/$APP_NAME/log
  mkdir -p $LOG_DIR
  mkdir -p $SV_DIR
  cat > $SV_DIR/run <<EOF
#!/bin/sh
exec svlogd -tt $LOG_DIR
EOF
  chmod +x $SV_DIR/run
  chown -R $DEPLOY_USER_NAME $LOG_DIR
  chgrp -R $DEPLOY_USER_NAME $LOG_DIR
}

if dpkg -s "runit"; then
  echo 'runit already installed'
else
  apt-get install -y runit
fi

if [ -d /etc/sv/$APP_NAME ]; then
  echo 'runit log and run scripts already created'
else
  configure_run_script $APP_NAME $DEPLOY_USER_NAME
  configure_log_script $APP_NAME $DEPLOY_USER_NAME
  ln -s /etc/sv/$APP_NAME /etc/service/$APP_NAME
fi
