#!/usr/bin/env bash

if ! [ $# -eq 1 ]; then
  echo 'ERR: usage '$0' <script_dir>'
  exit 2
fi
cd $1

sudo cp log_monitor.sh /usr/local/bin/log_monitor.sh
sudo chmod 0744 /usr/local/bin/log_monitor.sh
sudo cp log_monitor.conf /etc/sysconfig/log_monitor.conf
sudo chmod 0644 /etc/sysconfig/log_monitor.conf
sudo cp log_monitor.service /etc/systemd/system/multi-user.target.wants/log_monitor.service
sudo cp log_monitor.timer /etc/systemd/system/multi-user.target.wants/log_monitor.timer

sudo systemctl daemon-reload
sudo touch /var/log/timing.log
sudo chmod 666 /var/log/timing.log
echo '5 sec' > /var/log/timing.log

sudo chmod 0644 /var/log/timing.log
echo 'start service...'
sudo systemctl start log_monitor.timer
echo 'check timers'
sudo systemctl list-timers
sleep 3
