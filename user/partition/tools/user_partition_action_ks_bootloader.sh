#!/bin/sh

source sys_debug.sh
source sys_file.sh
source sys_string.sh
source user_partition_ks_converter.sh

#@in  1: User Partition file
#@out 2: Output file
#return: true(1)/false(0)
function do_partition_action_ks_bootloader()
{
	output_file=$1
	dest_drive=$PT_DEST_OS_DRIVE
	
	print_ln $LEVEL_INFO "Input: $dest_drive"
	
	get_ks_bootloader_string $dest_drive string
	string=$(echo $string | sed 's/+/ /g')
	
	dbg_wr2file_ln $LEVEL_INFO "$string" $output_file
	
	print_ln $LEVEL_INFO "Output: $output_file"
	
	return $TRUE
}

do_partition_action_ks_bootloader $1
source assert_int $? $TRUE

