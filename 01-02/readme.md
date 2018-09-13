# Working with mdadm

### Task:
- add disks to VagrantFile
- broke and restore raid
- create R0/R5/R10
- configure raid the way that it's work on boot
- create GPT volume with 5 partitions
- \*Additional - Vagrantfile with raid system at startup

### Description:

##### How to:

```
$ vagrant up
# hope as simple as that

# After vm started try:
$ vagrant ssh
$ df -h

# Output must be like:
#
# Filesystem                       Size  Used Avail Use% Mounted on
# /dev/mapper/VolGroup00-LogVol00   38G  2.0G   36G   6% /
# devtmpfs                         487M     0  487M   0% /dev
# tmpfs                            496M     0  496M   0% /dev/shm
# tmpfs                            496M  6.8M  490M   2% /run
# tmpfs                            496M     0  496M   0% /sys/fs/cgroup
# /dev/sda2                       1014M   63M  952M   7% /boot
# /dev/md0p2                       185M  1.6M  170M   1% /otus2
# /dev/md0p4                       186M  1.6M  170M   1% /otus4
# /dev/md0p1                       185M  1.6M  170M   1% /otus1
# /dev/md0p3                       185M  1.6M  170M   1% /otus3
# /dev/md0p5                       185M  1.6M  170M   1% /otus5
# tmpfs                            100M     0  100M   0% /run/user/1000

```