#!/bin/bash

#############################################################################
# File:         test_unit.sh
#
# Purpose:      Executes the unit-tests regardless of calling directory
#
# Created:      19th April 2016
# Updated:      19th April 2016
#
# Author:       Matthew Wilson
#
# Copyright:    <<TBD>>
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

