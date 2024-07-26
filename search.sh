#!/usr/bin/env bash

PROGRAM="search.sh"
DESCRIPTION="A lightweight script to find keyword or macros in project"
VERSION="v1.1"
AUTHOR="Jackie Chen"

SEARCH_PATH=('/usr/include')
SEARCH_MACRO=""
SEAECH_MACRO_ONLY=1

function print_usage() {
	echo "$PROGRAM $VERSION -- $DESCRIPTION" 
	echo ""
	echo "Usage: search.sh [-d] ${DIRECTORY} [-m] {on,off} [-h]"
	echo ""
	echo "    -d [DIRECTORY]     Specify the root directory you want to search, default to '/usr/include/'"
	echo "    -a [DIRECTORY]     Append more directories into search paths."
	echo "    -m [on|off]        Toggle search-c-macro-only option ON or OFF, default to 'on'"
	echo "    -h                 Show help page"
	echo ""
	echo "Example:"
	echo ""
	echo "    Search for the occurence of keyword 'ValueError' in current directory"
	echo "    search.sh -d . -m off 'ValueError'"
	echo ""
	echo "    Search for the C macro 'POSIX_VERSION' in default directory"
	echo "    search.sh 'POSIX_VERSION' (same with search.sh -d default -m on POSIX_VERSION)"
	echo ""
	echo "    Search for the occurence of keyword 'print' in default and additional path '/usr/local/include/SDL2/'"
	echo "    search.sh -a /usr/local/include/SDL2/ print (same with search.sh -a /usr/local/include/SDL2/ -m on print"
}

while [[ $# -gt 0 ]]; do
	case $1 in
		-h)
			print_usage
			exit 0
			;;
		-d)
			if [[ $2 != 'default' ]]; then
				SEARCH_PATH=("$2")
			fi
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
		find "$path" -type f -exec grep --color=auto -rnE ".*$SEARCH_MACRO.*" {} + 2> /dev/null | less -r
	else
		find "$path" -type f -name "*.h" -exec grep --color=auto -rnE "^\s*#\s*define\s+.*$SEARCH_MACRO.*" {} + 2> /dev/null | less -r
	fi
    else
        echo "Path $path does not exist."
    fi
done

echo "Searching for pattern \"$SEARCH_MACRO\" has done in ${SEARCH_PATH[@]}"
