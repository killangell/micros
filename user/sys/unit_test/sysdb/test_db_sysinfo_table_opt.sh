#!/bin/sh

source sys_debug.sh
source db_sysinfo_table_opt.sh

SYSINFO_DB_UNIT_TEST_DIR="$SYS_LOG_DIR/unit_test/sysdb"
mkdir -p $SYSINFO_DB_UNIT_TEST_DIR

function test_setup()
{
	SYSINFO_DB_FILE="$SYSINFO_DB_UNIT_TEST_DIR/test_sysinfo_db_file"

echo "dest_drive=hda
os_vendor=rhel
os_version=7.0
ks_unsupported_hardware_ability=y" > $SYSINFO_DB_FILE
	
	return $TRUE
}

function test_db_get_sysinfo_dest_drive()
{
	expect="hda"
	real="null"

	db_get_sysinfo_dest_drive real
	source assert_str $expect $real

	return $TRUE
}

function test_db_set_sysinfo_dest_drive()
{
	expect="abc"
	real="null"

	db_set_sysinfo_dest_drive $expect
	db_get_sysinfo_dest_drive real
	source assert_str $expect $real
	
	return $TRUE
}


function test_db_get_sysinfo_os_vendor()
{
	expect="rhel"
	real="null"

	db_get_sysinfo_os_vendor real	
	source assert_str $expect $real

	return $TRUE
}

function test_db_set_sysinfo_os_vendor()
{
	expect="abc"
	real="null"

	db_set_sysinfo_os_vendor $expect
	db_get_sysinfo_os_vendor real
	source assert_str $expect $real
	
	return $TRUE
}

function test_db_get_sysinfo_os_version()
{
	expect="7.0"
	real="null"

	db_get_sysinfo_os_version real	
	source assert_str $expect $real

	return $TRUE
}

function test_db_set_sysinfo_os_version()
{
	expect="abc"
	real="null"

	db_set_sysinfo_os_version $expect
	db_get_sysinfo_os_version real
	source assert_str $expect $real
	
	return $TRUE
}

function test_db_get_sysinfo_ks_unsupported_hardware_ability()
{
	expect="y"
	real="null"

	db_get_sysinfo_ks_unsupported_hardware_ability real	
	source assert_str $expect $real

	return $TRUE
}

function test_db_set_sysinfo_ks_unsupported_hardware_ability()
{
	expect="abc"
	real="null"

	db_set_sysinfo_ks_unsupported_hardware_ability $expect
	db_get_sysinfo_ks_unsupported_hardware_ability real
	#echo real=$real
	source assert_str $expect $real
	
	return $TRUE
}

#Test list
test_sysinfo_opt_func_arr=(
	test_setup
	test_db_get_sysinfo_dest_drive
	test_db_set_sysinfo_dest_drive
	test_db_get_sysinfo_os_vendor
	test_db_set_sysinfo_os_vendor
	test_db_get_sysinfo_os_version
	test_db_set_sysinfo_os_version
	test_db_get_sysinfo_ks_unsupported_hardware_ability
	test_db_set_sysinfo_ks_unsupported_hardware_ability
)

source sys_loop_array_and_exec.sh ${test_sysinfo_opt_func_arr[*]}

exit $TRUE
