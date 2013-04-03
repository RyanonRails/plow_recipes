# Custom prompt
#
# $RAILS_ENV - environment
# $DEPLOY_USER_NAME - deploy user name 
# $ROOT_USER_NAME - root user name
#

if grep -q \#\ Prompt /home/$DEPLOY_USER_NAME/.bashrc; then
  echo 'Already found prompt for deploy user'
else
  echo '# Prompt' >> /home/$DEPLOY_USER_NAME/.bashrc
  
  case $RAILS_ENV in
  production)
    echo 'export PS1="\033[1;41m$(date +%H:%M) (\\u) \\w #\033[0m "' >> /home/$DEPLOY_USER_NAME/.bashrc
    ;;
  staging)
    echo 'export PS1="\033[1;44m$(date +%H:%M) (\\u) \\w #\033[0m "' >> /home/$DEPLOY_USER_NAME/.bashrc
    ;;
  esac
fi

if grep -q \#\ Prompt /home/$ROOT_USER_NAME/.bashrc; then
  echo 'Already found prompt for root user'
else
  echo '# Prompt' >> /home/$ROOT_USER_NAME/.bashrc
  
  case $RAILS_ENV in
  production)
    echo 'export PS1="\033[1;41m$(date +%H:%M) (\\u) \\w #\033[0m "' >> /home/$ROOT_USER_NAME/.bashrc
    ;;
  staging)
    echo 'export PS1="\033[1;44m$(date +%H:%M) (\\u) \\w #\033[0m "' >> /home/$ROOT_USER_NAME/.bashrc
    ;;
  esac
fi