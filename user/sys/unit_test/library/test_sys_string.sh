source sys_debug.sh
source sys_string.sh


STRING_UNIT_TEST_DIR="$SYS_LOG_DIR/unit_test/library"
mkdir -p $STRING_UNIT_TEST_DIR

#set -xv
#@out 1: true(1)/false(0)
function test_get_last_item_by_split_1()
{
	full_string="/mnt/hgfs/VMShareFolder/linux-auto-installation/modules/partition"
	split="/"
	expect="partition"
	real="null"
	
	get_last_item_by_splitter $full_string $split real
	if [ $real != $expect ];then
		return $FALSE
	fi
	
	return $TRUE
}

#@out 1: true(1)/false(0)
function test_get_last_item_by_split_2()
{
	full_string="mnt:hgfs:VMShareFolder:linux-auto-installation:modules:partition"
	split=":"
	expect="partition"
	real="null"
	
	get_last_item_by_splitter $full_string $split real
	if [ $real != $expect ];then
		return $FALSE 
	fi
	
	return $TRUE 
}

#@out 1: true(1)/false(0)
function test_parse_format_string_by_splitter_1()
{
	full_string="mnt:hgfs:VMShareFolder:linux-auto-installation:modules:partition"
	split=":"
	expect_number=6
	expect_param1="mnt"
	expect_param2="hgfs"
	expect_param3="VMShareFolder"
	expect_param4="linux-auto-installation"
	expect_param5="modules"
	expect_param6="partition"
	real_number=0
	real_param1="null"
	real_param2="null"
	real_param3="null"
	real_param4="null"
	real_param5="null"
	real_param6="null"
	
	parse_format_string_by_splitter $full_string $split real_number real_param1 real_param2 real_param3 real_param4 real_param5 real_param6
	if [ $expect_number != $real_number ];then
		return $FALSE 
	fi
	if [ $expect_param1 != $real_param1 ];then
		return $FALSE 
	fi
	if [ $expect_param2 != $real_param2 ];then
		return $FALSE 
	fi
	if [ $expect_param3 != $real_param3 ];then
		return $FALSE 
	fi
	if [ $expect_param4 != $real_param4 ];then
		return $FALSE 
	fi
	if [ $expect_param5 != $real_param5 ];then
		return $FALSE 
	fi
	if [ $expect_param6 != $real_param6 ];then
		return $FALSE 
	fi
	return $TRUE 
}


#@out 1: true(1)/false(0)
function test_parse_format_string_by_splitter_2()
{
	full_string="mnt:hgfs:VMShareFolder"
	split=":"
	expect_number=3
	expect_param1="mnt"
	expect_param2="hgfs"
	expect_param3="VMShareFolder"
	real_number=0
	real_param1="null"
	real_param2="null"
	real_param3="null"
	
	parse_format_string_by_splitter $full_string $split real_number real_param1 real_param2 real_param3
	if [ $expect_number != $real_number ];then
		return $FALSE 
	fi
	if [ $expect_param1 != $real_param1 ];then
		return $FALSE 
	fi
	if [ $expect_param2 != $real_param2 ];then
		return $FALSE 
	fi
	if [ $expect_param3 != $real_param3 ];then
		return $FALSE 
	fi
	return $TRUE 
}

#@out 1: true(1)/false(0)
function test_parse_format_string_by_splitter_3()
{
	full_string="mnt/hgfs/VMShareFolder"
	split="/"
	expect_number=3
	expect_param1="mnt"
	expect_param2="hgfs"
	expect_param3="VMShareFolder"
	real_number=0
	real_param1="null"
	real_param2="null"
	real_param3="null"
	
	parse_format_string_by_splitter $full_string $split real_number real_param1 real_param2 real_param3
	if [ $expect_number != $real_number ];then
		return $FALSE 
	fi
	if [ $expect_param1 != $real_param1 ];then
		return $FALSE 
	fi
	if [ $expect_param2 != $real_param2 ];then
		return $FALSE 
	fi
	if [ $expect_param3 != $real_param3 ];then
		return $FALSE 
	fi
	return $TRUE 
}

#@out 1: true(1)/false(0)
function test_parse_format_string_by_splitter_4()
{
	full_string="mnt/hgfs/VMShareFolder"
	split="/"
	real_number=0
	
	#The max number of params is 9, the calling folowing is definitely wrong
	parse_format_string_by_splitter $full_string $split real_number p1 p2 p3 p4 p5 p6 p7 
	if [ $? != $FALSE ];then
		return $FALSE 
	fi

	return $TRUE 
}

#@out 1: true(1)/false(0)
function test_parse_format_string_by_splitter_5()
{
	full_string="mnt/hgfs/VMShareFolder"
	split="/"
	real_number=0
	
	#The outputting result param number is incompatible against inputting number
	parse_format_string_by_splitter $full_string $split real_number p1 p2 #p3 
	if [ $? != $FALSE ];then
		return $FALSE 
	fi

	return $TRUE 
}

#@out 1: true(1)/false(0)
function test_parse_format_string_by_splitter_6()
{
	full_string="mnt/hgfs/VMShareFolder"
	split="/"
	real_number=0
	
	#The outputting result param number is incompatible against inputting number
	parse_format_string_by_splitter $full_string $split real_number p1 p2 p3 p4
	if [ $? != $FALSE ];then
		return $FALSE 
	fi

	return $TRUE 
}

#@out 1: true(1)/false(0)
function test_is_useless_line()
{
	line="#This is a useless line"
	expect_result=1
	
	is_useless_line $line
	if [ $? -ne $expect_result ];then
		return $FALSE 
	fi
	
	
	line=""
	expect_result=1
	
	is_useless_line $line
	if [ $? -ne $expect_result ];then
		return $FALSE 
	fi
	
	line="\n"
	expect_result=1
	
	is_useless_line $line
	if [ $? -ne $expect_result ];then
		return $FALSE 
	fi
	
	line="This is a useful line"
	expect_result=0
	
	is_useless_line $line
	if [ $? -ne $expect_result ];then
		return $FALSE 
	fi
	
	return $TRUE
}

function test_split_string_to_n_c()
{
	string="123MiB"
	expect_num="123"
	expect_chars="MiB"
	real_num="null"
	real_chars="null"
	
	split_string_to_n_c $string real_num real_chars
	source assert_int $real_num $expect_num
	source assert_str $real_chars $expect_chars

	###
	string="123.456MB"
	expect_num="123.456"
	expect_chars="MB"
	real_num="null"
	real_chars="null"
	
	split_string_to_n_c $string real_num real_chars
	source assert_str $real_num $expect_num
	source assert_str $real_chars $expect_chars
	
	return $TRUE
}

#Test list
test_string_func_arr=(
	test_get_last_item_by_split_1
	test_get_last_item_by_split_2
	test_parse_format_string_by_splitter_1
	test_parse_format_string_by_splitter_2
	test_parse_format_string_by_splitter_3
	test_parse_format_string_by_splitter_4
	test_parse_format_string_by_splitter_5
	test_parse_format_string_by_splitter_6
	test_is_useless_line
	test_split_string_to_n_c
)

source sys_loop_array_and_exec.sh ${test_string_func_arr[*]}

exit $TRUE