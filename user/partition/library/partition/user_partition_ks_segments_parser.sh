#!/bin/sh

#@in  1: File ks-segment-partition.out
#@in  2: Partition index
#@out 3: Size in MiB
#Desc  : This function is can only parse the following string.
#		 e.g. : part /boot --fstype=ext4 --asprimary --size=200M
function get_ks_segments_partition_size()
{
	file=$1
	index=$2
	
	size=`cat $file | grep ^part | awk "NR==$index" | awk '{print $5}' | awk -F "=" '{print int($2)}'`
	eval $3=$size

	return $TRUE
}

