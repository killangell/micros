#!/bin/sh

source sys_string.sh

#@in  1: Full path of sysinfo.table
#@in  2: Key
#@out 3: Index
function pair_get_key_index()
{
	local conf_file=$1
	local name=$2
	
	local line_num=`sed -n "/^$name/=" $conf_file`		
	eval $3=$line_num
	
	return $TRUE
}

#@in  1: Full path of sysinfo.table
#@in  2: Key
#@in  3: Value
function pair_add_node()
{
	local conf_file=$1
	local key=$2
	local value=$3
	
	local new_line="$key=$value"
	
	echo $new_line >> $conf_file
	
	return $TRUE
}

#@in  1: Full path of sysinfo.table
#@in  2: Key
#@out 3: Value
function pair_get_value_by_key()
{
	local conf_file=$1
	local key=$2
	local value="null"
	
	value=`cat $conf_file | grep "^$key" | awk -F "=" '{print $2}'`
	
	eval $3=$value
	
	return $TRUE
}

#@in  1: Full path of sysinfo.table
#@in  2: Key
#@in  3: Value
function pair_set_value_by_key()
{
	local conf_file=$1
	local key=$2
	local new_value=$3
	local old_value="null"
	
	pair_get_value_by_key $conf_file $key old_value
	pair_get_key_index $conf_file $key line_num
	#echo key=$key,line_num=$line_num
	local replace_flag=$line_num"s"
	
	sed -i "$replace_flag/=$old_value/=$new_value/g" $conf_file
	
	return $TRUE
}
