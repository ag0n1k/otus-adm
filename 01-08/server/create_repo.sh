#!/usr/bin/env bash

if ! [[ $(whoami) -eq 'root' ]]; then
  echo 'script supposed to be run by superuser' >&2
  exit 2
fi

ROOT_DIR='/vagrant/sos_package'
RPMS_DIR='/vagrant/rpms'
REPO_DIR='/opt/local.repo/'

# install rpmbuild and repo  packages
echo " > install rpmbuild and repo  packages "
sudo yum install -y rpm-build createrepo epel-release 2>&1 >/dev/null
sudo yum install -y nginx 2>&1 >/dev/null
sudo yum-builddep -y $ROOT_DIR/sosreport.spec 2>&1 >/dev/null

# create package (rpm)
echo " > create package (rpm) "
mkdir $REPO_DIR
cd $ROOT_DIR
make rpm 2>&1 >/dev/null

# create repo directory
echo " > create repo directory"
mv $ROOT_DIR/dist-build/noarch/* $REPO_DIR
mv $RPMS_DIR/* $REPO_DIR

# fix permissions
echo " > fix permissions "
chown -R root:root $REPO_DIR

# create repo
echo " > create repo"
createrepo $REPO_DIR 2>&1 >/dev/null
chmod -R o-w+r $REPO_DIR

# create conf file
echo " > create configuration repofile"
cat > /etc/yum.repos.d/local.repo <<EOL
[local]
name=Local Repo
baseurl=file://$REPO_DIR
enabled=1
gpgcheck=0
EOL


# setup nginx
echo " > setup nginx"
cat > /etc/nginx/conf.d/repos.conf <<EOL
server {
        listen 81;
        server_name  repos.otus.linux;
        root   /opt/local.repo;
        location / {
                index  index.php index.html index.htm;
                autoindex on;   #enable listing of directory index
        }
}
EOL

# fix selinux type for the repos
echo " > fix selinux type for the repos "
semanage fcontext -a -t usr_t /opt/loca.repo/
restorecon -v /opt/local.repo/*.rpm

sudo systemctl restart nginx

# try to install package
echo " > try install sosreport package "
sudo yum install -y sosreport
sleep 3

# try which 
echo " > try which sosreport "
which sosreport
sleep 15
