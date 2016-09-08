#!/bin/sh
set -eu

# post optional settings

# create self certificate
if [ -e "/usr/local/etc/h2o/cert.pem" ]; then
  :
else
  openssl genrsa 2048 > /usr/local/etc/h2o/cert.key
  openssl req -new -key /usr/local/etc/h2o/cert.key -subj '/C=JP/ST=Okinawa/L=Naha/O=u-ryukyu.ac/OU=ie/CN=wakingmask'  > /usr/local/etc/h2o/cert.csr
  openssl x509 -days 3650 -req -signkey /usr/local/etc/h2o/cert.key < /usr/local/etc/h2o/cert.csr > /usr/local/etc/h2o/cert.pem
fi

# copy h2o_isucon5.conf
if [ -e "/usr/local/etc/h2o/h2o.conf" ]; then
  rm /usr/local/etc/h2o/h2o.conf
  cp ./opt/h2o_isucon5.conf /usr/local/etc/h2o/h2o.conf
else
  cp ./opt/h2o_isucon5.conf /usr/local/etc/h2o/h2o.conf
fi

# restart h2o
if [ "`systemctl is-active h2o`" = "unknown" ]; then
  systemctl start h2o
else
  systemctl restart h2o
fi

exit 0
