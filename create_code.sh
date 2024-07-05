#!/usr/bin/env bash

search_dir="/home/jck/Documents/test/"
default_editor="gedit"

file_name=$(zenity --entry \
--width=300 \
--height=150 \
--title="Add new profile" \
--text="Enter name of new profile:")

	
name="${search_dir[@]}${file_name[@]}"
echo "${name}"

if [[ "${file_name}" == "${name}" ]]; then
	exit -1
fi

# Check if the file name exists
if [[ -e "${name}" ]]; then
	zenity --error \
	--width=300 \
	--height=150 \
	--title="Error creating new file" \
	--text="${name} already exists!"
	exit -1
else
	touch "${name}"
fi

# Open file with default_editor
"${default_editor}" "${name}"

# Check if the file is still empty
if [[ ! -s "${name}" ]]; then
		rm "${name}"
fi
