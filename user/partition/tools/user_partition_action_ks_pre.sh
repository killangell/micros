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
	local isodev="null"
	local dest_drive="null"
	
	print_ln $LEVEL_INFO "Output: $output_file"
	
	db_get_sysinfo_dest_drive dest_drive
	user_partition_get_isodev isodev
	
	# string="parted -a opt /dev/$dest_drive -s mklabel gpt"
	# dbg_wr2file_ln $LEVEL_INFO "$string" $output_file
	
	string="mkdir -p $PT_KS_TEMP_DIR $PT_KS_PRELOAD_DIR"
	dbg_wr2file_ln_ex $LEVEL_INFO "ks-pre" "$string" $output_file
	
	string="mount /dev/$isodev $PT_KS_TEMP_DIR"
	dbg_wr2file_ln_ex $LEVEL_INFO "ks-pre" "$string" $output_file
	
	string="cp $PT_KS_TEMP_DIR/rc.local $PT_KS_PRELOAD_DIR"
	dbg_wr2file_ln_ex $LEVEL_INFO "ks-pre" "$string" $output_file
	
	string="umount /dev/$isodev -l"
	dbg_wr2file_ln_ex $LEVEL_INFO "ks-pre" "$string" $output_file
	
	return $TRUE
}

do_partition_action_ks_pre $1
source assert_int $? $TRUE

