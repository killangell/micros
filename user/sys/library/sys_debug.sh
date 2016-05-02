#!/bin/sh

export LEVEL_NONE=0
export LEVEL_INFO=1
export LEVEL_ERROR=2
export LEVEL_FATAL=3

#Debug that level >= DEBUG_LEVEL will show on screen(console).
#e.g. : DEBUG_LEVEL=LEVEL_INFO, it indicates that all debug info will show on screen.
#e.g. : DEBUG_LEVEL=LEVEL_ERROR, it indicates that both LEVEL_ERROR and LEVEL_FATAL info will show on screen.
#e.g. : DEBUG_LEVEL=LEVEL_FATAL, it indicates that only LEVEL_FATAL info will show on screen.
export DEBUG_LEVEL #=$LEVEL_NONE

#@in  1: Debug level
function set_debug_level()
{
	DEBUG_LEVEL=$1
	return $TRUE
}

#@out 1: Debug level
function get_debug_level()
{
	eval $1=$DEBUG_LEVEL
	return $TRUE
}

#@in  1: sh full name
#@out 2: Last name
function get_sh_last_name()
{
	sh_name=$1
	
	eval $2=`echo "$sh_name" | awk -F '/' '{print $NF}'`

	return 1
}
#@in 1: level
#@in 2: info
#Desc : When call & pass $3 to this function, you must surround $3 with sign " otherwise $3 will be splited by blank space
function print_ln()
{
	sh_name=$0
	level=$1
	info=$2
	#echo $FUNCNAME:DEBUG_LEVEL=$DEBUG_LEVEL

	if [ $DEBUG_LEVEL -eq $LEVEL_NONE -o $level -lt $DEBUG_LEVEL ];then
		return $TRUE
	fi

	#if [ $level -lt $DEBUG_LEVEL ];then
	#	return $TRUE
	#fi
	
	get_sh_last_name $sh_name last_name
	
	printf "[%-15s] " $last_name
	echo $info 

	return $TRUE
}

#@in 1: level
#@in 2: info
#Desc : When call & pass $2 to this function, you must surround $2 with sign " otherwise $2 will be splited by blank space
function print_head()
{
	sh_name=$0
	level=$1
	info=$2
	
	get_sh_last_name $sh_name last_name

	printf "[%-15s] " $last_name 
	printf "$info"
}


#@in 1: level
#@in 2: info
#Desc : When call & pass $2 to this function, you must surround $2 with sign " otherwise $2 will be splited by blank space
function print_body()
{
	level=$1
	info=$2

	printf "$info" 
}

#@in 1: level
function show_sh_begin_banner()
{
	level=1
	info="begin..."
	
	echo
	echo "--------------------------------------------------------------------------------"
	print_ln $level $info
}

#@in 1: level
function show_sh_end_banner()
{
	level=1
	info="end!!!"
	
	print_ln $level $info
	echo "................................................................................"
	echo
}