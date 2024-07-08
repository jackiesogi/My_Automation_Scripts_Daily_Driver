#!/usr/bin/env bash

SEARCH_PATH=('/usr/include')
SEARCH_MACRO=""
SEAECH_MACRO_ONLY=1

while [[ $# -gt 0 ]]; do
	case $1 in
		-d)
			SEARCH_PATH=("$2")
			shift 2
			;;
        	-a)
			SEARCH_PATH+=("$2")  # Append new path to SEARCH_PATH array
			shift 2
			;;
		-m)
			if [[ $2 == "off" ]]; then
				SEARCH_MACRO_ONLY=0
				shift 2
			elif [[ $2 == "on" ]]; then
				SEARCH_MACRO_ONLY=1
				shift 2
			else
				SEARCH_MACRO_ONLY=1
				shift 2
			fi
			;;
        	*)
            		break
            		;;
    esac
done
        
SEARCH_MACRO="$1"

if [[ -z "$SEARCH_MACRO" ]]; then
    echo "Please provide a search macro."
    exit 1
fi

for path in "${SEARCH_PATH[@]}"; do
    # Check if the path exists
    if [ -d "$path" ]; then
        # Use find to search for .h files recursively and grep for the macro
        if [[ $SEARCH_MACRO_ONLY == 0 ]]; then
		find "$path" -type f -exec grep --color=auto -rnE "*$SEARCH_MACRO*" {} + 2> /dev/null | less -r
	else
		find "$path" -type f -name "*.h" -exec grep --color=auto -rnE "^\s*#\s*define\s+.*$SEARCH_MACRO.*" {} + 2> /dev/null | less -r
	fi
    else
        echo "Path $path does not exist."
    fi
done

echo "Searching has done for ${SEARCH_PATH[@]}"
