# Install postgresql
#
# $DB_USER_NAME - db_user_name
# $DB_PASSWORD - db_password
# $DB_NAME - db_name

if dpkg -s "postgresql-9.2"; then
  echo 'postgresql-9.2 already installed'
else
  apt-get install python-software-properties -y
  add-apt-repository ppa:pitti/postgresql -y
  apt-get update
  apt-get install -y postgresql-9.2 libpq-dev
fi

 if psql postgres -tAc "SELECT 1 FROM pg_roles WHERE rolname='$DB_USER_NAME'" | grep -q 1
   echo 'database user already exists'
 else
   echo "CREATE USER $DB_USER_NAME WITH PASSWORD '$DB_PASSWORD';" | sudo -u postgres psql
   echo "CREATE DATABASE $DB_NAME OWNER $DB_USER_NAME;" | sudo -u postgres psql
 fi




# reference:
#
# sudo -u postgres psql
#  echo "CREATE USER dev WITH PASSWORD 'development' SUPERUSER;" | psql template1
