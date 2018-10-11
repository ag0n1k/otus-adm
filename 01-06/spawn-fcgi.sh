#!/usr/bin/env bash

sudo yum install -y epel-release
sudo yum install -y spawn-fcgi

sudo cp /vagrant/spawn-fcgi/spawn-fcgi /usr/local/bin/
sudo cp /vagrant/spawn-fcgi/spawn-fcgi.service /usr/lib/systemd/system/
sudo mv /etc/init.d/spawn-fcgi //etc/init.d/spawn-fcgi.old

sudo systemctl status spawn-fcgi
sudo systemctl daemon-reload
sudo systemctl status spawn-fcgi