#!/bin/sh

export TRUE=1
export FALSE=0
export INVALID="null"

export SYS_ROOT=`pwd`
export SYS_CONF_DIR="$SYS_ROOT/conf"
export SYS_LIBRARY_DIR="$SYS_ROOT/library"
export SYS_LOG_DIR="$SYS_ROOT/log"
export SYS_MOUNT_DIR="$SYS_ROOT/mount"
export SYS_OUTPUT_DIR="$SYS_ROOT/output"
export SYS_TEMP_DIR="$SYS_ROOT/temp"
export SYS_TOOLS_DIR="$SYS_ROOT/tools"
export SYS_UTEST_DIR="$SYS_ROOT/unit_test"
export SYS_USER_DIR="$SYS_ROOT/user"
export PATH=$PATH:$SYS_ROOT:$SYS_CONF_DIR:$SYS_LIBRARY_DIR:$SYS_LOG_DIR
export PATH=$PATH:$SYS_MOUNT_DIR:$SYS_OUTPUT_DIR:$SYS_TEMP_DIR:$SYS_TOOLS_DIR
export PATH=$PATH:$SYS_UTEST_DIR:$SYS_USER_DIR

#Partition module and kickstart module are share this info
export SYS_EXPECT_MOPS_PARTITION_SH_FILE="$SYS_OUTPUT_DIR/mops_partition.sh"
export SYS_EXPECT_KICKOFF_SEGMENT_FILE="$SYS_OUTPUT_DIR/rc.local-segment.out"
export SYS_EXPECT_KS_SEGMENT_BOOTLOADER_FILE="$SYS_OUTPUT_DIR/ks-segment-bootloader.out"
export SYS_EXPECT_KS_SEGMENT_HARDDRIVE_FILE="$SYS_OUTPUT_DIR/ks-segment-harddrive.out"
export SYS_EXPECT_KS_SEGMENT_PARTITION_FILE="$SYS_OUTPUT_DIR/ks-segment-partition.out"
export SYS_EXPECT_KS_SEGMENT_PRE_FILE="$SYS_OUTPUT_DIR/ks-segment-pre.out"
export SYS_EXPECT_KS_SEGMENT_POST_FILE="$SYS_OUTPUT_DIR/ks-segment-post.out"

#Show environment 

source sys_debug.sh
set_debug_level $LEVEL_NONE

#Step 1: Unit test
sh unit_test.sh

set_debug_level $LEVEL_INFO

export SYS_USER_PHASE1_DIR="$SYS_USER_DIR/phase1"
export SYS_USER_PHASE2_DIR="$SYS_USER_DIR/phase2"
export SYS_USER_PHASE3_DIR="$SYS_USER_DIR/phase3"
export PATH=$PATH:$SYS_USER_PHASE1_DIR:$SYS_USER_PHASE2_DIR:$SYS_USER_PHASE3_DIR


sh phase1_start.sh

sh phase2_start.sh

sh phase3_start.sh

