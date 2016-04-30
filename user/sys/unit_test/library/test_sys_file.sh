source sys_debug.sh
source sys_file.sh


#Global define, should be unique in system
test_file_func_index="null"
test_file_func_arr="null"
test_file_func_iterator="null"

FILE_UNIT_TEST_DIR="$SYS_LOG_DIR/temp"
mkdir -p $FILE_UNIT_TEST_DIR

#set -xv
#@out 1: true(1)/false(0)
function test_is_file_exist_1()
{
	test_file=$RUNNING_DIR/file.is_file_exist
	
	rm -rf $test_file
	is_file_exist $test_file
	if [ $? -ne 0 ];then
		return $FALSE 
	fi
	
	return $TRUE 
}

#@out 1: true(1)/false(0)
function test_is_file_exist_2()
{
	test_file=$RUNNING_DIR/file.is_file_exist
	
	touch $test_file
	is_file_exist $test_file
	if [ $? -ne 1 ];then
		return $FALSE 
	fi
	
	return $TRUE 
}

#@out 1: true(1)/false(0)
function test_is_useless_line()
{
	line="#This is a useless line"
	expect_result=1
	
	is_useless_line $line
	if [ $? -ne $expect_result ];then
		return $FALSE 
	fi
	
	
	line=""
	expect_result=1
	
	is_useless_line $line
	if [ $? -ne $expect_result ];then
		return $FALSE 
	fi
	
	line="\n"
	expect_result=1
	
	is_useless_line $line
	if [ $? -ne $expect_result ];then
		return $FALSE 
	fi
	
	line="This is a useful line"
	expect_result=0
	
	is_useless_line $line
	if [ $? -ne $expect_result ];then
		return $FALSE 
	fi
	
	return $TRUE
}

#Test list
test_file_func_arr=(
	test_is_file_exist_1
	test_is_file_exist_2
	test_is_useless_line
)

function test_file_all_funcs()
{
	test_file_func_index=1
	
	for test_file_func_iterator in ${test_file_func_arr[*]}  
	do  
		print_head LEVEL_INFO "func $test_file_func_index: ${test_file_func_iterator}"
		${test_file_func_iterator}
		if [ $? -eq 0 ];then
			print_body LEVEL_INFO " ... failed\n"
			return $FALSE
		else
			print_body LEVEL_INFO " ... passed\n"
		fi
		
		let test_file_func_index=$test_file_func_index+1
	done 
	
	return $TRUE
}

