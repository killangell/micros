#!/bin/sh

source sys_debug.sh
source sys_file.sh
source sys_disk.sh
source sys_string.sh
source user_partition_define.sh
source user_partition_conf_parser.sh	
source user_partition_ks_converter.sh
source user_partition_db_opt.sh

#@out 1: Output file
#return: true(1)/false(0)
function do_partition_action_mops_partition()
{
	local output_file=$1
	local name_list="null"
	local pt_name="null"
	local pt_size="null"
	local pt_loca="null"
	local pt_fs_type="null"
	local pt_mount_point="null"
	local pt_size_start="null"
	local pt_size_end="null"
	local pt_iso_size_start="null"
	local disk_size="null"
	local disk_size_unit="null"
	local dest_drive="null"
	local string="null"
	local is_have_lvm=$FALSE
	
	print_ln $LEVEL_INFO "Output: $output_file"
		
	db_get_sysinfo_dest_drive dest_drive
	print_ln $LEVEL_INFO "dest_drive:$dest_drive"
	

	get_disk_size $dest_drive disk_size disk_size_unit
	print_ln $LEVEL_INFO "disk_size:$disk_size$disk_size_unit"
	
	#This partition is used to store ISO source file
	let pt_iso_size_start=$disk_size-10
	pt_iso_size_start=$pt_iso_size_start"G"
	print_ln $LEVEL_INFO "pt_iso_size_start:$pt_iso_size_start"
	
	string="echo y | mkfs.ext4 -F /dev/$dest_drive"
	dbg_wr2file_ln_ex $LEVEL_INFO  "mops-part" "$string" $output_file

	string="parted -a opt /dev/$dest_drive -s mklabel gpt"
	dbg_wr2file_ln_ex $LEVEL_INFO "mops-part" "$string" $output_file
	
	db_get_partitioin_name_list name_list
	#echo name_list=$name_list 
	pt_size_start="0M"
	for pt_name in ${name_list[@]}
	do
		#echo $pt_name
		db_get_partition_full_info $pt_name pt_size pt_loca pt_fs_type pt_mount_point
		get_current_partition_end_size $pt_size_start $pt_size pt_size_end	
		print_ln $LEVEL_INFO "pt[$pt_name]:$pt_size[$pt_size_start-$pt_size_end],$pt_loca,$pt_fs_type,$pt_mount_point"
		
		if [ $pt_loca = "disk" ];then
			string="parted -a opt /dev/$dest_drive -s mkpart primary $pt_size_start $pt_size_end"
			dbg_wr2file_ln_ex $LEVEL_INFO "mops-part" "$string" $output_file
		elif [ $pt_loca = "lvm" ];then
			is_have_lvm=$TRUE
			break
		fi
		
		pt_size_start=$pt_size_end
	done
	
	if [ $is_have_lvm = $TRUE ];then
		string="parted -a opt /dev/$dest_drive -s mkpart primary $pt_size_start $pt_iso_size_start"
		dbg_wr2file_ln_ex $LEVEL_INFO "mops-part" "$string" $output_file
	fi
	
	string="parted -a opt /dev/$dest_drive -s mkpart primary $pt_iso_size_start 100%"
	dbg_wr2file_ln_ex $LEVEL_INFO "mops-part" "$string" $output_file
	
	local isodev="null"
	user_partition_get_isodev isodev
	string="mkfs.ext4 /dev/$isodev"
	dbg_wr2file_ln_ex $LEVEL_INFO "mops-part" "$string" $output_file
	
	return $TRUE
}

do_partition_action_mops_partition $1
source assert_int $? $TRUE

