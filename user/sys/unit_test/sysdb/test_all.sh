#!/bin/sh

export PATH=$PATH:./

sh test_db_sysinfo_table_opt.sh
source assert_int $? $TRUE

sh test_db_partition_table_opt.sh
source assert_int $? $TRUE

exit $TRUE