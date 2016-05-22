#!/bin/sh

source sys_partition.sh

#@in  1: Partition name
#@Out 2: Partition index
function db_get_partition_index()
{
	local db_partition_file=$PARTITION_DB_FILE
	local name=$1
	index="null"

	get_partition_index_by_name $db_partition_file $name index
	eval $2=$index

	return $TRUE
}

#@in  1: Partition name
function db_remove_partition()
{
	db_partition_file=$PARTITION_DB_FILE
	name=$1

	remove_partition_by_name $db_partition_file $name

	return $TRUE
}

#@in  1: Partition name
#@Out 2: Partition size
function db_get_partition_size()
{
	db_partition_file=$PARTITION_DB_FILE
	name=$1
	size="null"
	loca="null"
	fs_type="null"
	resv1="null"
	resv2="null"

	get_partition_by_name $db_partition_file $name size loca fs_type resv1 resv2
	eval $2=$size

	return $TRUE
}

#@in  1: Partition name
#@in  2: Partition size
function db_set_partition_size()
{
	db_partition_file=$PARTITION_DB_FILE
	name=$1
	size="null"
	loca="null"
	fs_type="null"
	resv1="null"
	resv2="null"
	
	get_partition_by_name $db_partition_file $name size loca fs_type resv1 resv2
	set_partition_by_name $db_partition_file $name $2 $loca $fs_type $resv1 $resv2
	
	return $TRUE
}

#@in  1: Partition name
#@Out 2: Partition location
function db_get_partition_location()
{
	db_partition_file=$PARTITION_DB_FILE
	name=$1
	size="null"
	loca="null"
	fs_type="null"
	resv1="null"
	resv2="null"

	get_partition_by_name $db_partition_file $name size loca fs_type resv1 resv2
	eval $2=$loca

	return $TRUE
}

#@in  1: Partition name
#@in  2: Partition location
function db_set_partition_location()
{
	db_partition_file=$PARTITION_DB_FILE
	name=$1
	size="null"
	loca="null"
	fs_type="null"
	resv1="null"
	resv2="null"
	
	get_partition_by_name $db_partition_file $name size loca fs_type resv1 resv2
	set_partition_by_name $db_partition_file $name $size $2 $fs_type $resv1 $resv2
	
	return $TRUE
}

#@in  1: Partition name
#@Out 2: Partition filesystem
function db_get_partition_filesystem()
{
	db_partition_file=$PARTITION_DB_FILE
	name=$1
	size="null"
	loca="null"
	fs_type="null"
	resv1="null"
	resv2="null"

	get_partition_by_name $db_partition_file $name size loca fs_type resv1 resv2
	eval $2=$fs_type

	return $TRUE
}

#@in  1: Partition name
#@in  2: Partition filesystem
function db_set_partition_filesystem()
{
	db_partition_file=$PARTITION_DB_FILE
	name=$1
	size="null"
	loca="null"
	fs_type="null"
	resv1="null"
	resv2="null"
	
	get_partition_by_name $db_partition_file $name size loca fs_type resv1 resv2
	set_partition_by_name $db_partition_file $name $size $loca $2 $resv1 $resv2
	
	return $TRUE
}

#@in  1: Partition name
#@Out 2: Partition mount point
function db_get_partition_mount_point()
{
	local db_partition_file=$PARTITION_DB_FILE
	local name=$1
	local size="null"
	local loca="null"
	local fs_type="null"
	mount_point="null"
	local resv2="null"

	get_partition_by_name $db_partition_file $name size loca fs_type mount_point resv2
	eval $2=$mount_point

	return $TRUE
}

#@in  1: Partition name
#@in  2: Partition mount point
function db_set_partition_mount_point()
{
	db_partition_file=$PARTITION_DB_FILE
	name=$1
	size="null"
	loca="null"
	fs_type="null"
	mount_point="null"
	resv2="null"
	
	get_partition_by_name $db_partition_file $name size loca fs_type mount_point resv2
	set_partition_by_name $db_partition_file $name $size $loca $fs_type $2 $resv2
	
	return $TRUE
}

#@in  1: Partition name
#@Out 2: Partition size
#@Out 3: Partition location
#@Out 4: Partition filesystem
#@Out 5: Partition mount point
function db_get_partition_full_info()
{
	db_partition_file=$PARTITION_DB_FILE
	name=$1
	size="null"
	loca="null"
	fs_type="null"
	mount_point="null"
	resv2="null"

	get_partition_by_name $db_partition_file $name size loca fs_type mount_point resv2
	eval $2=$size
	eval $3=$loca
	eval $4=$fs_type
	eval $5=$mount_point

	return $TRUE
}

#@in  1: Partition name
#@in  2: Partition size
#@in  3: Partition location
#@in  4: Partition filesystem
#@in  5: Partition mount point
function db_set_partition_full_info()
{
	db_partition_file=$PARTITION_DB_FILE
	name=$1
	size="$2"
	loca="$3"
	fs_type="$4"
	mount_point="$5"
	resv2="resv2"
	
	set_partition_by_name $db_partition_file $name $size $loca $fs_type $mount_point $resv2
	
	return $TRUE
}

#@in  1: Flag
#@out 2: Count
function db_get_partition_count_by_flag()
{
	local db_partition_file=$PARTITION_DB_FILE
	local flag=$1
	
	get_partition_count_by_flag $db_partition_file $flag count
	
	eval $2=$count
	
	return $TRUE
}

#@out 1: Partition count
function db_get_partition_count()
{
	local db_partition_file=$PARTITION_DB_FILE
	count=0
	
	get_partition_count_base $db_partition_file count
	eval $1=$count
	
	return $TRUE
}

#
function db_strip_partition_file()
{
	local db_partition_file=$PARTITION_DB_FILE
	
	strip_partition_file $db_partition_file
	
	return $TRUE
}

#@out 1: Partition name list
function db_get_partitioin_name_list()
{
	local db_partition_file=$PARTITION_DB_FILE
	name_list="null"
	
	get_partition_name_list $db_partition_file name_list
	eval $1="'$name_list'"
	
	return $TRUE
}
