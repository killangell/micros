#!/bin/sh

source ks_template_handler.sh

key="#post"
source_file=$1
ks_file=$2

ks_insert_file_after_key $key $source_file $ks_file