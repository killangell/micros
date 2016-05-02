#!/bin/sh

export PATH=$PATH:./

source sys_debug.sh
source test_ks_template_handler.sh

#Global define, should be unique in system
unit_test_func_index="null"
unit_test_func_arr="null"
unit_test_func_iterator="null"

show_sh_begin_banner

#Test list
unit_test_func_arr=(
	test_ks_template_handler_all_funcs
)

unit_test_func_index=1
for unit_test_func_iterator in ${unit_test_func_arr[*]}  
do  
	print_head $LEVEL_INFO "list $unit_test_func_index: ${unit_test_func_iterator} begin...\n"
	${unit_test_func_iterator}
	if [ $? -eq $FALSE ];then
		print_head $LEVEL_INFO "list $unit_test_func_index: ${unit_test_func_iterator} failed!!!\n\n"
		exit $FALSE
	else
		print_head ERROR_INFO "list $unit_test_func_index: ${unit_test_func_iterator} passed...\n\n"
	fi
	
	let unit_test_func_index=$unit_test_func_index+1
done 


show_sh_end_banner

exit $TRUE