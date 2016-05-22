#!/bin/sh

source sys_debug.sh
source sys_file.sh
source sys_string.sh
source user_partition_ks_converter.sh
source user_partition_db_opt.sh

#@out 1: Output file
#return: true(1)/false(0)
function do_partition_action_ks_harddrive()
{
	local output_file=$1
	local isodev="null"
	
	print_ln $LEVEL_INFO "Output: $output_file"
	
	user_partition_get_isodev isodev
	
	get_ks_harddrive_string $isodev string
	string=$(echo $string | sed 's/+/ /g')
	
	dbg_wr2file_ln_ex $LEVEL_INFO "ks-harddisk" "$string" $output_file
		
	return $TRUE
}

do_partition_action_ks_harddrive $1
source assert_int $? $TRUE

