#!/bin/sh

source sys_debug.sh
source db_partition_table_opt.sh

PARTITION_DB_UNIT_TEST_DIR="$SYS_LOG_DIR/unit_test/sysdb"
mkdir -p $PARTITION_DB_UNIT_TEST_DIR

function test_setup()
{
	PARTITION_DB_FILE="$PARTITION_DB_UNIT_TEST_DIR/test_partitioin_db_file"

echo "bios_grub:2M:disk:N/A:N/A:resv2
efi:0:disk:vfat:/boot/efi:resv2
boot:111M:disk:ext4:/boot:resv2
swap:?:lvm:ext4:swap:resv2
root:11G:lvm:ext4:/:resv2
var:12G:lvm:ext4:/var:resv2
home:13G:lvm:ext4:/home:resv2
tmp:0:lvm:ext4:/tmp:resv2
opt:14G:lvm:ext4:/opt:resv2
usr:15G:lvm:ext4:/usr:resv2
data:max:lvm:ext4:/data:resv2" > $PARTITION_DB_FILE

	PARTITION_TEST_GET_SH="$PARTITION_DB_UNIT_TEST_DIR/test_partition_get"
echo "name=\"\$1\"
expect=\"\$2\"
real=\"null\"
get=\$3
assert=\$4
\$get \$name real
source \$assert \$expect \$real \$name-\$get" > $PARTITION_TEST_GET_SH	

	PARTITION_TEST_SET_SH="$PARTITION_DB_UNIT_TEST_DIR/test_partition_set"
echo "name=\"\$1\"
expect=\"\$2\"
real=\"null\"
set=\$3
get=\$4
assert=\$5
\$set \$name \$expect
\$get \$name real
source \$assert \$expect \$real \$name-\$set" > $PARTITION_TEST_SET_SH

	return $TRUE
}

function test_db_get_partition_info()
{
	# name="efi"
	# expect="0"
	# real="null"
	# db_get_partition_size $name real	
	# source assert_str $expect $real
	
	source $PARTITION_TEST_GET_SH "null" 		"0"  db_get_partition_index assert_int_ex
	source $PARTITION_TEST_GET_SH "bios_grub" 	"1"  db_get_partition_index assert_int_ex
	source $PARTITION_TEST_GET_SH "efi"	 		"2"  db_get_partition_index assert_int_ex
	source $PARTITION_TEST_GET_SH "boot" 		"3"  db_get_partition_index assert_int_ex
	source $PARTITION_TEST_GET_SH "swap" 		"4"  db_get_partition_index assert_int_ex
	source $PARTITION_TEST_GET_SH "root" 		"5"  db_get_partition_index assert_int_ex
	source $PARTITION_TEST_GET_SH "var"  		"6"  db_get_partition_index assert_int_ex
	source $PARTITION_TEST_GET_SH "home" 		"7"  db_get_partition_index assert_int_ex
	source $PARTITION_TEST_GET_SH "tmp"  		"8"  db_get_partition_index assert_int_ex
	source $PARTITION_TEST_GET_SH "opt" 		"9"  db_get_partition_index assert_int_ex
	source $PARTITION_TEST_GET_SH "usr"  		"10" db_get_partition_index assert_int_ex
	source $PARTITION_TEST_GET_SH "data" 		"11" db_get_partition_index assert_int_ex
	
	source $PARTITION_TEST_GET_SH "efi"	 "0"    db_get_partition_size assert_str_ex
	source $PARTITION_TEST_GET_SH "boot" "111M" db_get_partition_size assert_str_ex
	source $PARTITION_TEST_GET_SH "swap" "?"    db_get_partition_size assert_str_ex
	source $PARTITION_TEST_GET_SH "root" "11G"  db_get_partition_size assert_str_ex
	source $PARTITION_TEST_GET_SH "var"  "12G"  db_get_partition_size assert_str_ex
	source $PARTITION_TEST_GET_SH "home" "13G"  db_get_partition_size assert_str_ex
	source $PARTITION_TEST_GET_SH "tmp"  "0"    db_get_partition_size assert_str_ex
	source $PARTITION_TEST_GET_SH "opt" "14G"  db_get_partition_size assert_str_ex
	source $PARTITION_TEST_GET_SH "usr"  "15G"  db_get_partition_size assert_str_ex
	source $PARTITION_TEST_GET_SH "data" "max"  db_get_partition_size assert_str_ex
	
	source $PARTITION_TEST_GET_SH "efi"	 "disk" db_get_partition_location assert_str_ex
	source $PARTITION_TEST_GET_SH "boot" "disk" db_get_partition_location assert_str_ex
	source $PARTITION_TEST_GET_SH "swap" "lvm"  db_get_partition_location assert_str_ex
	source $PARTITION_TEST_GET_SH "root" "lvm"  db_get_partition_location assert_str_ex
	source $PARTITION_TEST_GET_SH "var"  "lvm"  db_get_partition_location assert_str_ex
	source $PARTITION_TEST_GET_SH "home" "lvm"  db_get_partition_location assert_str_ex
	source $PARTITION_TEST_GET_SH "tmp"  "lvm"  db_get_partition_location assert_str_ex
	source $PARTITION_TEST_GET_SH "opt" "lvm"  db_get_partition_location assert_str_ex
	source $PARTITION_TEST_GET_SH "usr"  "lvm"  db_get_partition_location assert_str_ex
	source $PARTITION_TEST_GET_SH "data" "lvm"  db_get_partition_location assert_str_ex
	
	source $PARTITION_TEST_GET_SH "efi"	 "vfat"  db_get_partition_filesystem assert_str_ex
	source $PARTITION_TEST_GET_SH "boot" "ext4"  db_get_partition_filesystem assert_str_ex
	source $PARTITION_TEST_GET_SH "swap" "ext4"  db_get_partition_filesystem assert_str_ex
	source $PARTITION_TEST_GET_SH "root" "ext4"  db_get_partition_filesystem assert_str_ex
	source $PARTITION_TEST_GET_SH "var"  "ext4"  db_get_partition_filesystem assert_str_ex
	source $PARTITION_TEST_GET_SH "home" "ext4"  db_get_partition_filesystem assert_str_ex
	source $PARTITION_TEST_GET_SH "tmp"  "ext4"  db_get_partition_filesystem assert_str_ex
	source $PARTITION_TEST_GET_SH "opt" "ext4"  db_get_partition_filesystem assert_str_ex
	source $PARTITION_TEST_GET_SH "usr"  "ext4"  db_get_partition_filesystem assert_str_ex
	source $PARTITION_TEST_GET_SH "data" "ext4"  db_get_partition_filesystem assert_str_ex

	source $PARTITION_TEST_GET_SH "efi"	 "/boot/efi"  db_get_partition_mount_point assert_str_ex
	source $PARTITION_TEST_GET_SH "boot" "/boot"  	  db_get_partition_mount_point assert_str_ex	
	source $PARTITION_TEST_GET_SH "swap" "swap"  	  db_get_partition_mount_point assert_str_ex
	source $PARTITION_TEST_GET_SH "root" "/"  		  db_get_partition_mount_point assert_str_ex
	source $PARTITION_TEST_GET_SH "var"  "/var"  	  db_get_partition_mount_point assert_str_ex
	source $PARTITION_TEST_GET_SH "home" "/home"  	  db_get_partition_mount_point assert_str_ex
	source $PARTITION_TEST_GET_SH "tmp"  "/tmp"  	  db_get_partition_mount_point assert_str_ex
	#set -x	
	source $PARTITION_TEST_GET_SH "opt" "/opt"  	  db_get_partition_mount_point assert_str_ex
	#set +x
	source $PARTITION_TEST_GET_SH "usr"  "/usr"  	  db_get_partition_mount_point assert_str_ex	
	source $PARTITION_TEST_GET_SH "data" "/data"  	  db_get_partition_mount_point assert_str_ex
	
	return $TRUE
}

function test_db_set_partition_info()
{	
	# name="efi"
	# expect="249M"
	# real="null"
	# db_set_partition_size $name $expect
	# db_get_partition_size $name real	
	# source assert_str $expect $real
	
	source $PARTITION_TEST_SET_SH "efi"	 "249M"	 db_set_partition_size db_get_partition_size assert_str_ex
	source $PARTITION_TEST_SET_SH "boot" "1110M" db_set_partition_size db_get_partition_size assert_str_ex
	source $PARTITION_TEST_SET_SH "swap" "??"    db_set_partition_size db_get_partition_size assert_str_ex
	source $PARTITION_TEST_SET_SH "root" "110G"  db_set_partition_size db_get_partition_size assert_str_ex
	source $PARTITION_TEST_SET_SH "var"  "120G"  db_set_partition_size db_get_partition_size assert_str_ex
	source $PARTITION_TEST_SET_SH "home" "130G"  db_set_partition_size db_get_partition_size assert_str_ex
	source $PARTITION_TEST_SET_SH "tmp"  "10M"   db_set_partition_size db_get_partition_size assert_str_ex
	source $PARTITION_TEST_SET_SH "opt" "0" 	 db_set_partition_size db_get_partition_size assert_str_ex
	source $PARTITION_TEST_SET_SH "usr"  "max" 	 db_set_partition_size db_get_partition_size assert_str_ex
	source $PARTITION_TEST_SET_SH "data" "0" 	 db_set_partition_size db_get_partition_size assert_str_ex
	
	source $PARTITION_TEST_SET_SH "efi"	 "lvm"   db_set_partition_location db_get_partition_location assert_str_ex
	source $PARTITION_TEST_SET_SH "boot" "lvm"   db_set_partition_location db_get_partition_location assert_str_ex
	source $PARTITION_TEST_SET_SH "swap" "disk"  db_set_partition_location db_get_partition_location assert_str_ex
	source $PARTITION_TEST_SET_SH "root" "disk"  db_set_partition_location db_get_partition_location assert_str_ex
	source $PARTITION_TEST_SET_SH "var"  "disk"  db_set_partition_location db_get_partition_location assert_str_ex
	source $PARTITION_TEST_SET_SH "home" "disk"  db_set_partition_location db_get_partition_location assert_str_ex
	source $PARTITION_TEST_SET_SH "tmp"  "disk"  db_set_partition_location db_get_partition_location assert_str_ex
	source $PARTITION_TEST_SET_SH "opt" "disk"  db_set_partition_location db_get_partition_location assert_str_ex
	source $PARTITION_TEST_SET_SH "usr"  "disk"  db_set_partition_location db_get_partition_location assert_str_ex
	source $PARTITION_TEST_SET_SH "data" "disk"  db_set_partition_location db_get_partition_location assert_str_ex

	source $PARTITION_TEST_SET_SH "efi"	 "fat32" db_set_partition_filesystem db_get_partition_filesystem assert_str_ex
	source $PARTITION_TEST_SET_SH "boot" "ext1"  db_set_partition_filesystem db_get_partition_filesystem assert_str_ex
	source $PARTITION_TEST_SET_SH "swap" "ext2"  db_set_partition_filesystem db_get_partition_filesystem assert_str_ex
	source $PARTITION_TEST_SET_SH "root" "ext3"  db_set_partition_filesystem db_get_partition_filesystem assert_str_ex
	source $PARTITION_TEST_SET_SH "var"  "ext4"  db_set_partition_filesystem db_get_partition_filesystem assert_str_ex
	source $PARTITION_TEST_SET_SH "home" "ext5"  db_set_partition_filesystem db_get_partition_filesystem assert_str_ex
	source $PARTITION_TEST_SET_SH "tmp"  "ext6"  db_set_partition_filesystem db_get_partition_filesystem assert_str_ex
	source $PARTITION_TEST_SET_SH "opt" "ext7"  db_set_partition_filesystem db_get_partition_filesystem assert_str_ex
	source $PARTITION_TEST_SET_SH "usr"  "ext8"  db_set_partition_filesystem db_get_partition_filesystem assert_str_ex
	source $PARTITION_TEST_SET_SH "data" "ext9"  db_set_partition_filesystem db_get_partition_filesystem assert_str_ex
	#set -x
	db_get_partition_count count1
	db_remove_partition "var"
	db_get_partition_count count2
	let count2=$count2+1
	source assert_int_ex $count1 $count2 "remove_partition"
	#set +x
	return $TRUE
}

function test_db_get_partition_full_info()
{
	name="efi"
	expect="efi:0:disk:vfat:/boot/efi"
	real="null"
	db_get_partition_full_info $name size loca fs_type mount_point	
	real="$name:$size:$loca:$fs_type:$mount_point"
	source assert_str $expect $real
	
	name="boot"
	expect="boot:111M:disk:ext4:/boot"
	real="null"
	db_get_partition_full_info $name size loca fs_type mount_point	
	real="$name:$size:$loca:$fs_type:$mount_point"
	source assert_str $expect $real	
	
	name="swap"
	expect="swap:?:lvm:ext4:swap"
	real="null"
	db_get_partition_full_info $name size loca fs_type mount_point	
	real="$name:$size:$loca:$fs_type:$mount_point"
	source assert_str $expect $real
	
	name="var"
	expect="var:12G:lvm:ext4:/var"
	real="null"
	db_get_partition_full_info $name size loca fs_type mount_point	
	real="$name:$size:$loca:$fs_type:$mount_point"
	source assert_str $expect $real
	
	name="data"
	expect="data:max:lvm:ext4:/data"
	real="null"
	db_get_partition_full_info $name size loca fs_type mount_point	
	real="$name:$size:$loca:$fs_type:$mount_point"
	source assert_str $expect $real
	
	return $TRUE
}

function test_db_set_partition_full_info()
{
	name="efi"
	size="100M"
	loca="disk"
	fs_type="ext1"
	mount_point="/xxefi"
	expect="$name:$size:$loca:$fs_type:$mount_point"
	real="null"
	db_set_partition_full_info $name $size $loca $fs_type $mount_point
	
	size="null"
	loca="null"
	fs_type="null"
	mount_point="null"
	db_get_partition_full_info $name size loca fs_type mount_point
	real="$name:$size:$loca:$fs_type:$mount_point"
	
	source assert_str $expect $real
	
	return $TRUE
}

function test_db_get_partition_count_by_flag()
{
	test_setup
	
	local flag="disk"
	local expect=3
	local real=0
	
	db_get_partition_count_by_flag $flag real	
	source assert_int $expect $real
	
	return $TRUE
}

function test_db_get_partition_count()
{
	PARTITION_DB_FILE="$PARTITION_DB_UNIT_TEST_DIR/$FUNCNAME.real"
echo "boot:111M:disk:ext4:/boot:resv2
swap:?:lvm:ext4:swap:resv2
root:11G:lvm:ext4:/:resv2
var:12G:lvm:ext4:/var:resv2
home:13G:lvm:ext4:/home:resv2
tmp:10G:lvm:ext4:/tmp:resv2
opt:14G:lvm:ext4:/opt:resv2
usr:15G:lvm:ext4:/usr:resv2
data:max:lvm:ext4:/data:resv2" > $PARTITION_DB_FILE
	expect=9
	db_get_partition_count 
}

function test_db_strip_partition_file()
{	
	PARTITION_DB_FILE="$PARTITION_DB_UNIT_TEST_DIR/$FUNCNAME.real"
echo "#efi:0:disk:vfat:/boot/efi:resv2
boot:111M:disk:ext4:/boot:resv2
swap:?:lvm:ext4:swap:resv2
root:11G:lvm:ext4:/:resv2
var:12G:lvm:ext4:/var:resv2

home:13G:lvm:ext4:/home:resv2
tmp:0:lvm:ext4:/tmp:resv2
opt:14G:lvm:ext4:/opt:resv2
usr:15G:lvm:ext4:/usr:resv2
data:max:lvm:ext4:/data:resv2" > $PARTITION_DB_FILE
	local expect="$PARTITION_DB_UNIT_TEST_DIR/$FUNCNAME.expect"
echo "boot:111M:disk:ext4:/boot:resv2
swap:?:lvm:ext4:swap:resv2
root:11G:lvm:ext4:/:resv2
var:12G:lvm:ext4:/var:resv2
home:13G:lvm:ext4:/home:resv2
tmp:0:lvm:ext4:/tmp:resv2
opt:14G:lvm:ext4:/opt:resv2
usr:15G:lvm:ext4:/usr:resv2
data:max:lvm:ext4:/data:resv2" > $expect
	local real=$PARTITION_DB_FILE
	
	db_strip_partition_file
	diff $expect $real > /dev/null
	if [ $? -ne $FALSE ];then
		exit $FALSE
	fi
	return $TRUE
}

function test_db_get_partitioin_name_list()
{
	PARTITION_DB_FILE="$PARTITION_DB_UNIT_TEST_DIR/$FUNCNAME.input"
echo "boot:111M:disk:ext4:/boot:resv2
swap:?:lvm:ext4:swap:resv2
root:11G:lvm:ext4:/:resv2
var:12G:lvm:ext4:/var:resv2
home:13G:lvm:ext4:/home:resv2
tmp:0:lvm:ext4:/tmp:resv2
opt:14G:lvm:ext4:/opt:resv2
usr:15G:lvm:ext4:/usr:resv2
data:max:lvm:ext4:/data:resv2" > $PARTITION_DB_FILE
	expect="boot
swap
root
var
home
tmp
opt
usr
data"
	real="null"
	expect="$expect"
	db_get_partitioin_name_list real

	source assert_str_ex "$expect" "$real" $FUNCNAME
	
	return $TRUE
}

function test_db_get_max_partition_full_info_1()
{
	PARTITION_DB_FILE="$PARTITION_DB_UNIT_TEST_DIR/$FUNCNAME.input"
echo "boot:111M:disk:ext4:/boot:resv2
swap:?:lvm:ext4:swap:resv2
root:11G:lvm:ext4:/:resv2
var:12G:lvm:ext4:/var:resv2
home:13G:lvm:ext4:/home:resv2
tmp:0:lvm:ext4:/tmp:resv2
opt:14G:lvm:ext4:/opt:resv2
usr:15G:lvm:ext4:/usr:resv2
data:max:lvm:ext4:/data:resv2" > $PARTITION_DB_FILE
	expect="data"
	real="null"
	
	db_get_max_partition_full_info real size loca fs_type mount_point resv2

	source assert_str_ex "$expect" "$real" $FUNCNAME
	
	return $TRUE
}

function test_db_get_max_partition_full_info_2()
{
	PARTITION_DB_FILE="$PARTITION_DB_UNIT_TEST_DIR/$FUNCNAME.input"
echo "boot:111M:disk:ext4:/boot:resv2
swap:?:lvm:ext4:swap:resv2
root:11G:lvm:ext4:/:resv2
var:12G:lvm:ext4:/var:resv2
home:13G:lvm:ext4:/home:resv2
tmp:0:lvm:ext4:/tmp:resv2
opt:max:lvm:ext4:/opt:resv2
usr:15G:lvm:ext4:/usr:resv2
data:20G:lvm:ext4:/data:resv2" > $PARTITION_DB_FILE
	expect="opt"
	real="null"
	
	db_get_max_partition_full_info real size loca fs_type mount_point resv2

	source assert_str_ex "$expect" "$real" $FUNCNAME
	
	return $TRUE
}

#Test list
test_partition_opt_func_arr=(
	test_setup
	test_db_get_partition_info
	test_db_set_partition_info
	test_setup
	test_db_get_partition_full_info
	test_db_set_partition_full_info
	test_db_get_partition_count_by_flag
	test_db_strip_partition_file
	test_db_get_partitioin_name_list
	test_db_get_max_partition_full_info_1
	test_db_get_max_partition_full_info_2
)

source sys_loop_array_and_exec.sh ${test_partition_opt_func_arr[*]}

exit $TRUE