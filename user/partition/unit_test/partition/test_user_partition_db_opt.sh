#!/bin/sh

source sys_debug.sh
source user_partition_db_opt.sh


UNIT_TEST_DIR="$SYS_LOG_DIR/unit_test/partition"
mkdir -p $UNIT_TEST_DIR

#set -xv

#return: true(1)/false(0)
function test_user_partition_get_isodev_index_1()
{
	PARTITION_DB_FILE=$UNIT_TEST_DIR/$FUNCNAME.input
echo "boot:200M:disk:ext4
swap:?:lvm:ext4
root:1G:lvm:ext4
var:1G:lvm:ext4
home:1G:lvm:ext4
tmp:0:lvm:ext4
opt:1G:lvm:ext4
usr:1G:lvm:ext4
data:max:lvm:ext4" > $PARTITION_DB_FILE

	expect=3
	real=0
	
	user_partition_get_isodev_index real
	source assert_int_ex $expect $real $FUNCNAME
	
	return $TRUE
}

#return: true(1)/false(0)
function test_user_partition_get_isodev_index_2()
{
	PARTITION_DB_FILE=$UNIT_TEST_DIR/$FUNCNAME.input
echo "efi:100M:disk:vfat
boot:200M:disk:ext4
swap:?:lvm:ext4
root:1G:lvm:ext4
var:1G:lvm:ext4
home:1G:lvm:ext4
tmp:0:lvm:ext4
opt:1G:lvm:ext4
usr:1G:lvm:ext4
data:max:lvm:ext4" > $PARTITION_DB_FILE

	expect=4
	real=0
	
	user_partition_get_isodev_index real
	source assert_int_ex $expect $real $FUNCNAME
	
	return $TRUE
}

#return: true(1)/false(0)
function test_user_partition_get_isodev_index_3()
{
	PARTITION_DB_FILE=$UNIT_TEST_DIR/$FUNCNAME.input
echo "efi:100M:disk:vfat
boot:200M:disk:ext4
swap:?:disk:ext4
root:1G:lvm:ext4
var:1G:lvm:ext4
home:1G:lvm:ext4
tmp:0:lvm:ext4
opt:1G:lvm:ext4
usr:1G:lvm:ext4
data:max:lvm:ext4" > $PARTITION_DB_FILE

	expect=5
	real=0
	
	user_partition_get_isodev_index real
	source assert_int_ex $expect $real $FUNCNAME
	
	return $TRUE
}

#return: true(1)/false(0)
function test_user_partition_get_isodev_index_4()
{
	PARTITION_DB_FILE=$UNIT_TEST_DIR/$FUNCNAME.input
echo "efi:100M:disk:vfat
boot:200M:disk:ext4
swap:?:disk:ext4
root:1G:disk:ext4
var:1G:lvm:ext4
home:1G:lvm:ext4
tmp:0:lvm:ext4
opt:1G:lvm:ext4
usr:1G:lvm:ext4
data:max:lvm:ext4" > $PARTITION_DB_FILE

	expect=6
	real=0
	
	user_partition_get_isodev_index real
	source assert_int_ex $expect $real $FUNCNAME
	
	return $TRUE
}

#return: true(1)/false(0)
function test_user_partition_get_isodev_index_5()
{
	PARTITION_DB_FILE=$UNIT_TEST_DIR/$FUNCNAME.input
echo "efi:100M:disk:vfat
boot:200M:disk:ext4
swap:?:disk:ext4
root:1G:disk:ext4
var:1G:disk:ext4
home:1G:disk:ext4
tmp:10G:disk:ext4
opt:1G:disk:ext4
usr:1G:disk:ext4" > $PARTITION_DB_FILE

	expect=10
	real=0
	
	user_partition_get_isodev_index real
	source assert_int_ex $expect $real $FUNCNAME
	
	return $TRUE
}

#Test list
test_user_partition_db_opt_func_arr=(
	test_user_partition_get_isodev_index_1
	test_user_partition_get_isodev_index_2
	test_user_partition_get_isodev_index_3
	test_user_partition_get_isodev_index_4
	test_user_partition_get_isodev_index_5
)

source sys_loop_array_and_exec.sh ${test_user_partition_db_opt_func_arr[*]}

exit $TRUE

