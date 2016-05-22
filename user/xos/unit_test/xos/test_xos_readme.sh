source sys_debug.sh
source xos_readme.sh

XOS_UNIT_TEST_DIR="$SYS_LOG_DIR/unit_test/xos"
mkdir -p $XOS_UNIT_TEST_DIR

XOS_README="null"

function test_setup()
{
	XOS_README="$XOS_UNIT_TEST_DIR/test_xos_readme"
	
echo "#Common
vendor=redhat
version=6.8
#Kickstart
is_support_unsupported_hardware=Y" > $XOS_README
	
	return $TRUE
}

#set -xv
#@out 1: true(1)/false(0)
function test_parse_xos_readme_file_by_key_1()
{	
	key="vendor"
	
	value_expect="redhat"
	value_real="null"
	result_expect=$TRUE
	result_real=$FALSE
	
	parse_xos_readme_file_by_key $XOS_README "$key" value_real result_real
	#set -x
	source assert_str_ex $value_expect $value_real "$FUNCNAME"
	source assert_int_ex $result_expect $result_real "$FUNCNAME"
	#set +x
	return $TRUE 
}
function test_parse_xos_readme_file_by_key_2()
{	
	key="version"
	
	value_expect="6.8"
	value_real="null"
	result_expect=$TRUE
	result_real=$FALSE
	
	parse_xos_readme_file_by_key $XOS_README "$key" value_real result_real
	
	source assert_str_ex "$value_expect" "$value_real" "$FUNCNAME"
	source assert_int_ex $result_expect $result_real "$FUNCNAME"
	
	return $TRUE 
}
function test_parse_xos_readme_file_by_key_3()
{	
	key="is_support_unsupported_hardware"
	
	value_expect="Y"
	value_real="null"
	result_expect=$TRUE
	result_real=$FALSE
	
	parse_xos_readme_file_by_key $XOS_README "$key" value_real result_real
	
	source assert_str_ex "$value_expect" "$value_real" "$FUNCNAME"
	source assert_int_ex $result_expect $result_real "$FUNCNAME"
	
	return $TRUE 
}

function test_get_xos_value_by_key_1()
{
	key="vendor"
	
	value_expect="redhat"
	value_real="null"
	result_expect=$TRUE
	result_real=$FALSE
	
	get_xos_value_by_key "$key" value_real result_real
	
	source assert_str_ex "$value_expect" "$value_real" "$FUNCNAME"
	source assert_int_ex $result_expect $result_real "$FUNCNAME"
	
	return $TRUE 
}

function test_get_xos_value_by_key_2()
{
	key="version"
	
	value_expect="6.8"
	value_real="null"
	result_expect=$TRUE
	result_real=$FALSE
	
	get_xos_value_by_key "$key" value_real result_real
	
	source assert_str_ex "$value_expect" "$value_real" "$FUNCNAME"
	source assert_int_ex $result_expect $result_real "$FUNCNAME"
	
	return $TRUE 
}

function test_get_xos_value_by_key_3()
{
	key="is_support_unsupported_hardware"
	
	value_expect="Y"
	value_real="null"
	result_expect=$TRUE
	result_real=$FALSE
	
	get_xos_value_by_key "$key" value_real result_real
	
	source assert_str_ex "$value_expect" "$value_real" "$FUNCNAME"
	source assert_int_ex $result_expect $result_real "$FUNCNAME"
	
	return $TRUE 
}

function test_get_xos_vendor()
{
	value_expect="redhat"
	value_real="null"
	result_expect=$TRUE
	result_real=$FALSE
	
	get_xos_vendor value_real result_real
	
	source assert_str_ex "$value_expect" "$value_real" "$FUNCNAME"
	source assert_int_ex $result_expect $result_real "$FUNCNAME"
	
	return $TRUE 
}

function test_get_xos_version()
{
	value_expect="6.8"
	value_real="null"
	result_expect=$TRUE
	result_real=$FALSE
	
	get_xos_version value_real result_real
	
	source assert_str_ex "$value_expect" "$value_real" "$FUNCNAME"
	source assert_int_ex $result_expect $result_real "$FUNCNAME"
	
	return $TRUE 
}

function test_get_xos_ks_is_unsupported_hardware()
{
	value_expect="Y"
	value_real="null"
	result_expect=$TRUE
	result_real=$FALSE
	
	get_xos_ks_is_unsupported_hardware value_real result_real
	
	source assert_str_ex "$value_expect" "$value_real" "$FUNCNAME"
	source assert_int_ex $result_expect $result_real "$FUNCNAME"
	
	return $TRUE 
}

function test_is_unsupported_hardware()
{
	result_expect=$TRUE
	result_real=$FALSE
	
	is_unsupported_hardware result_real
	#echo xx11--result_expect=$result_expect,result_real=$result_real,
	source assert_int_ex $result_expect $result_real "$FUNCNAME"
	#echo xx22
	return $TRUE 
}

#Test list
test_xos_readme_func_arr=(
	test_setup
	test_parse_xos_readme_file_by_key_1
	test_parse_xos_readme_file_by_key_2
	test_parse_xos_readme_file_by_key_3
	test_get_xos_value_by_key_1
	test_get_xos_value_by_key_2
	test_get_xos_value_by_key_3
	test_get_xos_vendor
	test_get_xos_version
	test_get_xos_ks_is_unsupported_hardware
	test_is_unsupported_hardware
	#test_cleanup
)

source sys_loop_array_and_exec.sh ${test_xos_readme_func_arr[*]}

exit $TRUE
