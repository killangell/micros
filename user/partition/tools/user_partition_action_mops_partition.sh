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
function do_partition_action_mops_partition()
{
	input_file=$1
	output_file=$2
	dest_drive=`echo -e $PT_DEST_OS_DRIVE | tr -d '\r'`
	PT_MOPS_PARTITION_NUM=0
	
	print_ln $LEVEL_INFO "Input: $input_file"
	#set -x	
	print_ln $LEVEL_INFO "dest_drive=$dest_drive"
	
	ks_partition_num=`cat $input_file | grep ^part | wc -l`
	print_ln $LEVEL_INFO "ks_partition_num=$ks_partition_num"
	
	string="parted -a opt /dev/$dest_drive -s mklabel gpt"
	dbg_wr2file_ln $LEVEL_INFO "$string" $output_file
	#set +x
	start_pos=0
	for((i=0;i<$ks_partition_num;i++));do
		let end_pos=$start_pos+300
		spos=$start_pos"MB"
		epos=$end_pos"MB"
		
		string="parted -a opt /dev/$dest_drive -s mkpart primary $spos $epos"
		dbg_wr2file_ln $LEVEL_INFO "$string" $output_file
		let PT_MOPS_PARTITION_NUM=$PT_MOPS_PARTITION_NUM+1
		
		start_pos=$end_pos
	done

	get_disk_size $dest_drive size unit
	print_ln $LEVEL_INFO "$dest_drive:$size$unit"

	#This partition is used to store ISO source file
	let iso_partition_start=$size-10
	spos=$iso_partition_start"GB"
	
	string="parted -a opt /dev/$dest_drive -s mkpart primary $spos 100%"
	dbg_wr2file_ln $LEVEL_INFO "$string" $output_file	
	let PT_MOPS_PARTITION_NUM=$PT_MOPS_PARTITION_NUM+1
	
	isodev="$PT_DEST_OS_DRIVE$PT_MOPS_PARTITION_NUM"
	string="ln -s /dev/$isodev /dev/$SYS_ISO_DEV"
	dbg_wr2file_ln $LEVEL_INFO "$string" $output_file	
	
	print_ln $LEVEL_INFO "PT_MOPS_PARTITION_NUM=$PT_MOPS_PARTITION_NUM"
		
	print_ln $LEVEL_INFO "Output: $output_file"
	
	return $TRUE
}

do_partition_action_mops_partition $1 $2
source assert_int $? $TRUE

