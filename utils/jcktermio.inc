##### Name: jcktermio.inc
##### Author: Jackie Chen
##### Description: Commonly-used terminal IO utilities

#!/usr/bin/env bash

##############################
##### Internal Functions #####
##############################

# Color Dictionary
declare -A _COLOR=(
	["RED"]="\033[31m"
	["GREEN"]="\033[32m"
	["YELLOW"]="\033[33m"
	["BLUE"]="\033[34m"
	["WHITE"]="\033[0m"
)

_get_color_code() {
	local key="$1"
	echo -ne "${_COLOR[$key]}"
}

############################
###### USER Functions ######
############################

# Log formatted message with color
# $1 : Color
# $2 : Formatted String
jck_logmsg_colored_formatted() {
	local color=$(_get_color_code "$1")
	local white=$(_get_color_code "WHITE")
	echo -ne "$color$2$white"
}

jck_logerr() {
	local color=$(_get_color_code "RED")
	local white=$(_get_color_code "WHITE")
	echo "${color}$1${white}"
}

jck_logmsg_formatted_() {
	echo
}

jck_logmsg_colored() {
	echo
}

jck_logmsg() {
	if [[ $# -ne 1 ]]; then
		jck_logerr "${FUNCNAME[0]}: Expects one argument, but got $#."
		#exit 1
	fi		
	echo "$1"
}


