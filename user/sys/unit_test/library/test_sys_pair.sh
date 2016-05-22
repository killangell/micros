#!/bin/sh

source sys_debug.sh
source sys_pair.sh


PAIR_UNIT_TEST_DIR="$SYS_LOG_DIR/unit_test/library"
mkdir -p $PAIR_UNIT_TEST_DIR

function test_setup()
{
	SYS_PAIR_TEST_FILE="$PAIR_UNIT_TEST_DIR/$0.test"

echo "AAA=111
BBB=222
CCC=333" > $SYS_PAIR_TEST_FILE	

	return $TRUE
}

#set -xv
#@out 1: true(1)/false(0)
function test_pair_get_key_index()
{
	pair_get_key_index $SYS_PAIR_TEST_FILE "AAA" index
	source assert_int_ex $index 1 $FUNCNAME	
	
	pair_get_key_index $SYS_PAIR_TEST_FILE "BBB" index
	source assert_int_ex $index 2 $FUNCNAME	
	
	pair_get_key_index $SYS_PAIR_TEST_FILE "CCC" index
	source assert_int_ex $index 3 $FUNCNAME
	
	return $TRUE 
}

#set -xv
#@out 1: true(1)/false(0)
function test_pair_add_node()
{
	#set -x
	pair_add_node $SYS_PAIR_TEST_FILE "DDD" "444"	
	pair_get_key_index $SYS_PAIR_TEST_FILE "DDD" index
	source assert_int_ex $index 4 $FUNCNAME
	#set +x
	
	return $TRUE 
}

function test_pair_get_value_by_key()
{
	expect="111"
	pair_get_value_by_key $SYS_PAIR_TEST_FILE "AAA" real
	assert_str_ex $expect $real $FUNCNAME
	
	return $TRUE 
}

#Test list
test_pair_func_arr=(
	test_setup
	test_pair_get_key_index
	test_pair_add_node
	test_pair_get_value_by_key
)

source sys_loop_array_and_exec.sh ${test_pair_func_arr[*]}

exit $TRUE