source sys_debug.sh
source sys_common.sh


FILE_UNIT_TEST_DIR="$SYS_LOG_DIR/unit_test/library"
mkdir -p $FILE_UNIT_TEST_DIR

#set -xv
#@out 1: true(1)/false(0)
function test_is_cmd_exist()
{
	local cmd="null"
	result="null"
	
	is_cmd_exist "ls" result
	source assert_int_ex $result $TRUE "$FUNCNAME:ls"
	
	is_cmd_exist "lssss" result
	source assert_int_ex $result $FALSE "$FUNCNAME:lssss"
	
	return $TRUE
}

#Test list
test_common_func_arr=(
	test_is_cmd_exist
)

source sys_loop_array_and_exec.sh ${test_common_func_arr[*]}

exit $TRUE
