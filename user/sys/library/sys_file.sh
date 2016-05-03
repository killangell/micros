#!/bin/sh

source sys_debug.sh

#@in  1: file_path
#return: result(true/false)
function is_file_exist()
{
	file_path=$1
	
	if [ ! -f $file_path ];then
		return $FALSE
	else
		return $TRUE
	fi
}

#@in  1: String
#@in  2: Destination file
#@in  3: Debug level
#return: result(true/false)
function dbg_wr2file_ln()
{
	string="$1"
	dest_file="$2"
	dbg_level=$3
	
	print_ln $dbg_level "$string"
	echo "$string" >> $dest_file
	
	return $TRUE
}

