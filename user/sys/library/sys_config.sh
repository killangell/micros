#!/bin/sh

#@in  1: Variable to be confirmed with $INVALID
function is_valid_variable()
{
	var=$1
	if [ "$INVALID" = "$var" ]; then
		return $FALSE
	fi
	return $TRUE
}

#@in  1: System root path
function set_sys_root_dir()
{
	dir=$1	
	SYS_ROOT=$dir
	
	export PATH=$PATH:$SYS_ROOT:$SYS_CONF_DIR:$SYS_LIBRARY_DIR:$SYS_LOG_DIR
	export PATH=$PATH:$SYS_MOUNT_DIR:$SYS_OUTPUT_DIR:$SYS_TEMP_DIR:$SYS_TOOLS_DIR
	export PATH=$PATH:$SYS_UTEST_DIR:$SYS_USER_DIR
	export SYS_ROOT="$SYS_ROOT"
	export SYS_CONF_DIR="$SYS_ROOT/conf"
	export SYS_LIBRARY_DIR="$SYS_ROOT/library"
	export SYS_LOG_DIR="$SYS_ROOT/log"
	export SYS_MOUNT_DIR="$SYS_ROOT/mount"
	export SYS_OUTPUT_DIR="$SYS_ROOT/output"
	export SYS_TEMP_DIR="$SYS_ROOT/temp"
	export SYS_TOOLS_DIR="$SYS_ROOT/tools"
	export SYS_UTEST_DIR="$SYS_UTEST_DIR"
	export SYS_USER_DIR="$SYS_ROOT/user"
	
	return $TRUE
}

#@out 1: System output path
function get_sys_output_dir()
{
	eval $1="$SYS_OUTPUT_DIR"
	return $TRUE
}

function get_sys_expect_mops_partition_sh_file()
{
	eval $1="$SYS_EXPECT_MOPS_PARTITION_SH_FILE"
	return $TRUE
}

function get_sys_expect_kickoff_segment_file()
{
	eval $1="$SYS_EXPECT_KICKOFF_SEGMENT_FILE"
	return $TRUE
}

function get_sys_expect_ks_segment_bootloader_file()
{
	eval $1="$SYS_EXPECT_KS_SEGMENT_BOOTLOADER_FILE"
	return $TRUE
}

function get_sys_expect_ks_segment_harddrive_file()
{
	eval $1="$SYS_EXPECT_KS_SEGMENT_HARDDRIVE_FILE"
	return $TRUE
}

function get_sys_expect_ks_segment_partition_file()
{
	eval $1="$SYS_EXPECT_KS_SEGMENT_PARTITION_FILE"
	return $TRUE
}

function get_sys_expect_ks_segment_pre_file()
{
	eval $1="$SYS_EXPECT_KS_SEGMENT_PRE_FILE"
	return $TRUE
}

function get_sys_expect_ks_segment_post_file()
{
	eval $1="$SYS_EXPECT_KS_SEGMENT_POST_FILE"
	return $TRUE
}
