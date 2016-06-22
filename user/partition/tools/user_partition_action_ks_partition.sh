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
function do_partition_action_ks_partition()
{
	local output_file=$1
	local dest_drive="null"
	local pt_name_index="null"
	local pt_name="null"
	local pt_size="null"
	local pt_loca="null"
	local pt_fs_type="null"
	local pt_device="null"
	local max_partition_name="null"
	local lvm_created_partition_flag="false"
	local lvm_vg_name=$PT_VG_NAME
	local name_list="null"
	
	print_ln $LEVEL_INFO "Output: $output_file"	
	
	# string="mkfs.ext4 /dev/$dest_drive"
	# dbg_wr2file_ln $LEVEL_INFO "$string" $output_file

	# string="parted -a opt /dev/$dest_drive -s mklabel gpt"
	# dbg_wr2file_ln $LEVEL_INFO "$string" $output_file
	
	db_get_sysinfo_dest_drive dest_drive
	#string="clearpart --all --drives=$dest_drive"
	#dbg_wr2file_ln_ex $LEVEL_INFO "ks-part" "$string" $output_file
	
	string="ignoredisk --only-use=$dest_drive"
	dbg_wr2file_ln_ex $LEVEL_INFO "ks-part" "$string" $output_file
	
	db_get_partitioin_name_list name_list
	#echo name_list=$name_list
	pt_name_index=1	
	pt_size_start="0M"
	for pt_name in ${name_list[@]}
	do
		#echo $pt_name
		db_get_partition_full_info $pt_name pt_size pt_loca pt_fs_type pt_mount_point
		print_ln $LEVEL_INFO "pt[$pt_name]:$pt_size,$pt_loca,$pt_fs_type,$pt_mount_point"
		
		# if [ $pt_size = "max" ];then
			# max_partition_name=$pt_name
			# break
		# fi
		
		pt_device="$dest_drive""$pt_name_index"
		if [ $pt_loca = "disk" ];then
			string="part $pt_mount_point --fstype=$pt_fs_type --onpart=/dev/$pt_device"
		elif [ $pt_loca = "lvm" ];then
			if [ $lvm_created_partition_flag = "false" ];then			
				string="part pv.008019 --onpart=/dev/$pt_device"
				dbg_wr2file_ln_ex $LEVEL_INFO "ks-part" "$string" $output_file

				string="volgroup $lvm_vg_name --pesize=4096 pv.008019"
				dbg_wr2file_ln_ex $LEVEL_INFO "ks-part" "$string" $output_file
				
				lvm_created_partition_flag="true" #Only create one time
			fi
			get_ks_lvm_partition_string $pt_name $pt_size $pt_fs_type $lvm_vg_name string
		fi
		
		string=$(echo $string | sed 's/+/ /g')
		dbg_wr2file_ln_ex $LEVEL_INFO "ks-part" "$string" $output_file
		
		pt_size_start=$pt_size_end
		let pt_name_index=$pt_name_index+1
	done
	
	return $TRUE
}

do_partition_action_ks_partition $1
source assert_int $? $TRUE

