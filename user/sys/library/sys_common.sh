#!/bin/sh

#@in  1: Command name
#@out 2: Result
function is_cmd_exist()
{
	local cmd=$1
	result=0
	
	which $cmd > /dev/null 2>&1
	if [ $? == 0 ]; then
		result=$TRUE
	else
		result=$FALSE
	fi

	eval $2=$result

	return $TRUE
}