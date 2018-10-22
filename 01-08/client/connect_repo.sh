#!/usr/bin/env bash

echo " > configure repo"
cat > /etc/yum.repos.d/local.repo <<EOL
[local]
name=Local Repo
baseurl=http://192.168.11.101:81/
enabled=1
gpgcheck=0
EOL

# try install sosreport
echo " > try install sosreport"
sudo yum install sosreport -y

echo " > try which sosreport"
which sosreport
sleep 5
