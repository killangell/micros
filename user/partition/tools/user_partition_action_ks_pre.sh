#!/bin/sh

source sys_debug.sh
source sys_file.sh
source sys_string.sh
source user_partition_ks_converter.sh

#@in  1: User Partition file
#@out 2: Output file
#return: true(1)/false(0)
function do_partition_action_ks_pre()
{
	output_file=$1
	dest_drive=$PT_DEST_OS_DRIVE
	
	print_ln $LEVEL_INFO "Input: $dest_drive"
	
	isodev="$PT_DEST_OS_DRIVE$PT_MOPS_PARTITION_NUM"
	
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
	
	print_ln $LEVEL_INFO "Output: $output_file"
	
	return $TRUE
}

do_partition_action_ks_pre $1
source assert_int $? $TRUE

