#!/bin/sh

source sys_debug.sh
source db_all_opt.sh

print_ln $LEVEL_INFO "$0"


# umount /dev/$SYS_BOOT_DEV
# umount /dev/$SYS_ISO_DEV
# umount /$MOUNT_DIR/xos -l

# parted /dev/$SYS_DEST_OS_DRIVE rm 1
# parted /dev/$SYS_DEST_OS_DRIVE rm 2
# parted /dev/$SYS_DEST_OS_DRIVE rm 3
# mkfs.vfat -F 32 -I /dev/$SYS_DEST_OS_DRIVE

# rm -rf /dev/$SYS_BOOT_DEV
# rm -rf /dev/$SYS_ISO_DEV

# echo SYS_EXPECT_MOPS_PARTITION_SH_FILE=$SYS_EXPECT_MOPS_PARTITION_SH_FILE
# sh $SYS_EXPECT_MOPS_PARTITION_SH_FILE


#@out  1: ISO device index
function user_partition_get_isodev_index()
{
	local dest_drive="null"
	local disk_count=0
	local lvm_count=0
	local isodev_num=0
	
	db_get_partition_count_by_flag "disk" disk_count
	db_get_partition_count_by_flag "lvm" lvm_count
	
	if [ $lvm_count -eq 0 ];then
		lvm_count=0
	else
		lvm_count=1
	fi
	let isodev_num=$disk_count+$lvm_count+1
	
	eval $1=$isodev_num
	
	return $TRUE
}

db_get_sysinfo_dest_drive SYS_DEST_OS_DRIVE

#parted /dev/$SYS_DEST_OS_DRIVE toggle 1 boot
#sgdisk /dev/$SYS_DEST_OS_DRIVE --attributes=1:set:2
#sgdisk /dev/$SYS_DEST_OS_DRIVE --attributes=1:show
sync

MOUNT_DIR="mnt"
db_get_partition_index "bios_grub" boot_grubdev_index
db_get_partition_index "boot" bootdev_index
user_partition_get_isodev_index isodev_index

SYS_BIOS_GRUB_DEV=$SYS_DEST_OS_DRIVE"$boot_grubdev_index"
SYS_BOOT_DEV=$SYS_DEST_OS_DRIVE"$bootdev_index"
SYS_ISO_DEV=$SYS_DEST_OS_DRIVE"$isodev_index"
SYS_KS_FILE=$SYS_KS_FILE
SYS_ISO_FILE=$SYS_ISO_FILE
SYS_EXPECT_KICKOFF_SEGMENT_FILE=$SYS_EXPECT_KICKOFF_SEGMENT_FILE

echo SYS_BIOS_GRUB_DEV=$SYS_DEST_OS_DRIVE"$boot_grubdev_index"
echo SYS_BOOT_DEV=$SYS_DEST_OS_DRIVE"$bootdev_index"
echo SYS_ISO_DEV=$SYS_DEST_OS_DRIVE"$isodev_index"
echo SYS_KS_FILE=$SYS_KS_FILE
echo SYS_ISO_FILE=$SYS_ISO_FILE
echo SYS_EXPECT_KICKOFF_SEGMENT_FILE=$SYS_EXPECT_KICKOFF_SEGMENT_FILE

if [ $boot_grubdev_index -ne 0 ];then
	parted /dev/$SYS_DEST_OS_DRIVE -s set $boot_grubdev_index bios_grub on 
fi
parted /dev/$SYS_DEST_OS_DRIVE -s set $bootdev_index legacy_boot on 
parted /dev/$SYS_DEST_OS_DRIVE p

sed -i "s/bootdev/$SYS_BOOT_DEV/g" $SYS_CONF_DIR/syslinux.cfg

umount /dev/$SYS_BOOT_DEV -l
umount /dev/$SYS_ISO_DEV -l
umount /$MOUNT_DIR/xos -l

mkfs.vfat -F 32 /dev/$SYS_BOOT_DEV
#mkfs.ext4 /dev/$SYS_ISO_DEV

mkdir -p /$MOUNT_DIR/xos /$MOUNT_DIR/$SYS_BOOT_DEV /$MOUNT_DIR/$SYS_ISO_DEV

print_ln $LEVEL_INFO "Mount"
mount -t iso9660 -o loop $SYS_ISO_FILE /$MOUNT_DIR/xos
mount -t vfat /dev/$SYS_BOOT_DEV /$MOUNT_DIR/$SYS_BOOT_DEV/
mount /dev/$SYS_ISO_DEV /$MOUNT_DIR/$SYS_ISO_DEV

print_ln $LEVEL_INFO "Copy 1"
cp -a /$MOUNT_DIR/xos/isolinux /$MOUNT_DIR/$SYS_BOOT_DEV/syslinux
mv /$MOUNT_DIR/$SYS_BOOT_DEV/syslinux/isolinux.bin /$MOUNT_DIR/$SYS_BOOT_DEV/syslinux/syslinux.bin
mv /$MOUNT_DIR/$SYS_BOOT_DEV/syslinux/isolinux.cfg /$MOUNT_DIR/$SYS_BOOT_DEV/syslinux/syslinux.cfg
cp $SYS_CONF_DIR/syslinux.cfg /$MOUNT_DIR/$SYS_BOOT_DEV/syslinux/syslinux.cfg

print_ln $LEVEL_INFO "Copy 2"
cp -a $SYS_KS_FILE /$MOUNT_DIR/$SYS_BOOT_DEV
cp -a /$MOUNT_DIR/xos/images /$MOUNT_DIR/$SYS_ISO_DEV/
umount /$MOUNT_DIR/xos -l
cp -a $SYS_ISO_FILE /$MOUNT_DIR/$SYS_ISO_DEV/
#cp -a $SYS_EXPECT_KICKOFF_SEGMENT_FILE /$MOUNT_DIR/$SYS_ISO_DEV/rc.local

print_ln $LEVEL_INFO "Syslinux"
#dd bs=440 conv=notrunc count=1 if=/usr/share/syslinux/mbr.bin of=/dev/$SYS_DEST_OS_DRIVE
dd bs=440 conv=notrunc count=1 if=/usr/share/syslinux/gptmbr.bin of=/dev/$SYS_DEST_OS_DRIVE
partprobe
cd /$MOUNT_DIR/$SYS_BOOT_DEV
syslinux -d syslinux/ /dev/$SYS_BOOT_DEV

print_ln $LEVEL_INFO "Boot dev info:"
ls -Rl /$MOUNT_DIR/$SYS_BOOT_DEV/

print_ln $LEVEL_INFO "ISO dev info:"
ls -Rl /$MOUNT_DIR/$SYS_ISO_DEV

exit $TRUE