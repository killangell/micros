#!/bin/sh

export TRUE=1
export FALSE=0
export INVALID="null"

export SYS_ROOT=`pwd`
export SYS_CONF_DIR="$SYS_ROOT/conf"
export SYS_LIBRARY_DIR="$SYS_ROOT/library"
export SYS_LIBRARY_ASSERT_DIR="$SYS_LIBRARY_DIR/assert"
export SYS_LIBRARY_PAIR_DIR="$SYS_LIBRARY_DIR/pair"
export SYS_LIBRARY_PARTITION_DIR="$SYS_LIBRARY_DIR/partition"
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
export PATH=$PATH:$SYS_LIBRARY_ASSERT_DIR:$SYS_LIBRARY_PAIR_DIR:$SYS_LIBRARY_PARTITION_DIR

export PATH=$PATH:$SYS_CONF_DIR/sysdb
export PATH=$PATH:$SYS_LIBRARY_DIR/sysdb
export SYSINFO_DB_FILE="$SYS_CONF_DIR/sysdb/sysinfo.table"
export PARTITION_DB_FILE="$SYS_CONF_DIR/sysdb/partition.table"

#Partition module and kickstart module are share this info
export SYS_EXPECT_MOPS_PARTITION_SH_FILE="$SYS_OUTPUT_DIR/mops_partition.sh"
export SYS_EXPECT_KICKOFF_SEGMENT_FILE="$SYS_OUTPUT_DIR/firstboot.sh"
export SYS_EXPECT_KS_SEGMENT_BOOTLOADER_FILE="$SYS_OUTPUT_DIR/ks-segment-bootloader.out"
export SYS_EXPECT_KS_SEGMENT_HARDDRIVE_FILE="$SYS_OUTPUT_DIR/ks-segment-harddrive.out"
export SYS_EXPECT_KS_SEGMENT_PARTITION_FILE="$SYS_OUTPUT_DIR/ks-segment-partition.out"
export SYS_EXPECT_KS_SEGMENT_PRE_FILE="$SYS_OUTPUT_DIR/ks-segment-pre.out"
export SYS_EXPECT_KS_SEGMENT_POST_FILE="$SYS_OUTPUT_DIR/ks-segment-post.out"
export SYS_DEST_OS_DRIVE="sda"
export SYS_BOOT_DEV="bootdev"
export SYS_ISO_DEV="isodev"
export SYS_KS_FILE="$SYS_OUTPUT_DIR/ks.cfg"
export SYS_ISO_FILE="$SYS_OUTPUT_DIR/xos.iso"

#Clean previous log
rm -rf $SYS_LOG_DIR
rm -rf $SYS_MOUNT_DIR
rm -rf $SYS_TEMP_DIR

#Set environment 
mkdir -p $SYS_CONF_DIR
mkdir -p $SYS_LIBRARY_DIR
mkdir -p $SYS_LOG_DIR
mkdir -p $SYS_MOUNT_DIR
mkdir -p $SYS_OUTPUT_DIR
mkdir -p $SYS_TEMP_DIR
mkdir -p $SYS_TOOLS_DIR
mkdir -p $SYS_UTEST_DIR
mkdir -p $SYS_USER_DIR

source sys_debug.sh
set_debug_level $LEVEL_INFO

#set_debug_level $LEVEL_INFO

export SYS_USER_PHASE0_DIR="$SYS_USER_DIR/phase0"
export SYS_USER_PHASE1_DIR="$SYS_USER_DIR/phase1"
export SYS_USER_PHASE2_DIR="$SYS_USER_DIR/phase2"
export SYS_USER_PHASE3_DIR="$SYS_USER_DIR/phase3"
export SYS_USER_PHASE4_DIR="$SYS_USER_DIR/phase4"
export PATH=$PATH:$SYS_USER_PHASE0_DIR:$SYS_USER_PHASE1_DIR:$SYS_USER_PHASE2_DIR
export PATH=$PATH:$SYS_USER_PHASE3_DIR:$SYS_USER_PHASE4_DIR

mkdir -p $SYS_USER_PHASE0_DIR
mkdir -p $SYS_USER_PHASE1_DIR
mkdir -p $SYS_USER_PHASE2_DIR
mkdir -p $SYS_USER_PHASE3_DIR
mkdir -p $SYS_USER_PHASE4_DIR

sh phase0_start.sh

#Step 1: Unit test
sh unit_test.sh
source assert_int $? $TRUE

sh phase1_start.sh

sh phase2_start.sh

sh phase3_start.sh

sh phase4_start.sh
