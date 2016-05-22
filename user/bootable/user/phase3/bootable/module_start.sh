#!/bin/sh

source sys_debug.sh

print_ln $LEVEL_INFO "$0"

umount /dev/$SYS_BOOT_DEV
umount /dev/$SYS_ISO_DEV
umount /mnt/xos -l

parted /dev/$SYS_DEST_OS_DRIVE rm 1
parted /dev/$SYS_DEST_OS_DRIVE rm 2
parted /dev/$SYS_DEST_OS_DRIVE rm 3
mkfs.vfat -F 32 -I /dev/$SYS_DEST_OS_DRIVE

rm -rf /dev/$SYS_BOOT_DEV
rm -rf /dev/$SYS_ISO_DEV

echo SYS_EXPECT_MOPS_PARTITION_SH_FILE=$SYS_EXPECT_MOPS_PARTITION_SH_FILE
sh $SYS_EXPECT_MOPS_PARTITION_SH_FILE
parted /dev/$SYS_DEST_OS_DRIVE toggle 1 boot
sync

echo SYS_DEST_OS_DRIVE=$SYS_DEST_OS_DRIVE
echo SYS_BOOT_DEV=$SYS_BOOT_DEV
echo SYS_ISO_DEV=$SYS_ISO_DEV
echo SYS_KS_FILE=$SYS_KS_FILE
echo SYS_ISO_FILE=$SYS_ISO_FILE
echo SYS_EXPECT_KICKOFF_SEGMENT_FILE=$SYS_EXPECT_KICKOFF_SEGMENT_FILE

mkfs.vfat -F 32 /dev/$SYS_BOOT_DEV
mkfs.ext4 /dev/$SYS_ISO_DEV

mkdir -p /mnt/xos /mnt/$SYS_BOOT_DEV /mnt/$SYS_ISO_DEV

mount -t iso9660 -o loop $SYS_ISO_FILE /mnt/xos
mount -t vfat /dev/$SYS_BOOT_DEV /mnt/$SYS_BOOT_DEV/
mount /dev/$SYS_ISO_DEV /mnt/$SYS_ISO_DEV

cp -a /mnt/xos/isolinux /mnt/$SYS_BOOT_DEV/syslinux
mv /mnt/$SYS_BOOT_DEV/syslinux/isolinux.bin /mnt/$SYS_BOOT_DEV/syslinux/syslinux.bin
mv /mnt/$SYS_BOOT_DEV/syslinux/isolinux.cfg /mnt/$SYS_BOOT_DEV/syslinux/syslinux.cfg
cp $SYS_CONF_DIR/syslinux.cfg /mnt/$SYS_BOOT_DEV/syslinux/syslinux.cfg

cp -a $SYS_KS_FILE /mnt/$SYS_BOOT_DEV
cp -a /mnt/xos/images /mnt/$SYS_ISO_DEV/
umount /mnt/xos -l
cp -a $SYS_ISO_FILE /mnt/$SYS_ISO_DEV/
cp -a $SYS_EXPECT_KICKOFF_SEGMENT_FILE /mnt/$SYS_ISO_DEV/rc.local

dd bs=440 conv=notrunc count=1 if=/usr/share/syslinux/mbr.bin of=/dev/$SYS_DEST_OS_DRIVE
#dd bs=440 conv=notrunc count=1 if=/usr/share/syslinux/gptmbr.bin of=/dev/$SYS_DEST_OS_DRIVE
partprobe
cd /mnt/$SYS_BOOT_DEV
syslinux -d syslinux/ /dev/$SYS_BOOT_DEV

exit $TRUE