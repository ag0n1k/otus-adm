#!/bin/bash

echo "-----> Current situation of Physical Volumes:"
sudo pvs
df -h
sleep 3

echo "-----> Remove VolGroup00"
sudo vgremove -f VolGroup00 

echo "-----> Add new logical volume"
sudo lvcreate -L 8g -n LogVol00 VolGroup00 -y -Wy -Zy 
sudo mkfs.xfs -f -L LogVol00 /dev/VolGroup00/LogVol00 > /dev/null

sudo lvcreate -L 10g -n LogVol_home VolGroup00 -y -Wy -Zy
sudo mkfs.xfs -f -L LogVol_home /dev/VolGroup00/LogVol_home >/dev/null

sudo lvcreate -L 8g -n LogVol_var VolGroup00 -y -Wy -Zy
sudo mkfs.xfs -f -L LogVol_var /dev/VolGroup00/LogVol_var >/dev/null

sudo lvcreate -L 10g -s -n LogVol_home_snap VolGroup00 
#sudo mkfs.xfs -f -L LogVol_home_snap /dev/VolGroup00/LogVol_home_snap >/dev/null

echo "prepare home"

sudo mkdir /mnt/tmp
sudo mount /dev/mapper/VolGroup00-LogVol_home /mnt/tmp
sudo cp -ar /home/* /mnt/tmp

sudo umount /mnt/tmp

sudo mount /dev/mapper/VolGroup00-LogVol_var /mnt/tmp
sudo cp -ar /var/* /mnt/tmp

sudo umount /mnt/tmp

sudo cp /etc/fstab /tmp/fstab
sudo chown vagrant /tmp/fstab

sudo echo "/dev/mapper/VolGroup00-LogVol_home /home xfs defaults 0 0" >> /tmp/fstab

sudo cp /tmp/fstab /etc/fstab

sudo cat /etc/fstab

sleep 3

sudo mount /dev/mapper/VolGroup00-LogVol00 /mnt/tmp/

echo "-----> Current situation of Physical Volumes:"
df -h

sleep 3

sudo xfsdump -J - / | sudo xfsrestore -J - /mnt/tmp/

sudo sed -i -- 's/tmp_VG/VolGroup00/g' /boot/grub2/grub.cfg
sudo sed -i -- 's/LogVolroot/LogVol00/g' /boot/grub2/grub.cfg
sudo sed -i -- 's/LogVolswap/LogVol01/g' /boot/grub2/grub.cfg

echo "-----> Current situation of Physical Volumes:"
sudo pvs

echo -e "\n-----> Reboot............"
sleep 3

sudo reboot

