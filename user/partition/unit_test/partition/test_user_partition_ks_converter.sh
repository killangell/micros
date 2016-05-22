#!/bin/sh

source sys_debug.sh
source user_partition_ks_converter.sh


UNIT_TEST_DIR="$SYS_LOG_DIR/unit_test/partition"
mkdir -p $UNIT_TEST_DIR

#set -xv

function test_convert_user_size_to_ks_partition_size()
{
	user_size="200M"
	expect_num="200"
	real_num="null"
	
	convert_user_size_to_ks_partition_size $user_size real_num
	source assert_int $expect_num $real_num
	
	user_size="20.5M"
	expect_num="20.5"
	real_num="null"
	
	convert_user_size_to_ks_partition_size $user_size real_num
	source assert_str $expect_num $real_num
	
	user_size="10G"
	expect_num="10000"
	real_num="null"
	
	convert_user_size_to_ks_partition_size $user_size real_num
	source assert_int $expect_num $real_num
	
	user_size="12.34G"
	expect_num="12340"
	real_num="null"
	
	convert_user_size_to_ks_partition_size $user_size real_num
	source assert_int $expect_num $real_num
	
	return $TRUE
}

#return: true(1)/false(0)
function test_get_ks_disk_partition_string_1()
{
	name="efi"
	size="200M"
	fs_type="vfat"

	expect="part /boot/efi --fstype=vfat --asprimary --size=200"
	real="null"
	
	get_ks_disk_partition_string $name $size $fs_type real
	#Replace plus to blank space
	real=$(echo $real | sed 's/+/ /g')
	#echo expect=$expect
	#echo real=$real
	
	if [ "$expect" != "$real" ];then
		return $FALSE
	fi
	
	return $TRUE
}

#return: true(1)/false(0)
function test_get_ks_disk_partition_string_2()
{
	name="swap"
	size="2048M"
	fs_type="ext4"

	expect="part swap --asprimary --size=2048"
	real="null"
	
	get_ks_disk_partition_string $name $size $fs_type real
	#Replace plus to blank space
	real=$(echo $real | sed 's/+/ /g')
	
	if [ "$expect" != "$real" ];then
		return $FALSE
	fi
	
	return $TRUE
}

#return: true(1)/false(0)
function test_get_ks_disk_partition_string_3()
{
	name="home"
	size="max"
	fs_type="ext4"

	expect="part /home --fstype=ext4 --asprimary --grow --size=1"
	real="null"
	
	get_ks_disk_partition_string $name $size $fs_type real
	#Replace plus to blank space
	real=$(echo $real | sed 's/+/ /g')
	
	if [ "$expect" != "$real" ];then
		return $FALSE
	fi
	
	return $TRUE
}

#return: true(1)/false(0)
function test_get_ks_lvm_partition_string_1()
{
	name="home"
	lv_name="lv_home"
	size="20G"
	fs_type="ext4"
	vgname="vg0"
	real="null"
	
	expect="logvol /home --fstype=ext4 --vgname=vg0 --size=20000 --name=lv_home"
	real="null"
	
	get_ks_lvm_partition_string $name $size $fs_type $vgname real
	#Replace plus to blank space
	real=$(echo $real | sed 's/+/ /g')
	#echo expect=$expect
	#echo real=$real
	
	if [ "$expect" != "$real" ];then
		return $FALSE
	fi
	
	return $TRUE
}

#return: true(1)/false(0)
function test_get_ks_lvm_partition_string_2()
{
	name="swap"
	lv_name="lv_swap"
	size="2048M"
	fs_type="ext4"
	vgname="vg0"
	real="null"

	expect="logvol swap --vgname=vg0 --size=2048 --name=lv_swap"
	real="null"
	
	get_ks_lvm_partition_string $name $size $fs_type $vgname real
	#Replace plus to blank space
	real=$(echo $real | sed 's/+/ /g')
	#echo expect=$expect
	#echo real=$real
	
	if [ "$expect" != "$real" ];then
		return $FALSE
	fi
	
	return $TRUE
}

#return: true(1)/false(0)
function test_get_ks_lvm_partition_string_3()
{
	name="root"
	lv_name="lv_root"
	size="max"
	fs_type="ext4"
	vgname="vg0"
	real="null"

	expect="logvol / --fstype=ext4 --vgname=vg0 --size=1 --grow --name=lv_root"
	real="null"
	
	get_ks_lvm_partition_string $name $size $fs_type $vgname real
	#Replace plus to blank space
	real=$(echo $real | sed 's/+/ /g')
	
	if [ "$expect" != "$real" ];then
		return $FALSE
	fi
	
	return $TRUE
}

#return: true(1)/false(0)
function test_get_ks_harddrive_string()
{
	iso_loca="sda7"
	real="null"

	expect="harddrive --partition=sda7 --dir="
	real="null"
	
	get_ks_harddrive_string $iso_loca real
	#Replace plus to blank space
	real=$(echo $real | sed 's/+/ /g')
	
	if [ "$expect" != "$real" ];then
		return $FALSE
	fi
	
	return $TRUE
}

#return: true(1)/false(0)
function test_get_ks_bootloader_string()
{
	dest_drive="hda"
	real="null"

	expect="bootloader --location=mbr --driveorder=hda --append=\"crashkernel=auto rhgb quiet\""
	real="null"
	
	get_ks_bootloader_string $dest_drive real
	#Replace plus to blank space
	real=$(echo $real | sed 's/+/ /g')
	#echo expect=$expect
	#echo real=$real
	
	if [ "$expect" != "$real" ];then
		return $FALSE
	fi
	
	return $TRUE
}

function test_get_current_partition_end_size()
{
	start="0M"
	size="200M"
	expect="200M"
	real="null"	
	get_current_partition_end_size $start $size real
	source assert_str_ex $expect $real $FUNCNAME-"1"
		
	start="200M"
	size="200M"
	expect="400M"
	real="null"	
	get_current_partition_end_size $start $size real
	source assert_str_ex $expect $real $FUNCNAME-"2"
	
	start="200M"
	size="2000M"
	expect="2200M"
	real="null"	
	get_current_partition_end_size $start $size real
	source assert_str_ex $expect $real $FUNCNAME-"3"
	#set -x
	start="200M"
	size="0.52G"
	expect="0.72G"
	real="null"	
	get_current_partition_end_size $start $size real
	source assert_str_ex $expect $real $FUNCNAME-"4"
	#set +x
	start="200M"
	size="1.52G"
	expect="1.72G"
	real="null"	
	get_current_partition_end_size $start $size real
	source assert_str_ex $expect $real $FUNCNAME-"5"
	
	start="1.12G"
	size="1.52G"
	expect="2.64G"
	real="null"	
	get_current_partition_end_size $start $size real
	source assert_str_ex $expect $real $FUNCNAME-"6"
	
	return $TRUE
}

#Test list
test_partition_ks_converter_func_arr=(
	test_convert_user_size_to_ks_partition_size
	test_get_ks_disk_partition_string_1
	test_get_ks_disk_partition_string_2
	test_get_ks_disk_partition_string_3
	test_get_ks_lvm_partition_string_1
	test_get_ks_lvm_partition_string_2
	test_get_ks_lvm_partition_string_3
	test_get_ks_harddrive_string
	test_get_ks_bootloader_string
	test_get_current_partition_end_size
)


source sys_loop_array_and_exec.sh ${test_partition_ks_converter_func_arr[*]}

exit $TRUE

