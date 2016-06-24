#!/bin/sh

source sys_common.sh

#@in  1: drive size file (e.g.: )
#@out 2: drive size		 (e.g.: )
#@out 3: drive size unit (e.g.: GB/MB)
#return: 1:true/0:false
function parse_disk_size_file()
{
	size_string_file=$1
	
	eval $2=`cat $size_string_file | grep ^Disk | awk '{print int($3)}'`
	eval $3="GB"
	
	return $TRUE
}

#@in  1: drive name 	 (e.g.: sda/sdb/hda/hdb)
#@out 2: drive size		 (e.g.: )
#@out 3: drive size unit (e.g.: GB/MB)
#return: 1:true/0:false
function get_disk_size()
{
	drive_name=$1
	
	eval $2=`parted /dev/$drive_name p | grep ^Disk | awk '{print int($3)}'`
	eval $3="GB"
	
	return $TRUE 
}

function get_memory_size_by_free()
{
	eval $1=`free -m | grep Mem | awk '{print $2}'`
	eval $2="M"
	
	return $TRUE 
}

function get_memory_size_by_dmidecode()
{
	eval $1=`dmidecode | grep -P -A5 "Memory\s+Device" | grep Size | grep -v Range | head -n 1 | awk '{print $2}'`
	eval $2=`dmidecode | grep -P -A5 "Memory\s+Device" | grep Size | grep -v Range | head -n 1 | awk '{print $3}'`
	
	return $TRUE 
}

#@out 1: drive size		 (e.g.: )
#@out 2: drive size unit (e.g.: GB/MB)
#return: 1:true/0:false
function get_memory_size()
{
	size="null"
	unit="null"
	result=$FALSE
	
	is_cmd_exist "free" result
	if [ $result -eq $TRUE ];then
		get_memory_size_by_free size unit
		result=$TRUE
	fi
	
	is_cmd_exist "dmidecode" result
	if [ $result -eq $TRUE ];then
		get_memory_size_by_dmidecode size unit
		result=$TRUE
	fi
	
	eval $1=$size
	eval $2=$unit

	return $result 
}


#@out 1: drive size		 (e.g.: )
#@out 2: drive size unit (e.g.: GB/MB)
#return: 1:true/0:false
function get_memory_size2()
{
	#eval $1=`dmidecode | grep -P -A5 "Memory\s+Device" | grep Size | grep -v Range | head -n 1 | awk '{print $2}'`
	#eval $2=`dmidecode | grep -P -A5 "Memory\s+Device" | grep Size | grep -v Range | head -n 1 | awk '{print $3}'`
	eval $1=`free -m | grep Mem | awk '{print $2}'`
	eval $2="M"
	
	return $TRUE 
}

#@in  1: Cmd that can output partition info (e.g.: "parted /dev/sda p")
#@out 2: Partition count
function parse_disk_partition_count_from_cmd()
{
	cmd=$1
	partition_count="null"
	
	partition_count=`$cmd | awk '!/^$/' | awk 'n==1{print}$0~/Number/{n=1}' | wc -l`

	eval $2=$partition_count
	
	return $TRUE
}

#@in  1: Drive name		(e.g.: sda/sdb/hda/hdb)
#@out 2: Partition count
function get_disk_partition_count()
{
	drive_name=$1
	partition_count="null"
	cmd="parted /dev/$drive_name p"
	
	parse_disk_partition_count_from_cmd "$cmd" partition_count
	
	eval $2=$partition_count
	
	return $TRUE
}

#@in  1: Cmd that can output partition info (e.g.: "parted /dev/sda p")
#@in  2: Partition index
#@out 3: End size
function parse_disk_partition_end_size_from_cmd()
{
	cmd=$1
	partition_index=$2
	end_size="null"
	#set -x
	end_size=`$cmd | awk '!/^$/' | awk 'n==1{print}$0~/Number/{n=1}' | awk '{print $3}' | awk "NR==$partition_index"`
	#set +x
	eval $3=$end_size
	
	return $TRUE
}

#@in  1: Drive name		(e.g.: sda/sdb/hda/hdb)
#@in  2: Partition index
#@out 3: End size
function get_disk_partition_end_size()
{
	drive_name=$1
	partition_index=$2
	end_size="null"	
	cmd="parted /dev/$drive_name p"
	
	parse_disk_partition_end_size_from_cmd "$cmd" "$partition_index" end_size	
	
	eval $3=$end_size
	
	return $TRUE
}

#@in  1: Cmd that can output partition info (e.g.: "pvdisplay")
#@in  2: Device name		(e.g.: sda1/sdb2/hda1/hdb3)
#@out 3: Size
#@out 4: Unit
function parse_pv_size_from_cmd()
{
	cmd=$1
	device_name=$2
	size="null"
	unit="null"
		
	size=`$cmd | grep $device_name -A 10 | grep "PV Size" | awk '{print int($3)}'`
	unit=`$cmd | grep $device_name -A 10 | grep "PV Size" | awk '{print $4}'`
	
	eval $3=$size
	eval $4=$unit
	
	return $TRUE
}

#@in  1: Device name		(e.g.: sda1/sdb2/hda1/hdb3)
#@out 2: Size
#@out 3: Unit
function get_pv_size()
{
	device_name=$1
	size="null"	
	unit="null"
	
	cmd="pvdisplay"
	
	parse_pv_size_from_cmd "$cmd" "$device_name" size unit
	
	eval $2=$size
	eval $3=$unit
	
	return $TRUE
}

#@in  1: Device name		(e.g.: sda1/sdb2/hda1/hdb3)
#@out 2: Size
#@out 3: Unit
function get_disk_pv_capability()
{
	device_name=$1
	size="null"
	unit="null"
		
	pvcreate /dev/$device_name
	
	get_pv_size $device_name size unit
	
	pvremove /dev/$device_name -ff
	
	eval $2=$size
	eval $3=$unit
	
	return $TRUE
}
