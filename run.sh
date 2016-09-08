#!/usr/bin/env bash
set -eu

# require root user
if [ "`id -u $USER`" = "0" ];then
  :
else
  echo "error. please switch user root."
  exit 1
fi

# pre optional settings
if [ -e "./opt/pre.sh" ]; then
  sh ./opt/pre.sh
fi

# main
sh ./src/aptget.sh
sh ./src/install.sh
sh ./src/service.sh

# post optional settings
if [ -e "./opt/post.sh" ]; then
  sh ./opt/post.sh
fi

exit 0
