##### Name: jckdbgutils.inc
##### Author: Jackie Chen
##### Description: Commonly-used debug utilities

#!/usr/bin/env bash

# Function to dump the call stack
jck_dumpstack() {
    echo "Call Stack (most recent call last):"
    local i=0
    while [ ${#FUNCNAME[@]} -gt $i ]; do
        echo "  at ${FUNCNAME[$i]} in ${BASH_SOURCE[$i]}:${BASH_LINENO[$i-1]}"
        ((i++))
    done
}

# Trap ERR and call dump_stack
trap 'jck_dumpstack' ERR
