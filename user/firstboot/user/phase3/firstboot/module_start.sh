#!/bin/sh

source sys_debug.sh
source sys_file.sh
source db_all_opt.sh

print_ln $LEVEL_INFO "$0"


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


export PT_KICKOFF_SEGMENT_FILE="$SYS_EXPECT_KICKOFF_SEGMENT_FILE"

print_ln $LEVEL_INFO "PT_KICKOFF_SEGMENT_FILE=$PT_KICKOFF_SEGMENT_FILE"
print_ln $LEVEL_INFO "SYS_KS_FILE=$SYS_KS_FILE"

#Check file existence
file=$PT_KICKOFF_SEGMENT_FILE
is_file_exist  $file result
source assert_int_ex $TRUE $result $file

#Check file existence
file=$SYS_KS_FILE
is_file_exist  $file result
source assert_int_ex $TRUE $result $file



db_get_sysinfo_dest_drive SYS_DEST_OS_DRIVE

MOUNT_DIR="mnt"
# db_get_partition_index "bios_grub" boot_grubdev_index
# db_get_partition_index "boot" bootdev_index
user_partition_get_isodev_index isodev_index

# SYS_BIOS_GRUB_DEV=$SYS_DEST_OS_DRIVE"$boot_grubdev_index"
# SYS_BOOT_DEV=$SYS_DEST_OS_DRIVE"$bootdev_index"
SYS_ISO_DEV=$SYS_DEST_OS_DRIVE"$isodev_index"
# SYS_KS_FILE=$SYS_KS_FILE
# SYS_ISO_FILE=$SYS_ISO_FILE
# SYS_EXPECT_KICKOFF_SEGMENT_FILE=$SYS_EXPECT_KICKOFF_SEGMENT_FILE

# echo SYS_BIOS_GRUB_DEV=$SYS_DEST_OS_DRIVE"$boot_grubdev_index"
# echo SYS_BOOT_DEV=$SYS_DEST_OS_DRIVE"$bootdev_index"
# echo SYS_ISO_DEV=$SYS_DEST_OS_DRIVE"$isodev_index"
# echo SYS_KS_FILE=$SYS_KS_FILE
# echo SYS_ISO_FILE=$SYS_ISO_FILE
# echo SYS_EXPECT_KICKOFF_SEGMENT_FILE=$SYS_EXPECT_KICKOFF_SEGMENT_FILE

print_ln $LEVEL_INFO "SYS_ISO_DEV=$SYS_ISO_DEV"

umount -l /dev/$SYS_ISO_DEV
umount -l /$MOUNT_DIR/isodev
mkdir /$MOUNT_DIR/isodev
mount /dev/$SYS_ISO_DEV /$MOUNT_DIR/isodev
mkdir /$MOUNT_DIR/isodev/firstboot
cp $PT_KICKOFF_SEGMENT_FILE /$MOUNT_DIR/isodev/firstboot/firstboot.sh

echo "sh /root/firstboot/firstboot.sh >> /root/firstboot.log 2>&1 &" >> /$MOUNT_DIR/isodev/firstboot/rc.local
echo "mv /root/firstboot/rc.local.back /etc/rc.d/rc.local >> /root/firstboot.log"  >> /$MOUNT_DIR/isodev/firstboot/rc.local


#PRE
echo "mkdir /$MOUNT_DIR/isodev" >> firstboot-ks-segment.pre
echo "mount /dev/$SYS_ISO_DEV /$MOUNT_DIR/isodev" >> firstboot-ks-segment.pre
echo "cp -a /$MOUNT_DIR/isodev/firstboot /$MOUNT_DIR" >> firstboot-ks-segment.pre
echo "umount /dev/$SYS_ISO_DEV -l" >> firstboot-ks-segment.pre

sh ks_add_pre.sh firstboot-ks-segment.pre $SYS_KS_FILE
source assert_int_ex $? $TRUE "Bootable set pre"

#POST
echo "cp -a /$MOUNT_DIR/firstboot /mnt/sysimage/root/" >> firstboot-ks-segment.post
echo "mv /mnt/sysimage/etc/rc.d/rc.local /mnt/sysimage/root/firstboot/rc.local.back" >> firstboot-ks-segment.post
echo "cp /mnt/sysimage/root/firstboot/rc.local /mnt/sysimage/etc/rc.d/" >> firstboot-ks-segment.post
echo "chmod 777 /mnt/sysimage/etc/rc.d/rc.local" >> firstboot-ks-segment.post

sh ks_add_post.sh firstboot-ks-segment.post $SYS_KS_FILE
source assert_int_ex $? $TRUE "Bootable set post"

exit $TRUE