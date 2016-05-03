source sys_debug.sh
source sys_file.sh


FILE_UNIT_TEST_DIR="$SYS_LOG_DIR/unit_test/library"
mkdir -p $FILE_UNIT_TEST_DIR

#set -xv
#@out 1: true(1)/false(0)
function test_is_file_exist_1()
{
	test_file=$FILE_UNIT_TEST_DIR/file.is_file_exist
	
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
	test_file=$FILE_UNIT_TEST_DIR/file.is_file_exist
	
	touch $test_file
	is_file_exist $test_file
	if [ $? -ne 1 ];then
		return $FALSE 
	fi
	
	return $TRUE 
}

#@out 1: true(1)/false(0)
function test_dbg_wr2file_ln()
{
	expect_file=$FILE_UNIT_TEST_DIR/$FUNCNAME.expect1
	real_file=$FILE_UNIT_TEST_DIR/$FUNCNAME.real1
	
	string="bootloader --location=mbr --driveorder=$dest_drive --append=\"crashkernel=auto rhgb quiet\""
	echo "$string" > $expect_file	
	#string="bootloader --location=mbr --driveorder=$dest_drive --append=\\\"crashkernel=auto rhgb quiet\\\""
	dbg_wr2file_ln "$string" "$real_file" $LEVEL_NONE
	
	diff $expect_file $real_file > /dev/null
	if [ $? -ne 0 ];then
		return $FALSE
	fi
	
	return $TRUE
}

#Test list
test_file_func_arr=(
	test_is_file_exist_1
	test_is_file_exist_2
	test_dbg_wr2file_ln
)

source sys_loop_array_and_exec.sh ${test_file_func_arr[*]}

exit $TRUE
