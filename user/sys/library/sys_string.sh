#!/bin/sh

#@in  1: Full string    (e.g.: /mnt/hgfs/VMShareFolder/linux-auto-installation/modules/partition)
#@in  2: Splitter 	    (e.g.: /)
#@out 3: The last item. (e.g.: partition)
function get_last_item_by_splitter()
{
	string=$1
	splitter=$2
	
	eval $3=`echo "$string" | awk -F "$splitter" '{print $NF}'`

	return $TRUE
}

#@in  1: Full string    (e.g.: /mnt/hgfs/VMShareFolder/linux-auto-installation/modules/partition)
#@in  2: Splitter	    (e.g.: /)
#@out 3: Result number	(e.g.: 6)
#@out..  Result details (e.g.: mnt hgfs VMShareFolder linux-auto-installation modules partition)
#Desc  : Usage please refere test_sys_string.sh
function parse_format_string_by_splitter()
{
	string=$1
	splitter=$2
	
	number=`echo "$string" | awk -F "$splitter" '{print NF}'`
	eval $3=$number
	
	#Check params number
	if [ $# -gt 9 ];then
		return $FALSE
	fi
	let expect_params_number=$number+3
	if [ $# -ne $expect_params_number ];then
		return $FALSE
	fi
	
	if [ $number -ge 2 ];then
		eval $4=`echo "$string" | awk -F "$splitter" '{print $1}'`
		eval $5=`echo "$string" | awk -F "$splitter" '{print $2}'`
	fi
	if [ $number -ge 3 ];then
		eval $6=`echo "$string" | awk -F "$splitter" '{print $3}'`
	fi
	if [ $number -ge 4 ];then
		eval $7=`echo "$string" | awk -F "$splitter" '{print $4}'`
	fi
	if [ $number -ge 5 ];then
		eval $8=`echo "$string" | awk -F "$splitter" '{print $5}'`
	fi
	if [ $number -ge 6 ];then
		eval $9=`echo "$string" | awk -F "$splitter" '{print $6}'`
	fi
	
	return $TRUE
}

#@in  1: String line
#return: Result(true/false)
#Desc  : Starting with "^#" line and "blank" line are useless
function is_useless_line()
{
	if [[ $line = *#* ]];then
		return $TRUE
	elif [[ $line = "" ]];then
		return $TRUE
	elif [[ $line = "\n" ]];then
		return $TRUE
	fi
	
	return $FALSE
}

#
function split_string_to_n_c()
{
	string=$1
	strmid="null"
	num="null"
	chars="null"
	char_index="null"
	
	point_index=`expr index $string .`
	if [ $point_index -eq 0 ];then
		num=`expr "$string" : '\([0-9]*\)'`
	else
		num=`expr "$string" : '\([0-9]*\.[0-9]*\)'`
	fi
	
	num_len=`expr length $num`
	let num_len=$num_len+1
	string_len=`expr length $string`
	chars=`expr substr $string $num_len $string_len`
	
	eval $2=$num
	eval $3=$chars

	return $TRUE
}

