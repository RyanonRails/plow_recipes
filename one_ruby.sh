# Install default ruby
# 
# Based on http://blog.arkency.com/2012/11/one-app-one-user-one-ruby/
#
# $RUBY_VERSION - ruby-version
# $DEPLOY_USER_NAME - deploy user name
# $BUNDLER_FLAGS - bundler flags

# Install ruby-build
if which ruby-build ; then
  echo 'ruby-build already installed'
else
  mkdir -p /usr/local/sources
  git clone git://github.com/sstephenson/ruby-build.git /usr/local/sources/ruby-build
  (cd /usr/local/sources/ruby-build && ./install.sh)
fi

# Install ruby
if test -d "/home/$DEPLOY_USER_NAME/$RUBY_VERSION" ; then
  echo "ruby-$RUBY_VERSION already installed"
else
  ruby-build $RUBY_VERSION /home/$DEPLOY_USER_NAME/$RUBY_VERSION
fi

# Update path
if grep -xq "export PATH=\$HOME/$RUBY_VERSION/bin:\$PATH" /home/$DEPLOY_USER_NAME/.bashrc ; then
  echo 'Path already includes ruby'
else
  sed -i "1i export PATH=\$HOME/$RUBY_VERSION/bin:\$PATH" /home/$DEPLOY_USER_NAME/.bashrc
fi

# Install bundler
if /home/$DEPLOY_USER_NAME/$RUBY_VERSION/bin/gem list | grep -q bundler ; then
  echo "bundler already installed"
else
  /home/$DEPLOY_USER_NAME/$RUBY_VERSION/bin/gem install bundler $BUNDLER_FLAGS --no-ri --no-rdoc
fi

