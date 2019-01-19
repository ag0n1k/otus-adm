#!/usr/bin/env bash

sudo useradd user_deny
sudo useradd user_allow
sudo groupadd admin
sudo usermod -a -G admin user_allow
sudo usermod -a -G admin vagrant

sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum install -y pam_script python-pip gcc python-devel
sudo pip install workalendar

sudo cp /vagrant/scripts/* /etc/pam-script.d/

sudo chmod +x /etc/pam-script.d/check_holidays.py
sudo chmod +x /etc/pam-script.d/holiday_admin_acct

sudo cp -r /home/vagrant/.ssh /home/user_allow/.ssh
sudo cp -r /home/vagrant/.ssh /home/user_deny/.ssh

sudo chown -R user_deny:user_deny /home/user_deny
sudo chown -R user_allow:user_deny /home/user_allow

sudo cp /vagrant/configuration/sshd /etc/pam.d/sshd
sudo cp /vagrant/configuration/group.conf /etc/security/
