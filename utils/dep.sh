#!/bin/bash

source jckdepchk.inc

#echo "before adding dependencies:"
#echo $deplist

#echo "after adding dependencies:"
#echo $deplist

set_dependencies 'grep' 'zenity' 'notify-send' 
deplist=$(get_dependencies) 

check_dependencies
