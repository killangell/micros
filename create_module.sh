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
cd user
for dir in ./*
do
    if [ -d $dir ];then
		echo dir=$dir
		get_last_item_by_splitter $dir "/" last_name
		echo last_name=$last_name
		cd $dir
		output=$last_name.tar.gz
		tar -zcvf ../../test-micros-dir/$output ./
		echo "Output file $output"
		cd ..
	fi
done
