# Working with LVM

### Task:
- On existing image:
/dev/mapper/VolGroup00-LogVol00 38G 738M 37G 2% /

- decrease root / to 8G
- create lvm for /home
- create lvm for /var
- /var - mirror mode
- /home - snapshot tests
- edit fstab
- look at options for filesystems
- generate files at /home/
- get snapshot backup
- remove files
- restore from snapshot
- you may log work by utility `script`

* Try btrfs/zfs on /opt - with cache and snaphosts

### Description:

##### How to:

```
$ bash exercise-course.sh
# hope as simple as that
# The script contains all steps of exercise:
# - initial vagrant setup 
# - add disks by vboxmanage ctl (storage control and attach)
# - prepae vm for boot from new disk (prepare_new_disk)
# - resize root lvm and create new (resize_root_lvm)
# - setup and test snapshots for home directory (snap_home_test)
# - setup mirror lvm for var directory (mirror_var_lvm)
#
# Note: no all vars are at settings as this is test environment...


# After script ends manually check by:
$ vagrant ssh
$ df -h
Filesystem                          Size  Used Avail Use% Mounted on
/dev/mapper/VolGroup00-LogVol00     8.0G  749M  7.3G  10% /
devtmpfs                            487M     0  487M   0% /dev
tmpfs                               496M     0  496M   0% /dev/shm
tmpfs                               496M  6.8M  490M   2% /run
tmpfs                               496M     0  496M   0% /sys/fs/cgroup
/dev/sda2                          1014M   63M  952M   7% /boot
/dev/mapper/var_VG-var_mirror       8.0G  154M  7.9G   2% /var
/dev/mapper/VolGroup00-LogVol_home   10G   33M   10G   1% /home
tmpfs                               100M     0  100M   0% /run/user/1000

$ sudo pvs
  PV         VG         Fmt  Attr PSize   PFree  
  /dev/sda3  VolGroup00 lvm2 a--  <38.97g <11.47g
  /dev/sdb   var_VG     lvm2 a--  <10.00g   1.99g
  /dev/sdc   var_VG     lvm2 a--  <10.00g   1.99g

$ sudo lvs
  LV          VG         Attr       LSize  Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  LogVol00    VolGroup00 -wi-ao----  8.00g                                                    
  LogVol01    VolGroup00 -wi-ao----  1.50g                                                    
  LogVol_home VolGroup00 -wi-ao---- 10.00g                                                    
  LogVol_var  VolGroup00 -wi-a-----  8.00g                                                    
  var_mirror  var_VG     rwi-aor---  8.00g                                    100.00    
```