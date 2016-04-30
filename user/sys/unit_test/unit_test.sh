#!/bin/sh

#echo PATH=$PATH

source sys_debug.sh

for dir in $SYS_UTEST_DIR/*
do
    if [ -d $dir ];then
		print_ln LEVEL_INFO "Enter into folder $dir"
		cd $dir
		sh test_start.sh
		cd ..
	fi
done

