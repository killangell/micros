#!/bin/sh

source sys_debug.sh

#@in  1: File full path
#@out 2: Result
function is_file_exist()
{
	file_path=$1
	result=0
	
	if [ ! -f $file_path ];then
		result=$FALSE
	else
		result=$TRUE
	fi
	eval $2=$result
	
	return $TRUE
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
	
	print_ln $dbg_level "wr2file: $string"
	echo "$string" >> $dest_file
	
	return $TRUE
}

#@in  1: Debug level
#@in  2: Description
#@in  3: String
#@in  4: Destination file
#return: result(true/false)
function dbg_wr2file_ln_ex()
{
	local dbg_level=$1
	local desc="$2"
	local string="$3"
	local dest_file="$4"
	
	print_ln $dbg_level "write[$desc]: $string"
	echo "$string" >> $dest_file
	
	return $TRUE
}

