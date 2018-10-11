#!/usr/bin/env bash

echo "============================================================================"
echo "Installing HTTPD, add service with multiply configuration setup"

sudo yum install -y httpd
sudo cp /vagrant/httpd/httpd@.service /usr/lib/systemd/system
sudo cp /vagrant/httpd/httpd-1000 /etc/sysconfig/
sudo cp /vagrant/httpd/httpd-1001 /etc/sysconfig/

sudo systemctl daemon-reload

echo "#note: the second server will not start because of config file the same, but:"
echo "service can handle many configurations via @ =)"
echo "next line is sudo systemctl start httpd@1001"

sudo systemctl start httpd@1001
