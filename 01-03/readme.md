# Working with LVM

### Task:
- на имеющемся образе 
/dev/mapper/VolGroup00-LogVol00 38G 738M 37G 2% /

- уменьшить том под / до 8G
- выделить том под /home
- выделить том под /var
- /var - сделать в mirror
- /home - сделать том для снэпшотов
- прописать монтирование в fstab
- попробовать с разными опциями и разными файловыми системами ( на выбор)
- сгенерить файлы в /home/
- снять снэпшот
- удалить часть файлов
- восстановится со снэпшота
- залоггировать работу можно с помощью утилиты script

* на нашей куче дисков попробовать поставить btrfs/zfs - с кешем, снэпшотами - разметить здесь каталог /opt

### Description:

##### How to:

```
$ bash exercise-course.sh
# hope as simple as that

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