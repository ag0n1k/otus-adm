#!/bin/bash

echo "-----> Current situation of Physical Volumes:"
pvs

echo "-----> Generate files"

echo "test1" > /home/vagrant/test1.txt
echo "test2" > /home/vagrant/test2.txt
echo "test3" > /home/vagrant/test3.txt
echo "test4" > /home/vagrant/test4.txt
echo "test5" > /home/vagrant/test5.txt

echo "-----> Create snapshot"
lvcreate -s -L 20M -n LogVol_home-snap /dev/VolGroup00/LogVol_home

echo "-----> See at ls command"
ls -l /home/vagrant/
rm -f /home/vagrant/test3.txt
rm -f /home/vagrant/test1.txt
rm -f /home/vagrant/test5.txt

echo "-----> See at ls command"
ls -l /home/vagrant/

echo "-----> to restore may reboot after --merge, or... merge, umount, deactvate, activate, mount"
lvconvert --merge VolGroup00/LogVol_home-snap
umount /home/
lvchange -a n /dev/VolGroup00/LogVol_home 
lvchange -a y /dev/VolGroup00/LogVol_home 
mount /home

echo "-----> See at ls command"
ls -l /home/vagrant


