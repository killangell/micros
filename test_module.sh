#!/bin/sh

#@in  1: Full string    (e.g.: /mnt/hgfs/VMShareFolder/linux-auto-installation/modules/partition)
#@out 2: Split	 	    (e.g.: /)
#@out 3: The last item. (e.g.: partition)
function get_last_item_by_splitter()
{
	full_string=$1
	split=$2
	
	eval $3=`echo "$full_string" | awk -F "$split" '{print $NF}'`

	return $TRUE
}

mkdir -p test-micros-dir
cd test-micros-dir
for file in ./*
do
    if [ -f $file ];then
		#echo file=$file
		get_last_item_by_splitter $file "/" last_name
		echo last_name=$last_name
		
		tar -zxvf $last_name 
		if [ $? -eq $FALSE ];then
			rm -rf $last_name
		fi
	fi
done

sh micros_start.sh