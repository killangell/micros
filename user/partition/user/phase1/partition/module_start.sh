#!/bin/sh

source sys_debug.sh

export PATH=$PATH:$SYS_LIBRARY_DIR/partition
print_ln $LEVEL_INFO "$0"

export PT_DEST_OS_DRIVE="$INVALID"
export PT_MAX_PARTITION_NAME="$INVALID"
export PT_MAX_PARTITION_SIZE="$INVALID"
export PT_MAX_PARTITION_LOCA="$INVALID"
export PT_MAX_PARTITION_FS_TYPE="$INVALID"
export PT_VG_NAME="vg0"
export PT_MOPS_PARTITION_NUM="$INVALID"
export PT_KS_TEMP_DIR="/mnt/temp"
export PT_KS_PRELOAD_DIR="/mnt/preload"
export PT_KICKOFF_FILE="$PT_KS_TEMP_DIR/rc.local"

export PT_MOPS_PARTITION_SH_FILE="$SYS_EXPECT_MOPS_PARTITION_SH_FILE"
export PT_KICKOFF_SEGMENT_FILE="$SYS_EXPECT_KICKOFF_SEGMENT_FILE"
export PT_KS_SEGMENT_BOOTLOADER_FILE="$SYS_EXPECT_KS_SEGMENT_BOOTLOADER_FILE"
export PT_KS_SEGMENT_HARDDRIVE_FILE="$SYS_EXPECT_KS_SEGMENT_HARDDRIVE_FILE"
export PT_KS_SEGMENT_PARTITION_FILE="$SYS_EXPECT_KS_SEGMENT_PARTITION_FILE"
export PT_KS_SEGMENT_PRE_FILE="$SYS_EXPECT_KS_SEGMENT_PRE_FILE"
export PT_KS_SEGMENT_POST_FILE="$SYS_EXPECT_KS_SEGMENT_POST_FILE"
rm -rf $PT_MOPS_PARTITION_SH_FILE
rm -rf $PT_KICKOFF_SEGMENT_FILE
rm -rf $PT_KS_SEGMENT_BOOTLOADER_FILE
rm -rf $PT_KS_SEGMENT_HARDDRIVE_FILE
rm -rf $PT_KS_SEGMENT_PARTITION_FILE
rm -rf $PT_KS_SEGMENT_PRE_FILE
rm -rf $PT_KS_SEGMENT_POST_FILE

export PT_TEMP_DIR="$SYS_TEMP_DIR/partition"
mkdir -p $PT_TEMP_DIR

export PT_PARTITION_SIZING_FILE="$PT_TEMP_DIR/partition_sizing.out"
rm -rf $PT_PARTITION_SIZING_FILE

#User partitoin file here
user_partition_file="user_partition.sample.bios-lvm"

#Check user_partition_file
sh user_partition_check.sh $user_partition_file
source assert_int $? $TRUE


sh user_partition_sizing.sh $user_partition_file

sh user_partition_action_mops_partition.sh $PT_MOPS_PARTITION_SH_FILE
sh $PT_MOPS_PARTITION_SH_FILE

sh user_partition_action_ks_partition.sh $PT_KS_SEGMENT_PARTITION_FILE

sh user_partition_action_ks_bootloader.sh $PT_KS_SEGMENT_BOOTLOADER_FILE

sh user_partition_action_ks_harddrive.sh $PT_KS_SEGMENT_HARDDRIVE_FILE

#sh user_partition_action_ks_pre.sh $PT_KS_SEGMENT_PRE_FILE
::<<A
source user_partition_action_ks_post.sh $PT_KS_SEGMENT_POST_FILE $PT_KICKOFF_SEGMENT_FILE
A
exit $TRUE
