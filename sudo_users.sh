# Install sudo user authorized_keys
#
# $DEPLOY_USER_NAME - deploy_user
# $AUTHORIZED_KEYS - ssh_key_file_path

if [[ -e /home/$DEPLOY_USER_NAME/.ssh/authorized_keys ]] &&
  diff -q /home/$DEPLOY_USER_NAME/.ssh/authorized_keys ~/plow/files/$AUTHORIZED_KEYS > /dev/null 2>&1; then
  echo 'authorized_keys already created'
else
  mkdir -p /home/$DEPLOY_USER_NAME/.ssh
  cp ~/plow/files/$AUTHORIZED_KEYS /home/$DEPLOY_USER_NAME/.ssh/authorized_keys
  chmod 700 /home/$DEPLOY_USER_NAME/.ssh
  chmod 600 /home/$DEPLOY_USER_NAME/.ssh/authorized_keys
  chown -R $DEPLOY_USER_NAME:$DEPLOY_USER_NAME /home/$DEPLOY_USER_NAME/.ssh
fi
