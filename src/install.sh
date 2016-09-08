#!/usr/bin/env bash
set -eu

# install h2o
if [ -x "/usr/local/bin/h2o" ]; then
  :
else

  if [ "`echo ${PWD##*/}`" = "h2o_installer" ]; then
    :
  else
    echo "error. please cd to h2o_installer/ ."
    exit 1
  fi

  wget https://github.com/h2o/h2o/archive/v2.0.3.tar.gz
  tar xzf v2.0.3.tar.gz
  cd h2o-2.0.3
  cmake -DWITH_BUNDLED_SSL=on .
  make
  sudo make install
  cd ..
fi

# create required directory
if [ -d "/usr/local/etc/h2o" ]; then
  rm -r /usr/local/etc/h2o
  mkdir /usr/local/etc/h2o
else
  mkdir /usr/local/etc/h2o
fi

if [ -d "/var/log/h2o" ]; then
  rm -r /var/log/h2o
  mkdir /var/log/h2o
  chown www-data:adm /var/log/h2o/
else
  mkdir /var/log/h2o
  chown www-data:adm /var/log/h2o/
fi

# check config file
if [ -e "./res/h2o.conf" ]; then
  :
else
  cp ./res/h2o_example.conf ./res/h2o.conf
fi

# copy config file
if [ -e "/usr/local/etc/h2o/h2o.conf" ]; then
  rm /usr/local/etc/h2o/h2o.conf
  cp ./res/h2o.conf /usr/local/etc/h2o/h2o.conf
else
  cp ./res/h2o.conf /usr/local/etc/h2o/h2o.conf
fi

exit 0
