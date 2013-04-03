# Install redis

if which redis-server ; then
  echo "Redis already installed"
else
  sudo apt-get install -y redis-server
fi
