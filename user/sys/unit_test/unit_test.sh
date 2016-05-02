#!/bin/sh

#echo PATH=$PATH

sh sys_loop_subfolder_and_exec.sh $SYS_UTEST_DIR "test_all.sh"

:<<AA
source sys_debug.sh

for dir in $SYS_UTEST_DIR/*
do
    if [ -d $dir ];then
		print_ln $LEVEL_INFO "Enter into folder $dir"
		cd $dir
		sh test_all.sh
		cd ..
	fi
done
AA