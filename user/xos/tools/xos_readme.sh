#!/bin/sh

source sys_string.sh

XOS_README="$SYS_CONF_DIR/xos.readme"

#@in  1: File
#@in  2: Key 
#@out 3: Value
#@out 4: True(1)/False(0)
function parse_xos_readme_file_by_key()
{
	file="$1"
	key="$2"
	value="null"
	result=$FALSE
	
	while read line
	do	
		is_useless_line $line
		if [ $? -eq $TRUE ];then
			continue
		fi
		
		if [[ $line = *=* ]];then
			parse_format_string_by_splitter $line "=" num left right
			if [[ $key = $left ]];then
				#set -x
				value="$right"
				#set +x
				result=$TRUE
				break
			fi
		fi	
	done < $file
	
	eval $3=$value
	eval $4=$result
	
	return $TRUE
}

#@in  1: Key
#@out 2: Value
#@out 3: True(1)/False(0)
function get_xos_value_by_key()
{
	key="$1"
	value="null"
	result=$FALSE
	
	parse_xos_readme_file_by_key $XOS_README "$key" value result
	eval $2="$value"
	eval $3=$result
	
	return $result
}

#@out 1: Vendor
#@out 2: True(1)/False(0)
function get_xos_vendor()
{
	key="vendor"
	value="null"
	result=$FALSE
	
	get_xos_value_by_key "$key" value result
	eval $1="$value"
	eval $2=$result
	
	return $result
}

#@out 1: Version
#@out 2: True(1)/False(0)
function get_xos_version()
{
	key="version"
	value="null"
	result=$FALSE
	
	get_xos_value_by_key "$key" value result
	eval $1="$value"
	eval $2=$result
	
	return $result
}

#@out 1: Y/N
#@out 2: True(1)/False(0)
function get_xos_ks_is_unsupported_hardware()
{
	key="is_support_unsupported_hardware"
	value="null"
	result=$FALSE
	
	get_xos_value_by_key "$key" value result
	eval $1="$value"
	eval $2=$result
	
	return $result
}

#@out 1: True(1)/False(0)
function is_unsupported_hardware()
{
	value="N"
	result=$FALSE
	
	get_xos_ks_is_unsupported_hardware value result
	if [ "Y" = "$value" ];then
		result=$TRUE
	fi
	
	eval $1=$result
	
	return $result
}
