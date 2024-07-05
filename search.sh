#!/usr/bin/env bash

SEARCH_PATH=('/usr/include')
SEARCH_MACRO="$1"

if [[ $# -eq 1 ]]; then
    for path in "${SEARCH_PATH[@]}"; do
        # Check if the path exists
        if [ -d "$path" ]; then
            # Use find to search for .h files recursively and grep for the macro
            find "$path" -type f -name "*.h" -exec grep -rnE "^\s*#\s*define\s+.*$SEARCH_MACRO.*" ${path/*.h} --color=always {} + | less -r 
        else
            echo "Path $path does not exist."
        fi
    done
else
    echo "Please provide a search macro."
fi
