#!/usr/bin/env bash
set -eu

# require root user
if [ "$UID" -eq 0 ];then
  :
else
  echo "error. please switch user root."
  exit 1
fi

# environment-dependent settings
if [ -e "./pre/pre.sh" ]; then
  sh ./pre/pre.sh
fi

sh ./src/aptget.sh
sh ./src/install.sh
sh ./src/service.sh

exit 0
