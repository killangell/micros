#!/bin/sh

source sys_debug.sh

print_ln $LEVEL_INFO "$0"

tar -zxvf gdisk.tar.gz -C /

exit $TRUE