#!/usr/bin/env bash

echo "============================================================================"
echo "Installing HTTPD, add service with multiply configuration setup"

sudo yum install -y httpd
sudo cp /vagrant/httpd/httpd@.service /usr/lib/systemd/system
sudo cp /vagrant/httpd/httpd-1000 /etc/sysconfig/
sudo cp /vagrant/httpd/httpd-1001 /etc/sysconfig/

sudo mkdir /var/log/httpd2
sudo mkdir /opt/httpd2
sudo mkdir /run/httpd2
sudo cp -r /etc/httpd/* /opt/httpd2

sudo rm /opt/httpd2/logs
sudo rm /opt/httpd2/modules
sudo rm /opt/httpd2/run
sudo ln -s /var/log/httpd2 /opt/httpd2/logs
sudo ln -s /usr/lib64/httpd/modules /opt/httpd2/modules
sudo ln -s /run/httpd2 /opt/httpd2/run

sudo cp /vagrant/httpd/httpd.conf /opt/httpd2/conf/

sudo restorecon /

sudo systemctl daemon-reload

sudo systemctl start httpd@1001
sudo systemctl start httpd@1000

sudo systemctl status httpd@1001
sudo systemctl status httpd@1000