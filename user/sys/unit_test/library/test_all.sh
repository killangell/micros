#!/bin/sh

export PATH=$PATH:./

sh test_sys_disk.sh
source assert_int $? $TRUE

sh test_sys_file.sh
source assert_int $? $TRUE

sh test_sys_string.sh
source assert_int $? $TRUE

sh test_sys_pair.sh
source assert_int $? $TRUE

exit $TRUE