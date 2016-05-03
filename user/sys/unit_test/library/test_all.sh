#!/bin/sh

export PATH=$PATH:./

sh test_sys_disk.sh
sh test_sys_file.sh
sh test_sys_string.sh

exit $TRUE