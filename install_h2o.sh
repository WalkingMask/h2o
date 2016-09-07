#!/bin/sh
set -eu

(apt-get install wget tar locate git cmake build-essential checkinstall autoconf pkg-config libtool python-sphinx wget libcunit1-dev nettle-dev libyaml-dev libuv-dev -y)&

# install h2o
if [ -x "/usr/local/bin/h2o" ]; then
  :
else

  if [ "`echo ${PWD##*/}`" = "h2o" ]; then
    :
  else
    echo "error. please cd to h2o/ ."
    exit 1
  fi

  tar xzf v2.0.1.tar.gz
  cd h2o-2.0.1
  cmake -DWITH_BUNDLED_SSL=on .
  make
  sudo make install
fi

if [ -d "/usr/local/etc/h2o" ]; then
  :
else
  mkdir /usr/local/etc/h2o
fi

if [ -d "/var/log/h2o" ]; then
  :
else
  mkdir  /var/log/h2o
  chown www-data:adm /var/log/h2o/
fi

if [ -e "/usr/local/etc/h2o/h2o.conf" ]; then
  rm /usr/local/etc/h2o/h2o.conf
  mv ./h2o_isucon5.conf /usr/local/etc/h2o/h2o.conf
else
  mv ./h2o_isucon5.conf /usr/local/etc/h2o/h2o.conf
fi

if [ -e "/etc/systemd/system//h2o.service" ]; then
  rm /etc/systemd/system/h2o.service
  mv ./h2o.service /etc/systemd/system/h2o.service
  chmod 644 /etc/systemd/system/h2o.service
  chown root /etc/systemd/system/h2o.service
else
  mv ./h2o.service /etc/systemd/system/h2o.service
  chmod 644 /etc/systemd/system/h2o.service
  chown root /etc/systemd/system/h2o.service
fi

systemctl daemon-reload

# stop/disable nginx
systemctl stop nginx
systemctl disable nginx

# start/enable h2o
systemctl start h2o.service
systemctl enable h2o.service

# fin
wait
exit 0
