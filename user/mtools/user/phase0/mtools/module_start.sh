#!/bin/sh

source sys_debug.sh

print_ln $LEVEL_INFO "$0"

tar -zxvf mtools.tar.gz -C /

exit $TRUE