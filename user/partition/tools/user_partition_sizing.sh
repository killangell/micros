#!/bin/sh

source sys_debug.sh
source sys_file.sh
source sys_disk.sh
source user_partition_define.sh
source user_partition_conf_parser.sh	

#@in  1: User Partition file
#@out 2: Output file
#return: true(1)/false(0)
function do_partition_sizing()
{
	conf_file=$1
	output_file=$2
	
	print_ln $LEVEL_INFO "Input: $conf_file"
	
	dest_drive="null"
	name="null"
	size="null"
	loca="null"
	fs_type="null"
	
	#Read partition conf and save 
	get_conf_dest_drive $conf_file dest_drive
	print_ln $LEVEL_INFO "dest_drive: $dest_drive"
	set_dest_drive $dest_drive
	
	pt_name_index=1	
	for pt_name_iterator in ${pt_name_arr[*]}  
	do  
		name=${pt_name_iterator}		
		get_conf_partition_info_by_name $conf_file $name size loca fs_type

		print_ln $LEVEL_INFO "$pt_name_index: $name,$size,$loca,$fs_type"
		
		if [ $name = "swap" -a  $size = "?" ];then
			mem_size="null"
			mem_unit="null"
			get_memory_size mem_size mem_unit
			size=$(echo "2*$mem_size" | bc -l)"M"
		fi		
		
		set_partition_info_by_name $name $size $loca $fs_type
		
		let pt_name_index=$pt_name_index+1
	done 
	
	#Output to file
	print_ln $LEVEL_INFO "Output: $output_file"
	
	get_dest_drive dest_drive
	dbg_wr2file_ln $LEVEL_INFO "dest_drive=$dest_drive" $output_file	
	PT_DEST_OS_DRIVE="$dest_drive"
	PT_DEST_OS_DRIVE=`echo -e $dest_drive | tr -d '\r'`
	
	pt_name_index=1
	for pt_name_iterator in ${pt_name_arr[*]}  
	do  
		name=${pt_name_iterator}		
		get_partition_info_by_name $name size loca fs_type		
	
		if [ "$size" = "max" ];then
			PT_MAX_PARTITION_NAME="$name"
			PT_MAX_PARTITION_SIZE="$size"
			PT_MAX_PARTITION_LOCA="$loca"
			PT_MAX_PARTITION_FS_TYPE="$fs_type"
			continue
		fi
		dbg_wr2file_ln $LEVEL_INFO "$name:$size:$loca:$fs_type" $output_file
		
		let pt_name_index=$pt_name_index+1
	done 
	dbg_wr2file_ln $LEVEL_INFO "$PT_MAX_PARTITION_NAME:$PT_MAX_PARTITION_SIZE:$PT_MAX_PARTITION_LOCA:$PT_MAX_PARTITION_FS_TYPE" $output_file
	
	return $TRUE
}

do_partition_sizing $1 $2
source assert_int $? $TRUE

#exit $TRUE

