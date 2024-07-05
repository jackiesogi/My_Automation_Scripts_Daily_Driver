### Name: jckdepchk.inc
### Description: Utilities to check dependecies
### Author: Jackie Chen

#!/usr/bin/env bash
source jckfuncalias.inc
source jcktermio.inc

DEPENDENCY_LIST=()

function set_dependencies() {
	for item in "$@"; do
		DEPENDENCY_LIST+=($item)
	done
}

function get_dependencies() {
	echo ${DEPENDENCY_LIST[@]}
}

function check_dependencies() {
	for dependency in ${DEPENDENCY_LIST[@]}; do
		if ! command -v "$dependency" > /dev/null; then
			logcf "RED" "[ERROR] Could not find package \"$dependency\" on this system, please install it first and make sure it is in \$PATH!\n"
			logcf "RED" "Abort!\n"
			exit 1
		fi
		logcf "WHITE" "[INFO] Found package \"$dependency\".\n"
	done
	logcf "GREEN" "Done!"
	exit 0
}
