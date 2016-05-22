#!/bin/sh

source db_all_opt.sh

#@in  1: Partition name
#@in  2: Partition size
#@in  3: Partition location
#@in  4: Partition filesystem
function user_partition_set_db_info()
{
	local name=$1
	local size="$2"
	local loca="$3"
	local fs_type="$4"
	local mount_point="null"
	
	db_get_partition_mount_point $name mount_point
	#echo $FUNCNAME--$name,$size,$loca,$fs_type,$mount_point
	db_set_partition_full_info $name $size $loca $fs_type $mount_point
	
	return $TRUE
}

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