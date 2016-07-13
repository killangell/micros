#!/bin/sh

source sys_debug.sh
source sys_file.sh
source sys_string.sh
source user_partition_ks_converter.sh
source user_partition_ks_segments_parser.sh
source user_partition_db_opt.sh

#@out 1: Output ks-post partition code
function get_nolvm_partition_resizing_code()
{	
	delete_partition_index1=$PT_MOPS_PARTITION_NUM
	let delete_partition_index2=$PT_MOPS_PARTITION_NUM-1
	let partition_index3=$isodev_index-2
	
	dest_drive=$PT_DEST_OS_DRIVE
	ouput_ks_post_file=$1
	
	#Step 1:
	third_last_end_size="null"
	get_disk_partition_end_size "$dest_drive" "$partition_index3" third_last_end_size
	
	print_ln $LEVEL_INFO "partition_index=$delete_partition_index2,third_last_end_size=$third_last_end_size"	
	
	#Setp 2£º
	isodev=$dest_drive$delete_partition_index1
	
	string="umount /dev/$isodev -l"
	dbg_wr2file_ln $LEVEL_INFO "$string" $ouput_ks_post_file
	
	string="mkfs.ext4 /dev/$isodev"
	dbg_wr2file_ln $LEVEL_INFO "$string" $ouput_ks_post_file

	string="parted /dev/$dest_drive -s rm $delete_partition_index1"
	dbg_wr2file_ln $LEVEL_INFO "$string" $ouput_ks_post_file
	
	string="parted /dev/$dest_drive -s rm $delete_partition_index2"
	dbg_wr2file_ln $LEVEL_INFO "$string" $ouput_ks_post_file
	
	#Setp 3:
	string="parted -a opt /dev/$dest_drive -s mkpart primary $third_last_end_size 100%"
	dbg_wr2file_ln $LEVEL_INFO "$string" $ouput_ks_post_file
	
	resize_device=$dest_drive$delete_partition_index2
	string="/sbin/e2fsck -p -f /dev/$resize_device"
	dbg_wr2file_ln $LEVEL_INFO "$string" $ouput_ks_post_file
	
	string="/sbin/resize2fs /dev/$resize_device"
	dbg_wr2file_ln $LEVEL_INFO "$string" $ouput_ks_post_file
	
	return $TRUE
}

#@out 1: Output ks-post partition code
#@out 2: Output kickoff code
function get_lvm_partition_resizing_code()
{
	local dest_drive="null"
	local isodev_index=0
	local ouput_ks_post_file=$1
	local ouput_kickoff_file=$2
	local max_pt_name="null"
	local max_pt_size="null"
	local max_pt_loca="null"
	local max_pt_fs_type="null"
	local max_pt_mount_point="null"
	local max_pt_resv2="null"
	
	print_ln $LEVEL_INFO "$FUNCNAME"
	
	db_get_sysinfo_dest_drive dest_drive
	user_partition_get_isodev_index isodev_index
	print_ln $LEVEL_INFO "dest_drive:$dest_drive,isodev_index:$isodev_index"
	
	db_get_max_partition_full_info max_pt_name max_pt_size max_pt_loca max_pt_fs_type max_pt_mount_point max_pt_resv2
	print_ln $LEVEL_INFO "max partition:$max_pt_name,$max_pt_size,$max_pt_loca,$max_pt_fs_type,$max_pt_mount_point,$max_pt_resv2"
	
	local delete_partition_index1=$isodev_index
	let delete_partition_index2=$isodev_index-1
	let partition_index3=$isodev_index-2
	local third_last_end_size="null"
	
	get_disk_partition_end_size "$dest_drive" "$partition_index3" third_last_end_size
	print_ln $LEVEL_INFO "partition_index=$delete_partition_index2,third_last_end_size=$third_last_end_size"	

	#Setp 2
	isodev=$dest_drive$isodev_index
	
	string="umount /dev/$isodev -l"
	dbg_wr2file_ln_ex $LEVEL_INFO "ks-post" "$string" $ouput_ks_post_file
	
	string="mkfs.ext4 /dev/$isodev"
	dbg_wr2file_ln_ex $LEVEL_INFO "ks-post" "$string" $ouput_ks_post_file

	string="parted /dev/$dest_drive -s rm $delete_partition_index1"
	dbg_wr2file_ln_ex $LEVEL_INFO "ks-post" "$string" $ouput_ks_post_file				
	
	string="parted /dev/$dest_drive -s rm $delete_partition_index2"
	dbg_wr2file_ln_ex $LEVEL_INFO "ks-post" "$string" $ouput_ks_post_file
	
	#Setp 3:
	string="parted -a opt /dev/$dest_drive -s mkpart primary $third_last_end_size 100%"
	dbg_wr2file_ln_ex $LEVEL_INFO "ks-post" "$string" $ouput_ks_post_file
	
	string="parted /dev/$dest_drive -s set $delete_partition_index2 LVM on"
	dbg_wr2file_ln_ex $LEVEL_INFO "ks-post" "$string" $ouput_ks_post_file
	
	
	string="echo $0 start"
	dbg_wr2file_ln_ex $LEVEL_INFO "ks-firstboot" "$string" $ouput_kickoff_file
	
	string="df -lh"
	dbg_wr2file_ln_ex $LEVEL_INFO "ks-firstboot" "$string" $ouput_kickoff_file
		
	string="echo pvresize"
	dbg_wr2file_ln_ex $LEVEL_INFO "ks-firstboot" "$string" $ouput_kickoff_file
	
	resize_device=$dest_drive$delete_partition_index2
	string="pvresize /dev/$resize_device"
	dbg_wr2file_ln_ex $LEVEL_INFO "ks-firstboot" "$string" $ouput_kickoff_file
	
	lvm_full_resize_device="/dev/$PT_VG_NAME/lv_$max_pt_name"	
	
	string="echo umount"
	dbg_wr2file_ln_ex $LEVEL_INFO "ks-firstboot" "$string" $ouput_kickoff_file
	
	string="umount -l $lvm_full_resize_device"
	dbg_wr2file_ln_ex $LEVEL_INFO "ks-firstboot" "$string" $ouput_kickoff_file	
	
	string="echo lvresize"
	dbg_wr2file_ln_ex $LEVEL_INFO "ks-firstboot" "$string" $ouput_kickoff_file
	
	string="lvresize -rl +100%FREE $lvm_full_resize_device"
	dbg_wr2file_ln_ex $LEVEL_INFO "ks-firstboot" "$string" $ouput_kickoff_file
	
	string="echo mkfs.$fs_type"
	dbg_wr2file_ln_ex $LEVEL_INFO "ks-firstboot" "$string" $ouput_kickoff_file
	
	string="mkfs.$fs_type $lvm_full_resize_device"
	dbg_wr2file_ln_ex $LEVEL_INFO "ks-firstboot" "$string" $ouput_kickoff_file
	
	string="echo mount"
	dbg_wr2file_ln_ex $LEVEL_INFO "ks-firstboot" "$string" $ouput_kickoff_file
	
	string="mount $lvm_full_resize_device $max_pt_mount_point"
	dbg_wr2file_ln_ex $LEVEL_INFO "ks-firstboot" "$string" $ouput_kickoff_file
	
	string="df -lh"
	dbg_wr2file_ln_ex $LEVEL_INFO "ks-firstboot" "$string" $ouput_kickoff_file
	
	string="echo $0 stop"
	dbg_wr2file_ln_ex $LEVEL_INFO "ks-firstboot" "$string" $ouput_kickoff_file
	
	return $TRUE
}

#@out 1: Output ks-post file
#@out 2: Output kickoff file
#return: true(1)/false(0)
function do_partition_action_ks_post()
{
	local name="null"
	local size="null"
	local loca="null"
	local fs_type="null"
	local mount_point="null"
	local resv2="null"
	
	db_get_max_partition_full_info name size loca fs_type mount_point resv2
	print_ln $LEVEL_INFO "max partition:$name,$size,$loca,$fs_type,$mount_point,$resv2"
	
	if [ "$loca" = "lvm" ]; then	
		get_lvm_partition_resizing_code $1 $2
	else
		get_nolvm_partition_resizing_code $1 $2
	fi

	return $TRUE
}

do_partition_action_ks_post $1 $2
source assert_int $? $TRUE

