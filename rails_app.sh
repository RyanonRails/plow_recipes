# Configure the rails app for cap deploy:setup
#
# $DEPLOY_USER_NAME - deploy user name
# $APP_NAME - app_name
# $GIT_HOST - git_host
#
# requires:
#   deployer


if test -d /srv/$APP_NAME ; then
  echo 'App folder already created'
else
  mkdir -p /srv/$APP_NAME
  chown $DEPLOY_USER_NAME /srv/$APP_NAME
fi

if [[ -e /home/$DEPLOY_USER_NAME/.ssh/known_hosts ]] &&
   grep -Fq $GIT_HOST /home/$DEPLOY_USER_NAME/.ssh/known_hosts ; then
  echo 'Git host already initialized'
else
  ssh-keyscan $GIT_HOST | tee /home/$DEPLOY_USER_NAME/.ssh/known_hosts
  chown $DEPLOY_USER_NAME:$DEPLOY_USER_NAME /home/$DEPLOY_USER_NAME/.ssh/known_hosts
fi

