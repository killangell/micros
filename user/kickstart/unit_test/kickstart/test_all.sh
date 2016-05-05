#!/bin/sh

export PATH=$PATH:./


sh test_ks_template_handler.sh
source assert_int $? $TRUE


exit $TRUE