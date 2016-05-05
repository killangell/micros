#!/bin/sh

source sys_debug.sh
source sys_file.sh
source sys_disk.sh
source sys_string.sh
source user_partition_define.sh
source user_partition_conf_parser.sh	
source user_partition_ks_converter.sh

#@in  1: User Partition file
#@out 2: Output file
#return: true(1)/false(0)
function do_partition_action_ks_partition()
{
	input_file=$1
	output_file=$2
	dest_drive=$PT_DEST_OS_DRIVE
	max_partition_name="$PT_MAX_PARTITION_NAME"
	max_partition_size="$PT_MAX_PARTITION_SIZE"
	max_partition_loca="$PT_MAX_PARTITION_LOCA"
	max_partition_fs_type="$PT_MAX_PARTITION_FS_TYPE"
	lvm_created_partition_flag="false"
	lvm_vg_name=$PT_VG_NAME
	
	print_ln $LEVEL_INFO "Input: $input_file"
	
	string="clearpart --all --drives=$dest_drive"	
	dbg_wr2file_ln $LEVEL_INFO "$string" $output_file
	
	string="ignoredisk --only-use=$dest_drive"
	dbg_wr2file_ln $LEVEL_INFO "$string" $output_file
	
	while read line
	do	
		if [[ $line = *=* ]];then
			continue
		fi
				
		parse_format_string_by_splitter $line ":" num name size loca fs_type
		if [ $size = "max" -o $size = "0" ];then
			continue # Do it at last
		fi
		
		if [ $loca = "disk" ];then
			get_ks_disk_partition_string $name $size $fs_type string
		else
			if [ $lvm_created_partition_flag = "false" ];then
				string="part pv.008019 --grow --size=1"
				dbg_wr2file_ln $LEVEL_INFO "$string" $output_file

				string="volgroup $lvm_vg_name --pesize=4096 pv.008019"
				dbg_wr2file_ln $LEVEL_INFO "$string" $output_file
				
				lvm_created_partition_flag="true" #Only create one time
			fi
			get_ks_lvm_partition_string $name $size $fs_type $lvm_vg_name string
		fi
		
		string=$(echo $string | sed 's/+/ /g')
		dbg_wr2file_ln $LEVEL_INFO "$string" $output_file
		
		let index=$index+1
	done < $input_file
	
	if [ "null" != "$max_partition_name" ];then
		if [ $max_partition_loca = "disk" ];then
			get_ks_disk_partition_string $max_partition_name $max_partition_size $max_partition_fs_type string
		else
			get_ks_lvm_partition_string $max_partition_name $max_partition_size $max_partition_fs_type $lvm_vg_name string
		fi
		string=$(echo $string | sed 's/+/ /g')
		dbg_wr2file_ln $LEVEL_INFO "$string" $output_file
	fi
	
	print_ln $LEVEL_INFO "Output: $output_file"
	
	return $TRUE
}

do_partition_action_ks_partition $1 $2
source assert_int $? $TRUE

