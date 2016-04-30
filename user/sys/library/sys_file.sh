#!/bin/sh

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

#@in  1: file_path
#return: result(true/false)
#Desc  : Starting with "^#" line and "blank" line are useless
function is_useless_line()
{
	if [[ $line = *#* ]];then
		return $TRUE
	elif [[ $line = "" ]];then
		return $TRUE
	elif [[ $line = "\n" ]];then
		return $TRUE
	fi
	
	return $FALSE
}


