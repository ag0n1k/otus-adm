#!/bin/bash

echo "Startup vm for initialization"
echo 'Destroy'
vagrant destroy -f > /dev/null
echo 'Up'
vagrant up > /dev/null

echo "Set up variables..."

script_path=$(readlink -f $0)
script_dir=$(dirname $script_path)
. $script_dir/resize-root-lvm.conf
new_disk_size=10240

echo "Lookup ssh information from vagrant (Host, Port and private key path)"
ssh_port=$(vagrant ssh-config  | grep Port | awk '{print $2}')
ssh_host=$(vagrant ssh-config  | grep HostName | awk '{print $2}')
ssh_private_key=$(vagrant ssh-config  | grep IdentityFile | awk '{print $2}')
ssh_user=$(vagrant ssh-config | grep User | head -1 | awk '{print $2}')

echo "WARNING: Machine fingerprint will be added to user known hosts!!!"

ssh-keyscan -p $ssh_port -H $ssh_host >> ~/.ssh/known_hosts

echo -n "vm uuid: "
vm_uuid=$(VBoxManage list vms | grep $vm_key | awk '{print $2}' | tr -d [{}])
echo $vm_uuid

echo "Shutdown"

vagrant halt > /dev/null

sleep 3


if ! [ -f $disk_name ]; then
  echo "create additional disk"

  VBoxManage createhd --filename var_1.vdi --size $new_disk_size --format VDI
  VBoxManage createhd --filename var_2.vdi --size $new_disk_size --format VDI
  sleep 3
  echo "create storage drive"
fi
VBoxManage storagectl $vm_uuid --name "$sata_ctl_name" --add sata --controller IntelAhci
sleep 3
echo "attach disk"

VBoxManage storageattach $vm_uuid --storagectl "$sata_ctl_name" --port 0 --device 0 --type hdd --medium var_1.vdi
VBoxManage storageattach $vm_uuid --storagectl "$sata_ctl_name" --port 1 --device 0 --type hdd --medium var_2.vdi

sleep 3

echo "check that disk attached"

vboxmanage showvminfo $vm_uuid | grep UUID

sleep 5

echo "Start vm..."
vagrant up > /dev/null


echo "prepare new disk data"

echo "ssh -i $ssh_private_key ${ssh_user}'@'${ssh_hos}t -p $ssh_port "
ssh -i $ssh_private_key ${ssh_user}"@"${ssh_host} -p $ssh_port "bash /vagrant/vagrant_prepare_new_disk.sh"

sleep 5

echo -n "wait for vm reboot complete"

while ! nc -z $ssh_host $ssh_port ; do
  sleep 1
  echo -n '.'
done

echo

sleep 5

echo "resize root lvm"

ssh -i $ssh_private_key ${ssh_user}"@"${ssh_host} -p $ssh_port "bash /vagrant/vagrant_resize_root_lvm.sh"

sleep 5

echo -n "wait for vm reboot complete"

while ! nc -z $ssh_host $ssh_port ; do
  sleep 1
  echo -n '.'
done

echo

echo "check partitions are ok..."
sleep 40

echo "ssh -i $ssh_private_key ${ssh_user}'@'${ssh_host} -p $ssh_port "df -h""

ssh -i $ssh_private_key $ssh_user"@"$ssh_host -p $ssh_port "df -h"


ssh -i $ssh_private_key root"@"${ssh_host} -p $ssh_port "bash /vagrant/vagrant_snap_home_test.sh"
ssh -i $ssh_private_key $ssh_user"@"${ssh_host} -p $ssh_port "bash /vagrant/vagrant_mirror_var_lvm.sh"

sleep 40

ssh -i $ssh_private_key $ssh_user"@"$ssh_host -p $ssh_port "df -h"

exit