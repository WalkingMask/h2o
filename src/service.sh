#!/usr/bin/env bash
set -eu

# make h2o systemd service
if [ -e "/etc/systemd/system//h2o.service" ]; then
  rm /etc/systemd/system/h2o.service
  cp ./res/h2o.service /etc/systemd/system/h2o.service
  chmod 644 /etc/systemd/system/h2o.service
  chown root /etc/systemd/system/h2o.service
else
  cp ./res/h2o.service /etc/systemd/system/h2o.service
  chmod 644 /etc/systemd/system/h2o.service
  chown root /etc/systemd/system/h2o.service
fi

# reflect the changes
systemctl daemon-reload

# stop/disable nginx
if [ "`systemctl is-active nginx`" = "active" ]; then
  systemctl stop nginx
fi
if [ "`systemctl is-enabled nginx`" = "enabled" ]; then
  systemctl disable nginx
fi

# start/enable h2o
if [ "`systemctl is-enabled h2o`" = "disabled" ]; then
  systemctl enable h2o
fi
if [ "`systemctl is-active h2o`" = "unknown" ]; then
  systemctl start h2o
else
  systemctl restart h2o
fi

exit 0
