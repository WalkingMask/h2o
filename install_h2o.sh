#!/bin/sh
set -eu

(apt-get install wget tar locate git cmake build-essential checkinstall autoconf pkg-config libtool python-sphinx wget libcunit1-dev nettle-dev libyaml-dev libuv-dev -y)&

# install h2o
if [ -x "/usr/local/bin/h2o" ]; then
  :
else
  mkdir ~/h2o
  cd ~/h2o

  wget https://github.com/h2o/h2o/archive/v2.0.1.tar.gz
  tar xzf v2.0.1.tar.gz
  cd h2o-2.0.1
  cmake -DWITH_BUNDLED_SSL=on .
  make
  sudo make install

  cd ~
  rm -rf ~/h2o
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

cd /usr/local/etc/h2o
if [ -e "./h2o.conf" ]; then
  rm ./h2o.conf
  wget https://gist.githubusercontent.com/WalkingMask/0e642956024c3658f06dccb6306d2022/raw/c1c71f80fbe3950a9d39e8d5344601969892ccdd/h2o_isucon5.conf
  mv ./h2o_isucon5.conf ./h2o.conf
else
  wget https://gist.githubusercontent.com/WalkingMask/0e642956024c3658f06dccb6306d2022/raw/c1c71f80fbe3950a9d39e8d5344601969892ccdd/h2o_isucon5.conf
  mv ./h2o_isucon5.conf ./h2o.conf
fi

cd /etc/systemd/system/
if [ -e "./h2o.service" ]; then
  rm ./h2o.service
  wget https://gist.githubusercontent.com/WalkingMask/4d9761ab3aa30212cd200e23b8dfaf8c/raw/7c54e3a61d1942650813fc8649c28c2ba6384d5b/h2o.service
  chmod 644 ./h2o.service
  chown root ./h2o.service
else
  wget https://gist.githubusercontent.com/WalkingMask/4d9761ab3aa30212cd200e23b8dfaf8c/raw/7c54e3a61d1942650813fc8649c28c2ba6384d5b/h2o.service
  chmod 644 ./h2o.service
  chown root ./h2o.service
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
