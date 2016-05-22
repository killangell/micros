#!/bin/sh

source sys_string.sh

#@in  1: Full path of partition.table
#@in  2: Name
#@out 3: Index
function get_partition_index_by_name()
{
	local conf_file=$1
	local name=$2

	line_num=`sed -n "/^$name/=" $conf_file`		
	eval $3=$line_num
	
	return $TRUE
}

#@in  1: Full path of partition.table
#@in  2: Name
#@out 3: Index
function get_partition_name_by_index()
{
	local conf_file=$1
	local line="null"

	line=`sed -n "$2P" $conf_file`		
	eval $3=$line_num
	
	return $TRUE
}

#@in  1: Full path of partition.table
#@in  2: Name
function remove_partition_by_name()
{
	local conf_file=$1
	local name=$2
	
	get_partition_index_by_name $conf_file $name line_num		
	remove_flag="$line_num""d"
	sed -i "$remove_flag" $conf_file
	
	return $TRUE
}

#@in  1: Full path of partition.table
#@in  2: Name
#@out 3: Size
#@out 4: Location
#@out 5: File system
#@out 6: Reserved1
#@out 7: Reserved2
function get_partition_by_name()
{
	local conf_file=$1
	local name=$2
	size="null"
	loca="null"
	fs_type="null"
	resv1="null"
	resv2="null"
		
	line=`cat $conf_file | grep "^$name"`	
	parse_format_string_by_splitter $line ":" num name size loca fs_type resv1 resv2
	
	eval $3=$size
	eval $4=$loca
	eval $5=$fs_type
	eval $6=$resv1
	eval $7=$resv2
	
	return $TRUE
}

#@in  1: Full path of partition.table
#@in  2: Name
#@in  3: Size
#@in  4: Location
#@in  5: File system
#@in  6: Reserved1
#@in  7: Reserved2
function set_partition_by_name()
{
	local conf_file=$1
	local name=$2
	local size=$3
	local loca=$4
	local fs_type=$5
	local resv1=$6
	local resv2=$7
	
	newline="$name:$size:$loca:$fs_type:$resv1:$resv2"
	get_partition_index_by_name $conf_file $name line_num
	replace_flag=$line_num"c"
	sed -i "$replace_flag $newline" $conf_file
		
	return $TRUE
}

#@in  1: Full path of partition.table
#@in  2: Flag
#@out 3: Count
function get_partition_count_by_flag()
{
	local conf_file=$1
	local flag=":$2:"
	
	count=`cat $conf_file | grep $flag | wc -l`
	
	eval $3=$count
	
	return $TRUE
}

#@in  1: Full path of partition.table
#@in  2: Name
#@out 3: Exist or not 
function is_partition_name_exist()
{
	local conf_file=$1
	local flag="$2"
	exist=$FALSE
	
	count=`cat $conf_file | grep $flag | wc -l`
	if [ $count -ne 0 ];then
		exit=$TRUE
	fi
	eval $3=$exit
	
	return $TRUE
}

#@in  1: Full path of partition.table
#@out 2: Partition count
function get_partition_count_base()
{
	local conf_file=$1
	local line_count=0
	local ignore_count=0
	partition_count=0
	
	line_count=`cat $conf_file | wc -l`
	ignore_count=`cat $conf_file | grep ^#| wc -l`
	
	let partition_count=$line_count-$ignore_count
	eval $2=$partition_count
	
	return $TRUE
}

#@in  1: Full path of partition.table
function strip_partition_file()
{
	local conf_file=$1
	
	sed -i '/^#/d' $conf_file
	sed -i '/^$/d' $conf_file
	
	return $TRUE
}

#@in  1: Full path of partition.table
#@out 2: Partition name list
function get_partition_name_list()
{
	local conf_file=$1
	#local result=$2
	name_list="null"
	
	name_list=`cat $conf_file | awk -F ":" '{print $1}'`
	eval $2="'$name_list'"
	
	return $TRUE
}

