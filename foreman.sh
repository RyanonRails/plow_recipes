# Install application foreman templates
#
# $DEPLOY_USER_NAME - deploy user name
#
# requires:
#   deploy user name

FOREMAN_DIR=/home/$DEPLOY_USER_NAME/.foreman
TEMPLATE_DIR=$FOREMAN_DIR/templates/runit
RUN_TEMPLATE=$TEMPLATE_DIR/run.erb
LOG_DIR=$TEMPLATE_DIR/log
LOG_TEMPLATE=$LOG_DIR/run.erb

mkdir -p $LOG_DIR

if [[ -e $RUN_TEMPLATE ]] &&
  diff -q $RUN_TEMPLATE ~/plow/files/foreman.run > /dev/null 2>&1; then
  echo 'Foreman run.erb template already exists'
else
  cp ~/plow/files/foreman.run $RUN_TEMPLATE
fi

if [[ -e $LOG_TEMPLATE ]] &&
  diff -q $LOG_TEMPLATE ~/plow/files/foreman.log_run > /dev/null 2>&1; then
  echo 'Foreman log_run.erb template already exists'
else
  cp ~/plow/files/foreman.log_run $LOG_TEMPLATE
fi

chown -R $DEPLOY_USER_NAME $FOREMAN_DIR
chgrp -R $DEPLOY_USER_NAME $FOREMAN_DIR
