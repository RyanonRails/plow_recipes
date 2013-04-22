if dpkg -s "libxml2-dev"; then
  echo 'libxml2 already installed'
else
  apt-get install libxslt-dev libxml2-dev -y
fi
