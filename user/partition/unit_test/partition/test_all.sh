#!/bin/sh

export PATH=$PATH:./
export PATH=$PATH:$SYS_LIBRARY_DIR/partition


sh test_user_partition_define.sh
source assert_int $? $TRUE

sh test_user_partition_conf_parser.sh
source assert_int $? $TRUE

sh test_user_partition_ks_converter.sh
source assert_int $? $TRUE


exit $TRUE