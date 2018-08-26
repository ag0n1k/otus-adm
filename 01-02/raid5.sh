
function print_command {
echo -e "\n-------------------------$1------------------------------------------------\n"
$2
echo -e "---------------------------$1------------------------------------------------\n\n\n"
sleep 5
}


echo "Starting script to create, broke and reestablish raid5...\n"
sleep 3
print_command "Check /dev/sd*" "ls -l /dev/sd*"
print_command "Zero block" "sudo mdadm --zero-superblock /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf"

print_command "Create raid5 of sd{b..f}" "sudo mdadm --create /dev/md0 -l5 -n5 /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf"
print_command "Check sfdisk" "sudo sfdisk -l"
print_command "Check mdadm" "sudo mdadm -D /dev/md0"

echo -e "---------------------------Create partition table of raid 5---------------------------\n\n\n"
(
echo o          # Create a new empty GPT partition table
echo y          # Say yes to lose data
echo n          # Add a new partition
echo 1          # Partition number (Accept default: 1)
echo            # First sector (Accept default: 2048)
echo 400000     # Last sector
echo            # Choose type (Accept default: Linux Filesystem)
echo n          # Add a new partition
echo 2          # Partition number (default: 1)
echo            # First sector (Accept default...)
echo 800000     # Last sector
echo            # Choose type (Accept default: Linux Filesystem)
echo n          # Add a new partition
echo 3          # Partition number (default: 1)
echo            # First sector (Accept default...)
echo 1200000    # Last sector
echo            # Choose type (Accept default: Linux Filesystem)
echo n          # Add a new partition
echo 4          # Partition number (default: 1)
echo            # First sector (Accept default...)
echo 1600000    # Last sector
echo            # Choose type (Accept default: Linux Filesystem)
echo n          # Add a new partition
echo 5          # Partition number (Accept default: 1)
echo            # First sector (Accept default: 2048)
echo 2000000    # Last sector
echo            # Choose type (Accept default: Linux Filesystem)
echo p          # Look at result one time
echo w          # Write changes
echo y          # agree to destroy information
) | sudo gdisk /dev/md0
echo -e "---------------------------Create partition table of raid 5---------------------------"
sleep 10

print_command "---------------------------Check sfdisk---------------------------" "sudo sfdisk -l"
print_command "---------------------------Create filesystem---------------------------" "sudo mkfs.ext4 /dev/md0p1"
sudo mkfs.ext4 /dev/md0p2
sudo mkfs.ext4 /dev/md0p3
sudo mkfs.ext4 /dev/md0p4
sudo mkfs.ext4 /dev/md0p5
print_command "---------------------------Check df -h---------------------------" "df -h"

sudo fdisk -l
echo -e "---------------------------Create directory and mount raid5---------------------------\n\n\n"
sudo mkdir /otus{1..5}
sudo mount /dev/md0p1 /otus1/
sudo mount /dev/md0p2 /otus2/
sudo mount /dev/md0p3 /otus3/
sudo mount /dev/md0p4 /otus4/
sudo mount /dev/md0p5 /otus5/
echo -e "---------------------------Create directory and mount raid5---------------------------"

print_command "------------------------Check df -h command output------------------------" "df -h"
print_command "------------------------Broke raid 5------------------------" "sudo mdadm /dev/md0 -f /dev/sde"
print_command "------------------------Check that broken------------------------" "sudo mdadm -D /dev/md0"

echo -e "------------------------remove bad disk, zero it, add and check that all good!------------------------\n\n\n"
sudo mdadm /dev/md0 --remove /dev/sde
sudo mdadm --zero-superblock /dev/sde
sudo mdadm /dev/md0 --add /dev/sde
sudo mdadm -D /dev/md0
sleep 5
echo -e "------------------------You see syncing. Now it's good------------------------\n\n\n"
sudo mdadm -D /dev/md0
echo -e "------------------------You see syncing. Now it's good------------------------"
sleep 3

echo -e "------------------------Add raid to startup------------------------\n\n\n"
sudo echo "/dev/md0p1		/otus1		ext4	defaults	0 0" >> /etc/fstab
sudo echo "/dev/md0p2		/otus2		ext4	defaults	0 0" >> /etc/fstab
sudo echo "/dev/md0p3		/otus3		ext4	defaults	0 0" >> /etc/fstab
sudo echo "/dev/md0p4		/otus4		ext4	defaults	0 0" >> /etc/fstab
sudo echo "/dev/md0p5		/otus5		ext4	defaults	0 0" >> /etc/fstab

print_command "Check fstab" "cat /etc/fstab"

echo "------------------------Note: it's added to fstab, if the task was to create conf mdadm, so..."
echo "------------------------Here is a conf file for /etc/mdadm/mdadm.conf:"
sleep 3
sudo mdadm --detail --scan
echo -e "\n------------------------But /etc/mdadm/mdadm.conf does not  exist..."
sleep 3
echo -e "\n------------------------Reboot------------------------"
sleep 3
sudo reboot
