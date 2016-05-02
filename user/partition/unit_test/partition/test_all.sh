#!/bin/sh

export PATH=$PATH:./
export PATH=$PATH:$SYS_LIBRARY_DIR/partition

source sys_debug.sh
source test_user_partition_define.sh
source test_user_partition_conf_parser.sh
source test_user_partition_ks_converter.sh

#Global define, should be unique in system
unit_test_func_index="null"
unit_test_func_arr="null"
unit_test_func_iterator="null"

show_sh_begin_banner

#Test list
unit_test_func_arr=(
	test_partition_conf_parser_all_funcs
	test_partition_define_all_funcs
	test_partition_ks_converter_all_funcs
)

unit_test_func_index=1
for unit_test_func_iterator in ${unit_test_func_arr[*]}  
do  
	print_head $LEVEL_INFO "list $unit_test_func_index: ${unit_test_func_iterator} begin...\n"
	${unit_test_func_iterator}
	if [ $? -eq $FALSE ];then
		print_head $LEVEL_ERROR "list $unit_test_func_index: ${unit_test_func_iterator} failed!!!\n\n"
		exit $FALSE
	else
		print_head $LEVEL_INFO "list $unit_test_func_index: ${unit_test_func_iterator} passed...\n\n"
	fi
	
	let unit_test_func_index=$unit_test_func_index+1
done 


show_sh_end_banner

exit $TRUE