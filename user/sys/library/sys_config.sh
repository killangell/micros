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
