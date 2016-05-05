#!/bin/sh

source sys_debug.sh
source sys_file.sh
source sys_string.sh
source user_partition_ks_converter.sh


#@out 1: Output ks-post partition code
function get_nolvm_partition_resizing_code()
{	
	delete_partition_index1=$PT_MOPS_PARTITION_NUM
	let delete_partition_index2=$PT_MOPS_PARTITION_NUM-1
	
	dest_drive=$PT_DEST_OS_DRIVE
	ouput_ks_post_file=$1
	
	#Step 1:
	second_last_end_size="null"
	get_disk_partition_end_size "$dest_drive" "$delete_partition_index2" second_last_end_size
	
	print_ln $LEVEL_INFO "partition_index=$delete_partition_index2,second_last_end_size=$second_last_end_size"	
	
	#Setp 2：	
	string="parted /dev/$dest_drive rm $delete_partition_index1"
	dbg_wr2file_ln $LEVEL_INFO "$string" $ouput_ks_post_file
	
	string="parted /dev/$dest_drive rm $delete_partition_index2"
	dbg_wr2file_ln $LEVEL_INFO "$string" $ouput_ks_post_file
	
	#Setp 3:
	string="parted -a opt /dev/$dest_drive -s mkpart primary $second_last_end_size 100%"
	dbg_wr2file_ln $LEVEL_INFO "$string" $ouput_ks_post_file
	
	resize_device=$dest_drive$delete_partition_index2
	string="/sbin/e2fsck -p -f /dev/$resize_device"
	dbg_wr2file_ln $LEVEL_INFO "$string" $ouput_ks_post_file
	
	string="/sbin/resize2fs /dev/$resize_device"
	dbg_wr2file_ln $LEVEL_INFO "$string" $ouput_ks_post_file
	
	return $TRUE
}

#@out 1: Output ks-post partition code
#@out 2: Output rc.local kickoff code
function get_lvm_partition_resizing_code()
{
	dest_drive=$PT_DEST_OS_DRIVE	
	ouput_ks_post_file=$1
	ouput_kickoff_file=$2
	
	delete_partition_index1=$PT_MOPS_PARTITION_NUM
	let delete_partition_index2=$PT_MOPS_PARTITION_NUM-1
	
	pv_size="null"
	pv_unit="null"
	new_pv_size="null"
	new_pv_unit="null"
	second_last_end_size="null"
	
	get_disk_partition_end_size "$dest_drive" "$delete_partition_index2" second_last_end_size
	print_ln $LEVEL_INFO "partition_index=$delete_partition_index2,second_last_end_size=$second_last_end_size"	
	
	get_pv_size "$dest_drive$delete_partition_index2" pv_size pv_unit
	print_ln $LEVEL_INFO "pv:$dest_drive$delete_partition_index2,pv_size=$pv_size,pv_unit=$pv_unit"
	
	get_disk_pv_capability "$dest_drive$delete_partition_index1" new_pv_size new_pv_unit
	print_ln $LEVEL_INFO "pv:$dest_drive$delete_partition_index1,new_pv_size=$new_pv_size,new_pv_unit=$new_pv_unit"
	
	#Setp 2：	
	string="parted /dev/$dest_drive rm $delete_partition_index1"
	dbg_wr2file_ln $LEVEL_INFO "$string" $ouput_ks_post_file					
	
	string="parted /dev/$dest_drive rm $delete_partition_index2"
	dbg_wr2file_ln $LEVEL_INFO "$string" $ouput_ks_post_file	
	
	#Setp 3:
	string="parted -a opt /dev/$dest_drive -s mkpart primary $second_last_end_size 100%"
	dbg_wr2file_ln $LEVEL_INFO "$string" $ouput_ks_post_file	
	
	string="parted /dev/$dest_drive set $delete_partition_index2 LVM on"
	dbg_wr2file_ln $LEVEL_INFO "$string" $ouput_ks_post_file	
	
	#set -x
	#Setp 4:
	resize_device=$dest_drive$delete_partition_index2
	if [ "$pv_unit" = "$new_pv_unit" ];then
		let total_size=$pv_size+$new_pv_size
		total_unit="G"
		if [ "$pv_unit" = "MiB" ];then
			total_unit="M"
		fi
	elif [ "$pv_unit" = "GiB" ];then
		let total_size=$pv_size*1000+$new_pv_size
		total_unit="M"
	elif [ "$pv_unit" = "MiB" ];then
		let total_size=$pv_size+$new_pv_size*1000
		total_unit="M"
	fi
	total_physize=$total_size$total_unit
	#set +x
	
	string="pvresize --setphysicalvolumesize $total_physize /dev/$resize_device"
	dbg_wr2file_ln $LEVEL_INFO "$string" $ouput_ks_post_file	
	
	
	lvm_full_resize_device="/dev/$PT_VG_NAME/lv_$PT_MAX_PARTITION_NAME"
	
	string="lvresize -rl +100%FREE $lvm_full_resize_device"
	dbg_wr2file_ln $LEVEL_INFO "$string" $ouput_ks_post_file	
	
	string="dmsetup resume $lvm_full_resize_device"
	dbg_wr2file_ln $LEVEL_INFO "$string" $ouput_ks_post_file	

	###
	string="mv /mnt/sysimage/etc/rc.d/rc.local /mnt/sysimage/etc/rc.d/rc.local.back"
	dbg_wr2file_ln $LEVEL_INFO "$string" $ouput_ks_post_file	
	
	string="cp -rf $PT_KS_PRELOAD_DIR/rc.local /mnt/sysimage/etc/rc.d/"
	dbg_wr2file_ln $LEVEL_INFO "$string" $ouput_ks_post_file
	
	###
	string="umount $lvm_full_resize_device -l >> /root/resize.log"
	dbg_wr2file_ln $LEVEL_INFO "$string" $ouput_kickoff_file
	
	string="/sbin/e2fsck -p -f $lvm_full_resize_device  >> /root/resize.log"
	dbg_wr2file_ln $LEVEL_INFO "$string" $ouput_kickoff_file
	
	string="/sbin/resize2fs $lvm_full_resize_device  >> /root/resize.log"
	dbg_wr2file_ln $LEVEL_INFO "$string" $ouput_kickoff_file
	
	mount_point="null"
	get_partition_mount_point_by_name $PT_MAX_PARTITION_NAME mount_point

	string="mount $lvm_full_resize_device $mount_point >> /root/resize.log"
	dbg_wr2file_ln $LEVEL_INFO "$string" $ouput_kickoff_file
	
	string="mv /etc/rc.d/rc.local /root/rc.local.todel"
	dbg_wr2file_ln $LEVEL_INFO "$string" $ouput_kickoff_file
	
	string="mv /etc/rc.d/rc.local.back /etc/rc.d/rc.local"
	dbg_wr2file_ln $LEVEL_INFO "$string" $ouput_kickoff_file

	return $TRUE
}

#@out 1: Output ks-post file
#@out 2: Output kickoff file
#return: true(1)/false(0)
function do_partition_action_ks_post()
{
	if [ "$PT_MAX_PARTITION_LOCA" = "lvm" ]; then	
		get_lvm_partition_resizing_code $1 $2
	else
		get_nolvm_partition_resizing_code $1 $2
	fi

	return $TRUE
}

do_partition_action_ks_post $1 $2
source assert_int $? $TRUE

