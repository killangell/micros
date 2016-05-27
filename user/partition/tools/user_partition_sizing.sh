#!/bin/sh

source sys_debug.sh
source sys_file.sh
source sys_disk.sh
source user_partition_define.sh
source user_partition_conf_parser.sh
source user_partition_db_opt.sh

#@out 1: Output file
#return: true(1)/false(0)
function do_partition_sizing()
{
	conf_file=$1
	
	print_ln $LEVEL_INFO "Input: $conf_file"
	
	dest_drive="null"
	name="null"
	size="null"
	loca="null"
	fs_type="null"
	
	#Read partition conf and save 
	get_conf_dest_drive $conf_file dest_drive
	print_ln $LEVEL_INFO "dest_drive: $dest_drive"
	db_set_sysinfo_dest_drive $dest_drive	
	
	pt_name_index=1	
	for pt_name_iterator in ${pt_name_arr[*]}  
	do  
		name=${pt_name_iterator}
		#set -x
		#echo conf_file=$conf_file
		get_conf_partition_info_by_name $conf_file $name size loca fs_type
		#set +x
		print_ln $LEVEL_INFO "$pt_name_index: $name,$size,$loca,$fs_type"

		if [ $name = "swap" -a  $size = "?" ];then
			mem_size="null"
			mem_unit="null"
			get_memory_size mem_size mem_unit
			size=$(echo "2*$mem_size" | bc -l)"M"
		fi		
		
		##set_partition_info_by_name $name $size $loca $fs_type
		if [ $size = 0 ];then
			db_remove_partition $name
		else
			user_partition_set_db_info $name $size $loca $fs_type
		fi
		
		let pt_name_index=$pt_name_index+1
	done
	
	db_strip_partition_file
	
	print_ln $LEVEL_INFO "Output in db"
	db_get_partitioin_name_list name_list
	pt_name_index=1
	for pt_name in ${name_list[@]}
	do
		db_get_partition_full_info $pt_name pt_size pt_loca pt_fs_type pt_mount_point
		print_ln $LEVEL_INFO "$pt_name_index: $pt_name:$pt_size,$pt_loca,$pt_fs_type,$pt_mount_point"
		let pt_name_index=$pt_name_index+1
	done
	
	return $TRUE
}

do_partition_sizing $1
source assert_int $? $TRUE

#exit $TRUE

