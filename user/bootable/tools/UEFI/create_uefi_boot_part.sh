#!/bin/sh

#PREREQUISITE
#  1. linux.iso
#  2. uefi_ks.cfg
#  3. BOOTX64.conf

umount -l /dev/sda*

mkfs.ext4 /dev/sda

parted /dev/sda -s mklabel gpt
parted /dev/sda -s mkpart primary 0 500M
parted /dev/sda -s mkpart primary 1G 6G

mkfs.vfat -F 32 /dev/sda1
mkfs.ext4 /dev/sda2

mkdir -p /mnt/sda1 /mnt/sda2
mount /dev/sda1 /mnt/sda1
mount /dev/sda2 /mnt/sda2 

mkdir -p /mnt/iso
mount -t iso9660 -o loop linux.iso /mnt/iso
cp -a /mnt/iso/EFI /mnt/sda1/
cp    uefi_ks.cfg  /mnt/sda1/
cp    BOOTX64.conf  /mnt/sda1/EFI/BOOT/
cp -a /mnt/iso/images /mnt/sda1/
cp -a /mnt/iso/images /mnt/sda2/
umount -l /mnt/iso
cp linux.iso /mnt/sda2

