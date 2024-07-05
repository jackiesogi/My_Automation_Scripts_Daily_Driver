### Name: get_all_files.sh
### Description: Print all the files content of a specific directory
### Author: Jackie Chen

#!/usr/bin/env bash

# Metadata
VERSION=1.0
PROGRAM_NAME="get_all_files.sh"
AUTHOR="Jackie Chen"

# Dependencies
require=('find' 'tr' 'chatgpt' 'head')
boost=('tree')

# Color Table
declare -A COLOR=(
	["RED"]="\033[31m"
	["GREEN"]="\033[32m"
	["YELLOW"]="\033[33m"
	["BLUE"]="\033[34m"
	["WHITE"]="\033[0m"
)

# General Options
OPTSTRING=":a::d::hn:m:o:s::t:"
TARGET_DIR=""
NUMBER_LINE=0
TRAVERSE_DEPTH=0
AI_IS_ENABLED=0
SEARCH_IS_ENABLED=0
SEARCH_PATTERN=""
OUTPUT_FILE=""

# AI Model Options
AI_MODEL_ENDPOINT="chatgpt -q"
AI_USER_PROMPT=""
AI_DEFAULT_PROMPT="Read the files structure below, and \
	extract the full filename of each file"
	AI_MODEL_RESTRICTION="Note that list all the files are output in only one line(plain text) and saperate with one space, and do not output anything other than that."

# Resuable Functions
function print_debug() {
	echo "Arguments:"
	echo "    argv[0]              = ${PROGRAM_NAME}"
	for (( i = 1 ; i <= $#; i++ )); do
		echo "    argv[$i]              = ${!i}"
	done
	echo "Variables:"
	echo "    OPTARG               = ${OPTARG}"
	echo "    OPTSTRING            = ${OPTSTRING}"
	echo "    TARGET_DIR           = ${TARGET_DIR}"
	echo "    NUMBER_LINE          = ${NUMBER_LINE}"
	echo "    TRAVERSE_DEPTH       = ${TRAVERSE_DEPTH}"
	echo "    AI_IS_ENABLED        = ${AI_IS_ENABLED}"
	echo "    SEARCH_IS_ENABLED    = ${SEARCH_IS_ENABLED}"
	echo "    SEARCH_PATTERN       = ${SEARCH_PATTERN}"
	echo "    AI_MODEL_ENDPOINT    = ${SAI_MODEL_ENDPOINT}"
	echo "    AI_USER_PROMPT       = ${AI_USER_PROMPT}"
	echo "    AI_DEFAULT_PROMPT    = ${AI_DEFAULT_PROMPT}"
	echo "    AI_MODEL_RESTRICTION = ${AI_MODEL_RESTRICTION}"
	echo "    AI_CMD               = ${AI_CMD}"
	echo "    OUTPUT_FILE          = ${OUTPUT_FILE}"
	echo "    files                = ${files}"
}

function check_requirements() {
	for item in "${requirements[@]}"; do
		if ! command -v "${item}" > /dev/null; then
			print_error "Requirements not met: ${item}, please install it first."
			exit 1
		fi
	done
}

function print_usage() {
	echo "${PROGRAM_NAME} v${VERSION} -- By ${AUTHOR}"
	echo ""
	echo "Usage: ${PROGRAM_NAME} [OPTIONS...] [ARGUMENT]"
	echo "  Description:"
	echo "    List source file content of a big project."
	echo ""
	echo "  Options:"
	echo "    -a [AI_prompt]               specify ai prompt to control which files to match"
	echo "    -d [target_directory]        specify the root directory to the project"
	echo "    -h                           view this help page"
	echo "    -n [top_n_lines]             limit the numbers of line going to print for every file"
	echo "    -m [AI_model]                choose your own ai model"
	echo "    -o [output_file]             output the result to a specific file"
	echo "    -s [search_pattern]          specify a self-defined search pattern to match the file name"
	echo "    -t [traversal_depth]         limit the max traversal depth from the root directory"
	echo ""
}

function print_warning() {  
	# Accept only one arguments, representing the warning message
	echo -ne "${COLOR[YELLOW]}[WARNING] $1${COLOR[WHITE]}\n"
}

function print_error() {
	# Accept only one arguments, representing the error message
	echo -ne "${COLOR[RED]}[ERROR] $1${COLOR[WHITE]}\n"
}

function print_info() {
	# Accept only one arguments, representing the information message
	echo -ne "[INFO] $1\n"
}

# Main script
#print_debug "$@"
while getopts ${OPTSTRING} opt; do
	case ${opt} in
		a)  # Use 'A'I to only lists the related files content
			AI_IS_ENABLED=1
			if [[ -n ${OPTARG} ]]; then	
				AI_USER_PROMPT=${OPTARG}			
			else
				print_warning "No user prompt provided, use default one."
				AI_USER_PROMPT=${AI_DEFAULT_PROMPT}
			fi
			;;
		d)  # Specify a target 'd'irectory.
			if [[ -n ${OPTARG} ]]; then	
				TARGET_DIR=${OPTARG}
			else
				print_warning "No target directory provided, use default one."
				TARGET_DIR=$(pwd)
			fi
			;;
		h)  # Print 'h'elp  page
			print_usage
			exit 0
			;;
		n)  # The 'n'umber of lines going to print for every files.
			NUMBER_LINE=${OPTARG}
			;;
		m)  # The AI 'm'odel going to use.
			AI_MODEL_ENDPOINT=${OPTARG}
			;;
		o)  # The 'o'utput file
			OUTPUT_FILE=${OPTARG}
			exec 3>"${OUTPUT_FILE}"
			;;
		s)  # Specify 's'earch pattern to find matching file name.
			SEARCH_IS_ENABLED=1
			SEARCH_PATTERN=${OPTARG}
			#print_warning "Option -s (List all files content) is not suggested \
			#	since it might include some binary files, use -a to let AI \
			#	model choose the necessary files for you instead."
			;;
		t)  # The depth of the tree going to 't'raverse.
			TRAVERSE_DEPTH=${OPTARG}
			;;
		:)  # Requires argument
			print_error "Option -${OPTARG} requires an argument."
			exit 1
			;;
		\?)  # Invalid option
			print_error "Invalid option -${OPTARG}."
			exit 1
			;;
	esac
done

# Collect the necessary files going to print
files=""

if [[ ${AI_IS_ENABLED} == 1 ]]; then  # Use AI model to decide the files going to print
	
	# Do not use -s
	if [[ ${SEARCH_IS_ENABLED} == 1 ]]; then
		print_error "Option -s cannot used with option -a."	
		exit 1
	fi

	
	files=$(find ${TARGET_DIR} -type f)
	AI_CMD="${AI_MODEL_ENDPOINT} \"${AI_DEFAULT_PROMPT}, ${AI_USER_PROMPT}. ${files} ,${AI_MODEL_RESTRICTION}.\""
	files=$(eval "${AI_CMD}")  # Note that this step is async so behavior is not guaranteed.

else  # Use self-defined parameter to limit the content going to print

	if [[ ${SEARCH_IS_ENABLED} == 1 ]]; then
		
		# Handling maxdepth
		if [[ ${TRAVERSE_DEPTH} -ne 0 ]]; then
			files=$(find ${TARGET_DIR} -maxdepth ${TRAVERSE_DEPTH} -type f -name "${SEARCH_PATTERN}")
		else
			files=$(find ${TARGET_DIR} -type f -name "${SEARCH_PATTERN}" -print0 | xargs -0 echo )
			echo ${files}
		fi

	fi

fi

#print_debug "$@"
# Handling output
OUTPUT_CMD="cat"
if [[ ${NUMBER_LINE} -ne 0 ]]; then
	OUTPUT_CMD="head -n ${NUMBER_LINE}"
fi


for file in ${files}; do
	echo ""
	echo "======================================"
	echo "${file}"
	echo "======================================"
	eval "${OUTPUT_CMD} ${file}"
	echo ""
done
