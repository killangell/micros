#!/bin/sh

export PATH=$PATH:./

sh test_xos_readme.sh
source assert_int $? $TRUE


exit $TRUE