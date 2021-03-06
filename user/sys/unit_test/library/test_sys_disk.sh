source sys_debug.sh
source sys_disk.sh

DISK_UNIT_TEST_DIR="$SYS_LOG_DIR/unit_test/library"
mkdir -p $DISK_UNIT_TEST_DIR

#set -xv
#@out 1: true(1)/false(0)
function test_parse_disk_size_string_1()
{
echo "Model: VMware, VMware Virtual S (scsi)
Disk /dev/sda: 21.5GB
Sector size (logical/physical): 512B/512B
Partition Table: gpt

Number  Start   End     Size    File system  Name     Flags
 1      17.4kB  300MB   300MB                primary
 2      300MB   600MB   300MB                primary
 3      15.0GB  21.5GB  6474MB               primary
" > $DISK_UNIT_TEST_DIR/$FUNCNAME.test
	expect_size="21"
	expect_unit="GB"	
	real_size="null"
	real_unit="null"
	
	parse_disk_size_file $DISK_UNIT_TEST_DIR/$FUNCNAME.test real_size real_unit
	#printf "  %s  " "$real_size,$real_unit"
	if [ $real_size != $expect_size ];then
		return $FALSE 
	fi
	if [ $real_unit != $expect_unit ];then
		return $FALSE 
	fi
	
	return $TRUE 
}

#@out 1: true(1)/false(0)
function test_parse_disk_size_string_2()
{
echo "Model: VMware, VMware Virtual S (scsi)
Disk /dev/sda: 500MB
Sector size (logical/physical): 512B/512B
Partition Table: gpt

Number  Start   End     Size    File system  Name     Flags
 1      17.4kB  300MB   300MB                primary
 2      300MB   600MB   300MB                primary
 3      15.0GB  21.5GB  6474MB               primary
" > $DISK_UNIT_TEST_DIR/$FUNCNAME.test
	expect_size="500"
	expect_unit="MB"	
	real_size="null"
	real_unit="null"
	
	parse_disk_size_file $DISK_UNIT_TEST_DIR/$FUNCNAME.test real_size real_unit
	if [ $real_size != $expect_size ];then
		return $FALSE 
	fi
	if [ $real_unit != $expect_unit ];then
		return $FALSE 
	fi
	
	return $TRUE 
}

#@out 1: true(1)/false(0)
function test_get_memory_size()
{
	mem_size="null"
	mem_unit="null"
	
	get_memory_size mem_size mem_unit
	printf "  %s  " "$mem_size,$mem_unit"
	
	source nassert_str_ex $mem_size "null" "$FUNCNAME:mem_size"
	source nassert_str_ex $mem_unit "null" "$FUNCNAME:mem_unit"
	
	return $TRUE
}

function test_get_disk_partition_count()
{
	drive_name="sda"
	partition_count="null"
	
	get_disk_partition_count $drive_name partition_count
	
	#printf "  %s  " "$drive_name,$partition_count"
	
	return $TRUE
}

function test_parse_disk_partition_count_from_cmd()
{
echo "Model: VMware, VMware Virtual S (scsi)
Disk /dev/sda: 21.5GB
Sector size (logical/physical): 512B/512B
Partition Table: gpt

Number  Start   End     Size    File system  Name     Flags
 1      17.4kB  300MB   300MB                primary
 2      300MB   600MB   300MB                primary
 3      15.0GB  21.5GB  6474MB               primary
" > $DISK_UNIT_TEST_DIR/$FUNCNAME.test

	cmd="cat $DISK_UNIT_TEST_DIR/$FUNCNAME.test"
	expect=3
	real="null"
	
	parse_disk_partition_count_from_cmd "$cmd" real
	if [ $expect -ne $real ];then
		return $FALSE
	fi
	
	return $TRUE
}

function test_get_disk_partition_end_size()
{
	drive_name="sda"
	partition_count="null"
	partition_index="null"
	end_size="null"
	
	get_disk_partition_count $drive_name partition_count
	
	for((i=1;i<=$partition_count;i++));do
		partition_index=$i
		get_disk_partition_end_size $drive_name $partition_index end_size
		#printf "  %s  " "$drive_name,$partition_index,$end_size"
	done
	
	return $TRUE
}

function test_parse_disk_partition_end_size_from_cmd()
{
echo "Model: VMware, VMware Virtual S (scsi)
Disk /dev/sda: 21.5GB
Sector size (logical/physical): 512B/512B
Partition Table: gpt

Number  Start   End     Size    File system  Name     Flags
 1      17.4kB  300MB   300MB                primary
 2      300MB   600MB   300MB                primary
 3      15.0GB  21.5GB  6474MB               primary
" > $DISK_UNIT_TEST_DIR/$FUNCNAME.test

	cmd="cat $DISK_UNIT_TEST_DIR/$FUNCNAME.test"
	
	partition_index=1
	expect="300MB"
	real="null"	
	parse_disk_partition_end_size_from_cmd "$cmd" "$partition_index" real	
	if [ $expect != $real ];then
		return $FALSE
	fi
	
	partition_index=2
	expect="600MB"
	real="null"	
	parse_disk_partition_end_size_from_cmd "$cmd" "$partition_index" real	
	if [ $expect != $real ];then
		return $FALSE
	fi
	
	partition_index=3
	expect="21.5GB"
	real="null"	
	parse_disk_partition_end_size_from_cmd "$cmd" "$partition_index" real	
	if [ $expect != $real ];then
		return $FALSE
	fi
	
	return $TRUE
}

function test_parse_pv_size_from_cmd_1()
{
echo "  --- Physical volume ---
  PV Name               /dev/sda2
  VG Name               VolGroup
  PV Size               499.51 GiB / not usable 3.00 MiB
  Allocatable           yes (but full)
  PE Size               4.00 MiB
  Total PE              127874
  Free PE               0
  Allocated PE          127874
  PV UUID               VQsj11-jRL7-kOz1-8s2U-h9uG-gtA5-1BS95b" > $DISK_UNIT_TEST_DIR/$FUNCNAME.test

	cmd="cat $DISK_UNIT_TEST_DIR/$FUNCNAME.test"
  	drive_name="sda"	
	partition_index=2
	expect_size="499"
	expect_unit="GiB"
	real_size="null"	
	real_unit="null"
	device_name="$drive_name$partition_index"
	
	parse_pv_size_from_cmd "$cmd" $device_name real_size real_unit
	
	source assert_str "$expect_size" "$real_size"
	source assert_str "$expect_unit" "$real_unit"
	
	return $TRUE
}

# function test_parse_pv_size_from_cmd_2()
# {
# echo "  --- Physical volume ---
  # PV Name               /dev/sda2
  # VG Name               vg0
  # PV Size               5.45 TiB / not usable 2.20 MiB
  # Allocatable           yes (but full)
  # PE Size               4.00 MiB
  # Total PE              1428684
  # Free PE               0
  # Allocated PE          1428684
  # PV UUID               3J0OK5-AuG2-BV9e-irh7-QCPR-fMc3-sAv38M" > $DISK_UNIT_TEST_DIR/$FUNCNAME.test

	# cmd="cat $DISK_UNIT_TEST_DIR/$FUNCNAME.test"
  	# drive_name="sda"	
	# partition_index=2
	# expect_size="499"
	# expect_unit="GiB"
	# real_size="null"	
	# real_unit="null"
	# device_name="$drive_name$partition_index"
	
	# parse_pv_size_from_cmd "$cmd" $device_name real_size real_unit
	
	# source assert_str "$expect_size" "$real_size"
	# source assert_str "$expect_unit" "$real_unit"
	
	# return $TRUE
# }

#Test list
test_disk_func_arr=(
	test_parse_disk_size_string_1
	#test_parse_disk_size_string_2 ###???
	test_get_memory_size
	test_get_disk_partition_count
	test_parse_disk_partition_count_from_cmd
	test_get_disk_partition_end_size
	test_parse_disk_partition_end_size_from_cmd
	test_parse_pv_size_from_cmd_1
	#test_parse_pv_size_from_cmd_2
)

source sys_loop_array_and_exec.sh ${test_disk_func_arr[*]}

exit $TRUE
