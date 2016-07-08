#!/bin/sh

source ks_template_handler.sh

key="#pre"
source_file=$1
ks_file=$2

ks_insert_file_before_key $key $source_file $ks_file

exit $?