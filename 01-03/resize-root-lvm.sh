#!/bin/bash

echo "#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#"
echo "# DISCLAIMER:                                                                                         #"
echo "#                                                                                                     #"
echo "# It's not executable script, it's like history of command sequence to execute to complete the work...#"
echo -e "#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#\n\n"

echo "Steps to reproduce:                                                                                 "
#echo -e "#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#\n"



echo -e "  1. Find vm uuid:"
echo -e "  \$ vm_uuid=\$(VBoxManage list vms | grep \$vm_key | awk '{print \$2}' | tr -d [{}])"
echo -e "\n  2. Set up additional disk"
echo -e "  \$ VBoxManage createhd --filename \$disk_name --size \$new_disk_size --format VDI"
echo -e "\n  3. Create storage drive"
echo -e "  \$ VBoxManage storagectl \$vm_uuid --name "SATA Controller" --add sata --controller IntelAhci"
echo -e "\n  4. Attach additional disk to vm"
echo -e "  \$ VBoxManage storageattach \$vm_uuid --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium \$disk_name"
echo -e "\n  5. Login into rescue mode"
echo -e "  \$ VBoxManage startvm \$vm_uuid"


echo -e "\n\n#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#"
echo "# Vars for current environment:                                                                       #"
echo "#                                                                                                     #"
echo "# vm_key=01-03                                                                                        #"
echo "# disk_name=new_disk.vdi                                                                              #"
echo "# new_disk_size=8192                                                                                  #"
echo "#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#"

exit

# get vm uuid. note 01-03 - my key to find..
vm_key="01-03
vm_uuid=$(VBoxManage list vms | grep $vm_key | awk '{print $2}' | tr -d [{}])

# set up additional disk
new_disk_size=8192
VBoxManage createhd --filename new_disk.vdi --size $new_disk_size --format VDI

# attach additional disk to vm

# login to rescue mode
VBoxManage startvm $vm_uuid

original_disk_name="centos-7-1-1.x86_64.vmdk"


VBoxManage clonehd centos-7-1-1.x86_64.vmdk old_disk.vdi --format vdi

VBoxManage clonehd old_disk.vdi new_disk.vdi  --existing

old_uuid=$(VBoxManage showhdinfo centos-7-1-1.x86_64.vmdk | head -n 1 | awk '{print $2}')




VBoxManage storageattach 76741937-8485-44ec-8232-946872c2a72f --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium centos-7-1-1-0.x86_64.vdi



