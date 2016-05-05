#!/bin/sh

#@in  1: Parent folder
#@in  2: Script name that need to execute

source sys_debug.sh


parent_dir=$1
script_name=$2

print_ln $LEVEL_INFO "Loop at parent folder $parent_dir"

for sub_dir in $parent_dir/*
do
    if [ -d $sub_dir ];then
		print_ln $LEVEL_INFO "Enter into sub folder $sub_dir and exec $script_name"
		cd $sub_dir
		sh $script_name
		if [ $? -eq $FALSE ];then
			exit $FALSE
		fi
		cd ..
	fi
done

exit $TRUE