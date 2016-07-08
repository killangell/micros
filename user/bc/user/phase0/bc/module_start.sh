#!/bin/sh

source sys_debug.sh

print_ln $LEVEL_INFO "$0"

tar -zxvf bc.tar.gz -C /

exit $TRUE