# Working with boot

### Task:
- Get to system without password
- On the system installed on LVM rename Volume Group
- Add module to initrd
- \*Additional - configure system without separated /boot, only with LVM
  * Patched grub at: https://yum.rumyantsev.com/centos/7/x86_64/
  * PV must be inited with `--bootloaderareasize 1m`

### Description:

#### How to login without a password:
##### Simple way
1. Start the system and, on the GRUB 2 boot screen, press the `e` key for edit.
2. Remove the `rhgb` and `quiet` parameters from the end, or near the end, of the `linux16` line, or `linuxefi` on UEFI systems.
It will look like:
```bash
linux16 /vmlinuz<version> root=<lvm_path> rw single init=/bin/bash 
linux16 /vmlinuz<version> root=<lvm_path> rw single init=/bin/sh
```
3. Press `ctrl` + `x` to boot the system wuth the changed parameters. 
4. Try to change passwords
```bash
passwd username
```


##### Selinux way

1. Start the system and, on the GRUB 2 boot screen, press the `e` key for edit.
2. Remove the `rhgb` and `quiet` parameters from the end, or near the end, of the `linux16` line, or `linuxefi` on UEFI systems.
Add the following parameters at the end of the `linux` line on 64-Bit IBM Power Series, 
the `linux16` line on x86-64 BIOS-based systems, or the `linuxefi` line on UEFI systems:
```bash
rd.break enforcing=0
```
It will look like:
```bash
linux16 /vmlinuz<version> root=<lvm_path> ro rd.break enforcing=0
```
3. Add the following parameters at the end of the `linux` line on 64-Bit IBM Power Series, 
the `linux16` line on x86-64 BIOS-based systems, or the `linuxefi` line on UEFI systems:
```bash
rd.break enforcing=0
```

Adding the `enforcing=0` option enables omitting the time consuming SELinux relabeling process.

The `initramfs` will stop before passing control to the Linux kernel, 
enabling you to work with the `root` file system.
Note that the `initramfs` prompt will appear on the last console specified on the Linux line.

3. Press `ctrl` + `x` to boot the system wuth the changed parameters. 
With an encrypted file system, a password is required at this point. 
However the password prompt might not appear as it is obscured by logging messages. 
You can press the `Backspace` key to see the prompt. 
Release the key and enter the password for the encrypted file system, while ignoring the logging messages.

The `initramfs` `switch_root` prompt appears.

4. The file system is mounted read-only on /sysroot/. You will not be allowed to change the password if the file system is not writable.

Remount the file system as writable:
```bash
switch_root:/# mount -o remount,rw /sysroot
```
5. The file system is remounted with write enabled.

Change the file system's `root` as follows:
```bash
switch_root:/# chroot /sysroot
```
The prompt changes to `sh-4.2#.`
6. Now chage the password! Enter the passwd command and follow the instructions displayed on the command line to change the root password.
7. The most important step: 
Updating the password file results in a file with the incorrect SELinux security context. 
To relabel all files on next system boot, enter the following command:
```bash
sh-4.2# touch /.autorelabel
```
8. Remount the file system as read only:
```bash
sh-4.2# mount -o remount,ro /
```
9. Exit twice
10. Now on login use your new password.

From: https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/system_administrators_guide/sec-terminal_menu_editing_during_boot#sec-Changing_and_Resetting_the_Root_Password

## How to:

```
$ vagrant up
$ vagrant halt
$ vm_id=$(vboxmanage list vms | grep 01-04 | awk '{print $2}' | tr -d [{}])
$ vboxmanage startvm $vm_id

# yum will see the picture at vbox window

```