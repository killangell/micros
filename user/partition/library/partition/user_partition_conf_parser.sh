#!/bin/sh

source sys_string.sh

#@in  1: partition conf
#@out 2: dest drive
function get_conf_dest_drive()
{
	local conf_file=$1
	local dest_drivex="null"
	local left_value="null"
	local right_value="null"
	
	line=`cat $conf_file | grep "^dest_drive"`
	parse_format_string_by_splitter $line "=" num left_value right_value
	#echo left_value=$left_value,right_value=$right_value

	eval $2=$right_value
	return $TRUE
}

#@in  1: partition conf
#@in  2: partition name
#@out 3: partition size
#@out 4: partition locate
#@out 5: partition filesystem type
function get_conf_partition_info_by_name()
{
	local conf_file=$1
	local name=$2
	size="null"
	loca="null"
	fs_type="null"	
	
	line=`cat $conf_file | grep "^$name"`
	parse_format_string_by_splitter $line ":" num name size loca fs_type
	#echo " ptxx",$name,$size,$loca,$fs_type
	
	eval $3=$size
	eval $4=$loca
	eval $5=$fs_type
	
	return $TRUE
}

#@in  1: partition conf
#@out 2: dest drive
function get_conf_dest_drive2()
{
	local conf_file=$1
	local dest_drivex="null"
	local left_value="null"
	local right_value="null"
	
	while read line
	do	
		is_useless_line $line
		if [ $? -eq $TRUE ];then
			continue
		fi
		
		if [[ $line = *=* ]];then
			#echo line=$line
			parse_format_string_by_splitter $line "=" num left_value right_value
			#echo left_value=$left_value,right_value=$right_value
			if [[ $left_value = *dest_drive* ]];then
				dest_drivex=$right_value
				break
			fi
		fi	
	done < $conf_file
	eval $2=$dest_drivex	
	return $TRUE
}

#@in  1: partition conf
#@in  2: partition name
#@out 3: partition size
#@out 4: partition locate
#@out 5: partition filesystem type
function get_conf_partition_info_by_name2()
{
	local conf_file=$1
	local name=$2
	size="null"
	loca="null"
	fs_type="null"
	
	while read line
	do	
		is_useless_line $line
		if [ $? -eq $TRUE ];then
			continue
		fi
		
		if [[ $line = *:* ]];then		
			parse_format_string_by_splitter $line ":" num pt_name pt_size pt_loca pt_fs_type
			#echo " ptxx",$pt_name,$name,$pt_size,$pt_loca,$pt_fs_type
			if [[ $pt_name = *$name* ]];then
				size=$pt_size
				loca=$pt_loca
				fs_type=$pt_fs_type
				break
			fi
		fi	
	done < $conf_file
	
	eval $3=$size
	eval $4=$loca
	eval $5=$fs_type
	
	return $TRUE
}