#!/usr/bin/env bash

SEARCH_DIR="/home/jck/.local/linux"

if [[ $# -eq 1 ]]; then
	SEARCH_WORD=$1
	find "$SEARCH_DIR" -type f \( -name "*.c" -o -name "*.h" \) -exec grep -rnE "^\s*+.*$SEARCH_WORD.*" ${path/*.h} --color=always {} + | less -r 
fi
