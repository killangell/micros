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

#@in  1: Debug level
#@in  2: String
#@in  3: Destination file
#return: result(true/false)
function dbg_wr2file_ln()
{
	dbg_level=$1
	string="$2"
	dest_file="$3"
	
	print_ln $dbg_level "$string"
	echo "$string" >> $dest_file
	
	return $TRUE
}

