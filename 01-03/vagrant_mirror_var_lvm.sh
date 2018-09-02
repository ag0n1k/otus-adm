#!/bin/bash

echo "-----> Current situation of Physical Volumes:"
pvs
df -h
sleep 3

echo "-----> Remove tmp_VG"
sudo vgremove -f tmp_VG
sudo pvremove /dev/sdb

sudo pvcreate /dev/sdb /dev/sdc
sudo vgcreate -f var_VG /dev/sdb /dev/sdc
sudo lvcreate -L 8g -m1 -n var_mirror var_VG -y -Wy -Zy

sudo mkfs.xfs -f -L var_mirror /dev/var_VG/var_mirror >/dev/null

sudo mkdir /mnt/tmp
sudo mount /dev/var_VG/var_mirror /mnt/tmp
sudo cp -ar /var/* /mnt/tmp
sudo umount /mnt/tmp

sudo cp /etc/fstab /tmp/fstab
sudo chown vagrant /tmp/fstab
sudo echo "/dev/mapper/var_VG-var_mirror /var xfs defaults 0 0" >> /tmp/fstab

sudo cp /tmp/fstab /etc/fstab

sudo reboot
