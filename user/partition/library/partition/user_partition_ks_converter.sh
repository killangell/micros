#!/bin/sh

source sys_disk.sh
source sys_string.sh
source user_partition_define.sh

#@in  1: User mode size 				(e.g.: 200M/10G)	
#@out 2: Output ks partition size in MB (e.g.: 200 /10000)
function convert_user_size_to_ks_partition_size()
{
	user_size=$1
	number="null"
	unit="null"
	
	split_string_to_n_c $user_size number unit
	unit=`echo $unit | tr '[:upper:]' '[:lower:]'`
	g_index=`expr index $unit g`
	if [ $g_index -ne 0 ];then
		#Convert xxxx.00 to xxxx
		number=$(echo "$number*1000" | bc -l | awk '{printf ("%d",$1)}')
	fi
	
	eval $2=$number
	return $TRUE
}

#@in  1: Partition name
#@in  2: Partition size	
#@in  3: Partition filesystem	
#@out 4: Output pattition string 
function get_ks_disk_partition_string()
{
	name=$1
	size=$2
	fs_type=$3
	mount_point="null"
	output_string="null"
	
	get_partition_mount_point_by_name $name mount_point
	
	if [ $size != "max" ];then
		convert_user_size_to_ks_partition_size $size ks_size 
		if [ $name = "swap" ];then
			output_string="part $mount_point --asprimary --size=$ks_size"
		else
			output_string="part $mount_point --fstype=$fs_type --asprimary --size=$ks_size"
		fi
	else
		output_string="part $mount_point --fstype=$fs_type --asprimary --grow --size=1"
	fi	 
	
	#echo output_string="$output_string"
	#Because eval limits, replace blank space to plus 
	eval $4=$(echo $output_string | sed 's/ /+/g')
	return $TRUE
}

#@in  1: Partition name 		(eg. boot)
#@in  2: Partition size	
#@in  3: Partition filesystem	
#@in  4: Volume group
#@out 5: Output partition string
function get_ks_lvm_partition_string()
{
	name=$1
	lv_name=lv_$1
	size=$2
	fs_type=$3
	vgname=$4
	mount_point="null"
	output_string="null"
	
	get_partition_mount_point_by_name $name mount_point
	
	if [ $size != "max" ];then	
		convert_user_size_to_ks_partition_size $size ks_size 
		if [ $name = "swap" ];then
			output_string="logvol $mount_point --vgname=$vgname --size=$ks_size --name=$lv_name"
		else
			output_string="logvol $mount_point --fstype=$fs_type --vgname=$vgname --size=$ks_size --name=$lv_name"
		fi
	else
		output_string="logvol $mount_point --fstype=$fs_type --vgname=$vgname --size=1 --grow --name=$lv_name"
	fi	 
	
	#Because eval limits, replace blank space to plus 
	#echo output_string=$output_string
	eval $5=$(echo $output_string | sed 's/ /+/g')
	return $TRUE
}

#@in  1: Partition name that iso located. (e.g.: it may be sda2/sda3..)
#@out 2: Output pattition string 
function get_ks_harddrive_string()
{
	#iso_loca=$dest_drive$prel_iso_partition_num
	iso_loca=$1
	output_string="null"
	
	output_string="harddrive --partition=$iso_loca --dir="
	
	#Because eval limits, replace blank space to plus 
	eval $2=$(echo $output_string | sed 's/ /+/g')
	
	return $TRUE
}

#@in  1: Dest drive to install os (e.g.: sda/hda)
#@out 2: Output pattition string 
function get_ks_bootloader_string()
{
	dest_drive=$1
	output_string="null"
	
	output_string="bootloader --location=mbr --driveorder=$dest_drive --append=\\\"crashkernel=auto rhgb quiet\\\""
	#Because eval limits, replace blank space to plus
	#set -x 
	#echo output_string1=$output_string
	eval $2=$(echo $output_string | sed 's/ /+/g')
	#echo output_string2=$2
	#set +x
	
	return $TRUE
}

#@in  1: Start size
#@in  2: Current Partition size
#@out 3: Current Partition end size
function get_current_partition_end_size()
{
	local start_size=$1
	local pt_size=$2
	local pt_size_num="null"
	local pt_size_unit="null"
	local pt_end_num="null"
	local pt_end_unit="null"
	local point_index="null"
	pt_end_size="null"
	
	split_string_to_n_c $start_size start_size_num start_size_unit
	#print_ln $LEVEL_INFO "start_size:$start_size_num,$start_size_unit"	
	split_string_to_n_c $pt_size pt_size_num pt_size_unit
	#print_ln $LEVEL_INFO "pt_size:$pt_size_num,$pt_size_unit"
	
	if [ $pt_size_unit = 'M' ];then
		if [ $start_size_unit = 'M' ];then
			pt_end_num=$(echo "$start_size_num+$pt_size_num" | bc -l)
		elif [ $start_size_unit = 'G' ];then	
			pt_end_num=$(echo "$start_size_num*1000+$pt_size_num" | bc -l)	
		fi
	elif [ $pt_size_unit = 'G' ];then		
		if [ $start_size_unit = 'M' ];then
			pt_end_num=$(echo "scale=2;$start_size_num/1000+$pt_size_num" | bc -l)
		elif [ $start_size_unit = 'G' ];then
			pt_end_num=$(echo "$start_size_num+$pt_size_num" | bc -l)
		fi
	fi
	#set -x
	#Add prefix 0 to format as .72G caused by `bc -l`, the result should be 0.72G
	point_index=`expr index $pt_end_num .`
	if [ $point_index -eq 1 ];then
		pt_end_num=`echo $pt_end_num | awk '{printf "%.2f", $1}'`
	fi
	#set +x
	pt_end_unit=$pt_size_unit
	pt_end_size="$pt_end_num$pt_end_unit"
	
	eval $3=$pt_end_size
	
	return $TRUE
}

