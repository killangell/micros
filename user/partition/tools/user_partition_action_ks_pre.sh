#!/bin/sh

source sys_debug.sh
source sys_file.sh
source sys_string.sh
source user_partition_ks_converter.sh
source user_partition_db_opt.sh

#@out 1: Output file
#return: true(1)/false(0)
function do_partition_action_ks_pre()
{
	local output_file=$1
	local dest_drive="null"
	
	print_ln $LEVEL_INFO "Output: $output_file"
	
	db_get_sysinfo_dest_drive dest_drive
	
	isodev="$PT_DEST_OS_DRIVE$PT_MOPS_PARTITION_NUM"
	
	# string="parted -a opt /dev/$dest_drive -s mklabel gpt"
	# dbg_wr2file_ln $LEVEL_INFO "$string" $output_file
	
	# while read line
	# do 
		# string="$line"
		# dbg_wr2file_ln $LEVEL_INFO "$string" $output_file
	# done < $SYS_EXPECT_MOPS_PARTITION_SH_FILE
	
	mops_phase_partition_num=$PT_MOPS_PARTITION_NUM
	let last_mops_phase_partition_num=$mops_phase_partition_num	
	let delete_mops_phase_partition_num=$mops_phase_partition_num-1
	
	for((i=0;i<$delete_mops_phase_partition_num;i++));do
		let delete_partition_index=$i+1
		string="parted /dev/$dest_drive rm $delete_partition_index"
		dbg_wr2file_ln $LEVEL_INFO "$string" $output_file
	done
	
	isodev="$PT_DEST_OS_DRIVE$PT_MOPS_PARTITION_NUM"
	full_device="/dev/$isodev"
	
	string="mkdir -p $PT_KS_TEMP_DIR $PT_KS_PRELOAD_DIR"
	dbg_wr2file_ln $LEVEL_INFO "$string" $output_file
	
	string="mount $full_device $PT_KS_TEMP_DIR"
	dbg_wr2file_ln $LEVEL_INFO "$string" $output_file
	
	string="cp $PT_KS_TEMP_DIR/rc.local $PT_KS_PRELOAD_DIR"
	dbg_wr2file_ln $LEVEL_INFO "$string" $output_file
	
	string="umount $full_device -l"
	dbg_wr2file_ln $LEVEL_INFO "$string" $output_file
	
	return $TRUE
}

do_partition_action_ks_pre $1
source assert_int $? $TRUE

