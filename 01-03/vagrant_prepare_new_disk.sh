#!/bin/bash

echo "-----> Install packages..."

sudo yum install -y xfsdump

echo "-----> Current situation of Physical Volumes:"
sudo pvs

sleep 3

echo "-----> Prepare new disk"

sudo pvcreate /dev/sdb

sudo vgcreate tmp_VG /dev/sdb
sudo lvcreate -L 1G -n LogVolswap tmp_VG
sudo lvcreate -l 100%FREE -n LogVolroot tmp_VG
sudo vgchange -a y tmp_VG

sudo mkfs.xfs -L LogVolroot /dev/tmp_VG/LogVolroot > /dev/null
sudo mkswap /dev/tmp_VG/LogVolswap > /dev/null

echo "-----> Dump current system on temprorary disk" 

sudo mkdir /mnt/tmp

sudo mount /dev/tmp_VG/LogVolroot /mnt/tmp

sudo xfsdump -J - / | sudo xfsrestore -J - /mnt/tmp

sudo umount /mnt/tmp

echo "-----> Prepare grub to boot with temporary disk"

sudo sed -i -- 's/VolGroup00/tmp_VG/g' /boot/grub2/grub.cfg
sudo sed -i -- 's/LogVol00/LogVolroot/g' /boot/grub2/grub.cfg
sudo sed -i -- 's/LogVol01/LogVolswap/g' /boot/grub2/grub.cfg

echo "Reboot"

sleep 3

sudo reboot
