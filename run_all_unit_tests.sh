#!/bin/bash

#############################################################################
# File:         run_all_unit_tests.sh
#
# Purpose:      Executes the unit-tests regardless of calling directory
#
# Created:      13th June 2016
# Updated:      13th June 2016
#
# Author:       Matthew Wilson
#
#############################################################################

source="${BASH_SOURCE[0]}"
while [ -h "$source" ]; do
  dir="$(cd -P "$(dirname "$source")" && pwd)"
  source="$(readlink "$source")"
  [[ $source != /* ]] && source="$dir/$source"
done
dir="$( cd -P "$( dirname "$source" )" && pwd )"

#echo $dir
$dir/test/unit/ts_all.rb

