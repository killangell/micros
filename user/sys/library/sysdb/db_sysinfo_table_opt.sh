#!/bin/sh

source sys_pair.sh

#@Out 1: Dest drive value
function db_get_sysinfo_dest_drive()
{
	source get_pair_value $SYSINFO_DB_FILE "dest_drive" $1
}
#@in  1: Dest drive value
function db_set_sysinfo_dest_drive()
{
	source set_pair_value $SYSINFO_DB_FILE "dest_drive" $1
}

#@Out 1: OS vendor
function db_get_sysinfo_os_vendor()
{
	source get_pair_value $SYSINFO_DB_FILE "os_vendor" $1
}
#@in  1: OS vendor
function db_set_sysinfo_os_vendor()
{
	source set_pair_value $SYSINFO_DB_FILE "os_vendor" $1
}

#@Out 1: OS version
function db_get_sysinfo_os_version()
{
	source get_pair_value $SYSINFO_DB_FILE "os_version" $1
}
#@in  1: OS version
function db_set_sysinfo_os_version()
{
	source set_pair_value $SYSINFO_DB_FILE "os_version" $1
}

#@Out 1: ks_unsupported_hardware_ability
function db_get_sysinfo_ks_unsupported_hardware_ability()
{
	source get_pair_value $SYSINFO_DB_FILE "ks_unsupported_hardware_ability" $1
}
#@in  1: ks_unsupported_hardware_ability
function db_set_sysinfo_ks_unsupported_hardware_ability()
{
	source set_pair_value $SYSINFO_DB_FILE "ks_unsupported_hardware_ability" $1
}
