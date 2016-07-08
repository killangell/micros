#!/bin/sh

source sys_debug.sh
source sys_file.sh

print_ln $LEVEL_INFO "$0"

export PT_MOPS_PARTITION_SH_FILE="$SYS_EXPECT_MOPS_PARTITION_SH_FILE"
export PT_KICKOFF_SEGMENT_FILE="$SYS_EXPECT_KICKOFF_SEGMENT_FILE"
export PT_KS_SEGMENT_BOOTLOADER_FILE="$SYS_EXPECT_KS_SEGMENT_BOOTLOADER_FILE"
export PT_KS_SEGMENT_HARDDRIVE_FILE="$SYS_EXPECT_KS_SEGMENT_HARDDRIVE_FILE"
export PT_KS_SEGMENT_PARTITION_FILE="$SYS_EXPECT_KS_SEGMENT_PARTITION_FILE"
export PT_KS_SEGMENT_PRE_FILE="$SYS_EXPECT_KS_SEGMENT_PRE_FILE"
export PT_KS_SEGMENT_POST_FILE="$SYS_EXPECT_KS_SEGMENT_POST_FILE"

#Check file existence
file=$PT_MOPS_PARTITION_SH_FILE
is_file_exist  $file result
source assert_int_ex $TRUE $result $file

file=$PT_KICKOFF_SEGMENT_FILE
is_file_exist  $file result
source assert_int_ex $TRUE $result $file

file=$PT_KS_SEGMENT_BOOTLOADER_FILE
is_file_exist  $file result
source assert_int_ex $TRUE $result $file

file=$PT_KS_SEGMENT_HARDDRIVE_FILE
is_file_exist  $file result
source assert_int_ex $TRUE $result $file

file=$PT_KS_SEGMENT_PARTITION_FILE
is_file_exist  $file result
source assert_int_ex $TRUE $result $file

# file=$PT_KS_SEGMENT_PRE_FILE
# is_file_exist  $file result
# source assert_int_ex $TRUE $result $file

file=$PT_KS_SEGMENT_POST_FILE
is_file_exist  $file result
source assert_int_ex $TRUE $result $file

file=$SYS_KS_FILE
is_file_exist  $file result
source assert_int_ex $TRUE $result $file

file=$SYS_ISO_FILE
is_file_exist  $file result
source assert_int_ex $TRUE $result $file

cp -rf $SYS_KS_FILE $SYS_KS_FILE.back
#Set ks.cfg

sh ks_set_bootloader.sh $PT_KS_SEGMENT_BOOTLOADER_FILE $SYS_KS_FILE
source assert_int_ex $? $TRUE "Set bootloader"

sh ks_set_harddrive.sh $PT_KS_SEGMENT_HARDDRIVE_FILE $SYS_KS_FILE
source assert_int_ex $? $TRUE "Set harddrive"

sh ks_set_partition.sh $PT_KS_SEGMENT_PARTITION_FILE $SYS_KS_FILE
source assert_int_ex $? $TRUE "Set partition"

# sh ks_add_pre.sh $PT_KS_SEGMENT_PRE_FILE $SYS_KS_FILE
# source assert_int_ex $? $TRUE "Set pre"

sh ks_add_post.sh $PT_KS_SEGMENT_POST_FILE $SYS_KS_FILE
source assert_int_ex $? $TRUE "Set post"

exit $TRUE