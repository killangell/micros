#!/bin/sh

source sys_debug.sh
source db_all_opt.sh

print_ln $LEVEL_INFO "$0"


# umount /dev/$SYS_BOOT_DEV
# umount /dev/$SYS_ISO_DEV
# umount /mnt/xos -l

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

#@out  1: ISO device
function user_partition_get_isodev()
{
	local dest_drive="null"
	local isodev_index=0
	
	db_get_sysinfo_dest_drive dest_drive
	user_partition_get_isodev_index isodev_index
	isodev="$dest_drive$isodev_index"
	
	eval $1="$isodev"
	
	return $TRUE
}


db_get_sysinfo_dest_drive SYS_DEST_OS_DRIVE
user_partition_get_isodev isodev

parted /dev/$SYS_DEST_OS_DRIVE toggle 1 boot
sync

echo SYS_DEST_OS_DRIVE=$SYS_DEST_OS_DRIVE
echo SYS_BOOT_DEV=$SYS_DEST_OS_DRIVE"1"
echo SYS_ISO_DEV=$isodev
echo SYS_KS_FILE=$SYS_KS_FILE
echo SYS_ISO_FILE=$SYS_ISO_FILE
echo SYS_EXPECT_KICKOFF_SEGMENT_FILE=$SYS_EXPECT_KICKOFF_SEGMENT_FILE

SYS_BOOT_DEV=$SYS_DEST_OS_DRIVE"1"
SYS_ISO_DEV=$isodev

sed -i "s/bootdev/$SYS_BOOT_DEV/g" $SYS_CONF_DIR/syslinux.cfg

umount /dev/$SYS_BOOT_DEV -l
umount /dev/$SYS_ISO_DEV -l
umount /mnt/xos -l

mkfs.vfat -F 32 /dev/$SYS_BOOT_DEV
mkfs.ext4 /dev/$SYS_ISO_DEV

mkdir -p /mnt/xos /mnt/$SYS_BOOT_DEV /mnt/$SYS_ISO_DEV

print_ln $LEVEL_INFO "Mount"
mount -t iso9660 -o loop $SYS_ISO_FILE /mnt/xos
mount -t vfat /dev/$SYS_BOOT_DEV /mnt/$SYS_BOOT_DEV/
mount /dev/$SYS_ISO_DEV /mnt/$SYS_ISO_DEV

print_ln $LEVEL_INFO "Copy 1"
cp -a /mnt/xos/isolinux /mnt/$SYS_BOOT_DEV/syslinux
mv /mnt/$SYS_BOOT_DEV/syslinux/isolinux.bin /mnt/$SYS_BOOT_DEV/syslinux/syslinux.bin
mv /mnt/$SYS_BOOT_DEV/syslinux/isolinux.cfg /mnt/$SYS_BOOT_DEV/syslinux/syslinux.cfg
cp $SYS_CONF_DIR/syslinux.cfg /mnt/$SYS_BOOT_DEV/syslinux/syslinux.cfg

print_ln $LEVEL_INFO "Copy 2"
cp -a $SYS_KS_FILE /mnt/$SYS_BOOT_DEV
cp -a /mnt/xos/images /mnt/$SYS_ISO_DEV/
umount /mnt/xos -l
cp -a $SYS_ISO_FILE /mnt/$SYS_ISO_DEV/
cp -a $SYS_EXPECT_KICKOFF_SEGMENT_FILE /mnt/$SYS_ISO_DEV/rc.local

print_ln $LEVEL_INFO "Syslinux"
dd bs=440 conv=notrunc count=1 if=/usr/share/syslinux/mbr.bin of=/dev/$SYS_DEST_OS_DRIVE
#dd bs=440 conv=notrunc count=1 if=/usr/share/syslinux/gptmbr.bin of=/dev/$SYS_DEST_OS_DRIVE
partprobe
cd /mnt/$SYS_BOOT_DEV
syslinux -d syslinux/ /dev/$SYS_BOOT_DEV

exit $TRUE