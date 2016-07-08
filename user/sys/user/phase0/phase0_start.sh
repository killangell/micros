#!/bin/sh

source sys_debug.sh

#get_debug_level old_level
#set_debug_level $LEVEL_INFO

sh sys_loop_subfolder_and_exec.sh "$SYS_USER_PHASE0_DIR" "module_start.sh"

#set_debug_level $old_level