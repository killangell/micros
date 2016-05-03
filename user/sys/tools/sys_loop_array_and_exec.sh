#!/bin/sh

#echo numberxxx=$?,$#,$@,$*
#echo numberxxx="$?","$#","$@","$*"

i=1
for item in $*;do
	#echo $item
	print_head $LEVEL_INFO "loop func $i: $item"
	$item
	
	if [ $? -eq $FALSE ];then
		print_body $LEVEL_ERROR " ... failed\n"
		exit $FALSE
	else
		print_body $LEVEL_INFO " ... passed\n"
	fi
	
	let i=$i+1
done

#exit $TRUE