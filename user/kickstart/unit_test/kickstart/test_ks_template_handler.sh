#!/bin/sh

source sys_debug.sh
source ks_template_handler.sh


KICKSTART_UNIT_TEST_DIR="$SYS_LOG_DIR/unit_test/kickstart"
mkdir -p $KICKSTART_UNIT_TEST_DIR


test_ks_file=$KICKSTART_UNIT_TEST_DIR/ks.cfg.test
test_source_bootloader=$KICKSTART_UNIT_TEST_DIR/source_bootloader.test
test_source_harddrive=$KICKSTART_UNIT_TEST_DIR/source_harddrive.test
test_source_partition=$KICKSTART_UNIT_TEST_DIR/source_partition.test
function test_ks_template_handler_init()
{ 
rm -rf $test_ks_file
rm -rf $test_source_bootloader
rm -rf $test_source_harddrive
rm -rf $test_source_partition

echo "#harddrive
#bootloader
#partition" >> $test_ks_file

echo "bootloader --location=partition --driveorder=sda --append=\"crashkernel=auto rhgb quiet\"" >> $test_source_bootloader

echo "harddrive --partition=sda3 --dir=" >> $test_source_harddrive

echo "clearpart --all --drives=sda
ignoredisk --only-use=sda
part /boot --fstype ext4 --asprimary --size=200M
part pv.008019 --grow --size=1
volgroup vg0 --pesize=4096 pv.008019
logvol swap --vgname=vg0 --size=2048M --name=lv_swap
logvol / --vgname=vg0 --size=1G --name=lv_root
logvol /var --vgname=vg0 --size=1G --name=lv_var
logvol /home --vgname=vg0 --size=1G --name=lv_home
logvol /opt --vgname=vg0 --size=1G --name=lv_opt
logvol /usr --vgname=vg0 --size=1G --name=lv_usr
logvol /data--vgname=vg0 --size=1 --grow --name=lv_data" >> $test_source_partition
}

function test_replace_bootloader()
{
	rm -rf $test_source_bootloader.expect.test
	test_ks_template_handler_init
	
echo "#harddrive
bootloader --location=partition --driveorder=sda --append=\"crashkernel=auto rhgb quiet\"
#partition" >> $test_source_bootloader.expect.test

	key="#bootloader"
	source_file=$test_source_bootloader
	ks_file=$test_ks_file
	ks_replace_key_by_file $key $source_file $ks_file

	diff $ks_file $test_source_bootloader.expect.test > /dev/null
	if [ $? -ne $FALSE ];then
		return $FALSE
	fi
	return $TRUE
}

function test_set_bootloader_script()
{
	rm -rf $test_source_bootloader.expect.test
	test_ks_template_handler_init
	
echo "#harddrive
bootloader --location=partition --driveorder=sda --append=\"crashkernel=auto rhgb quiet\"
#partition" >> $test_source_bootloader.expect.test

	source_file=$test_source_bootloader
	ks_file=$test_ks_file
	sh ks_set_bootloader.sh $source_file $ks_file

	diff $ks_file $test_source_bootloader.expect.test > /dev/null
	if [ $? -ne $FALSE ];then
		return $FALSE
	fi
	return $TRUE
}

function test_replace_harddrive()
{
	rm -rf $test_source_harddrive.expect.test
	test_ks_template_handler_init
	
echo "harddrive --partition=sda3 --dir=
#bootloader
#partition">> $test_source_harddrive.expect.test

	key="#harddrive"
	source_file=$test_source_harddrive
	ks_file=$test_ks_file
	ks_replace_key_by_file $key $source_file $ks_file

	diff $ks_file $test_source_harddrive.expect.test > /dev/null
	if [ $? -ne $FALSE ];then
		return $FALSE
	fi
	return $TRUE
}

function test_set_harddrive_script()
{
	rm -rf $test_source_harddrive.expect.test
	test_ks_template_handler_init
	
echo "harddrive --partition=sda3 --dir=
#bootloader
#partition">> $test_source_harddrive.expect.test

	source_file=$test_source_harddrive
	ks_file=$test_ks_file
	sh ks_set_harddrive.sh $source_file $ks_file

	diff $ks_file $test_source_harddrive.expect.test > /dev/null
	if [ $? -ne $FALSE ];then
		return $FALSE
	fi
	return $TRUE
}

function test_replace_partition()
{
	rm -rf $test_source_partition.expect.test
	test_ks_template_handler_init
	
echo "#harddrive
#bootloader
clearpart --all --drives=sda
ignoredisk --only-use=sda
part /boot --fstype ext4 --asprimary --size=200M
part pv.008019 --grow --size=1
volgroup vg0 --pesize=4096 pv.008019
logvol swap --vgname=vg0 --size=2048M --name=lv_swap
logvol / --vgname=vg0 --size=1G --name=lv_root
logvol /var --vgname=vg0 --size=1G --name=lv_var
logvol /home --vgname=vg0 --size=1G --name=lv_home
logvol /opt --vgname=vg0 --size=1G --name=lv_opt
logvol /usr --vgname=vg0 --size=1G --name=lv_usr
logvol /data--vgname=vg0 --size=1 --grow --name=lv_data">> $test_source_partition.expect.test

	key="#partition"
	source_file=$test_source_partition
	ks_file=$test_ks_file
	ks_replace_key_by_file $key $source_file $ks_file

	diff $ks_file $test_source_partition.expect.test > /dev/null
	if [ $? -ne $FALSE ];then
		return $FALSE
	fi
	return $TRUE
}

function test_set_partition_script()
{
	rm -rf $test_source_partition.expect.test
	test_ks_template_handler_init
	
echo "#harddrive
#bootloader
clearpart --all --drives=sda
ignoredisk --only-use=sda
part /boot --fstype ext4 --asprimary --size=200M
part pv.008019 --grow --size=1
volgroup vg0 --pesize=4096 pv.008019
logvol swap --vgname=vg0 --size=2048M --name=lv_swap
logvol / --vgname=vg0 --size=1G --name=lv_root
logvol /var --vgname=vg0 --size=1G --name=lv_var
logvol /home --vgname=vg0 --size=1G --name=lv_home
logvol /opt --vgname=vg0 --size=1G --name=lv_opt
logvol /usr --vgname=vg0 --size=1G --name=lv_usr
logvol /data--vgname=vg0 --size=1 --grow --name=lv_data">> $test_source_partition.expect.test

	source_file=$test_source_partition
	ks_file=$test_ks_file
	sh ks_set_partition.sh $source_file $ks_file

	diff $ks_file $test_source_partition.expect.test > /dev/null
	if [ $? -ne $FALSE ];then
		return $FALSE
	fi
	return $TRUE
}

function test_insert_after_harddrive()
{
	rm -rf $test_source_harddrive.expect.test
	test_ks_template_handler_init
	
echo "#harddrive
harddrive --partition=sda3 --dir=
#bootloader
#partition">> $test_source_harddrive.expect.test

	key="#harddrive"
	source_file=$test_source_harddrive
	ks_file=$test_ks_file
	ks_insert_file_after_key $key $source_file $ks_file

	diff $ks_file $test_source_harddrive.expect.test > /dev/null
	if [ $? -ne $FALSE ];then
		return $FALSE
	fi
	return $TRUE
}

function test_insert_after_bootloader()
{
	rm -rf $test_source_bootloader.expect.test
	test_ks_template_handler_init
	
echo "#harddrive
#bootloader
bootloader --location=partition --driveorder=sda --append=\"crashkernel=auto rhgb quiet\"
#partition">> $test_source_bootloader.expect.test

	key="#bootloader"
	source_file=$test_source_bootloader
	ks_file=$test_ks_file
	ks_insert_file_after_key $key $source_file $ks_file

	diff $ks_file $test_source_bootloader.expect.test > /dev/null
	if [ $? -ne $FALSE ];then
		return $FALSE
	fi
	return $TRUE
}

#Test list
test_ks_template_handler_func_arr=(
	test_replace_bootloader
	test_set_bootloader_script
	test_replace_harddrive
	test_set_harddrive_script
	test_replace_partition
	test_set_partition_script
	test_insert_after_harddrive
	test_insert_after_bootloader
)

source sys_loop_array_and_exec.sh ${test_ks_template_handler_func_arr[*]}

exit $TRUE
