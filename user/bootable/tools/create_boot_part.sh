umount /dev/sda1 -l
umount /dev/sda2 -l

dhclient eth0

mkfs.vfat -F 32 -I /dev/sda

parted -a opt /dev/sda -s mkpart primary 0 200MB

parted -a opt /dev/sda -s mkpart primary 200MB 6000MB

parted -a opt /dev/sda -s mkpart primary 6000MB 6500MB

parted /dev/sda toggle 1 boot

sync

fdisk -l /dev/sda

mkfs.vfat -F 32 /dev/sda1

mkfs.ext4 /dev/sda2


mkdir -p /mnt/sda1 /mnt/sda2

mount -t vfat /dev/sda1 /mnt/sda1/

mount /dev/sda2 /mnt/sda2

cd /mnt/sda1

scp -r liaoy@192.168.0.1:/home/liaoy/boot_part/boot/* ./

dd bs=440 conv=notrunc count=1 if=/usr/share/syslinux/mbr.bin of=/dev/sda

partprobe

syslinux -d syslinux/ /dev/sda1

cd /mnt/sda2

scp -r liaoy@192.168.0.1:/home/liaoy/boot_part/iso/* ./



