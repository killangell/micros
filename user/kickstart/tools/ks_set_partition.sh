#!/bin/sh

source ks_template_handler.sh

key="#partition"
source_file=$1
ks_file=$2

ks_replace_key_by_file $key $source_file $ks_file

exit $?