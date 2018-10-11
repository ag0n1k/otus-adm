#!/usr/bin/env bash

cron_s='/tmp/service_watchdog_started'

pid_=$$
echo $pid_ > $1

if ! [ -f $cron_s ]; then
  touch $cron_s
else
  echo 'script already working!' >&2
  exit
fi

function log {
  echo "[$(date)]: $*"
}

trap "rm '$cron_s'" EXIT SIGTERM
while true; do
  log 'wait 2 sec...'
  sleep 2
  wait
done
