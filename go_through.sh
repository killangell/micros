#!/bin/sh

export TRUE=1
export FALSE=0

mkdir -p test-micros-dir

echo clean_test
sh ./clean_test.sh
echo 
echo 

echo create_module
sh ./create_module.sh
echo 
echo 

echo test_module
sh ./test_module.sh
echo 
echo 