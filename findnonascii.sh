#!/bin/bash

LOG_FILE_DIR="findnonascii.log"
TMP_FILE_DIR="findnonascii.tmp"
count=0

echo > $LOG_FILE_DIR

for file in $(find . -type f -name "*.cs"); do
	
	grep -rnaP '[^[:ascii:]]' $file > $TMP_FILE_DIR
	result=$(cat $TMP_FILE_DIR)

	while read -r line; do
		count=$((count+1))
		MK="[]"
		NO=$count
		FN=$file
		LN="$(echo $line | cut -d: -f1)"
		OC="$(echo $line | cut -d: -f2-)"

		echo "$MK $NO $FN $LN '$OC' " >> $LOG_FILE_DIR
	done < $TMP_FILE_DIR

done

data="$(cat $LOG_FILE_DIR)"

cmd="zenity --list --checklist --editable --print-column='ALL' --width 1200 --height 750 \
  --title='View Non-ASCII Code : Modify File Content' --text='Make sure you are in a git repository or already did a backup, since this tool will overwrite the original content!' \
  --column='MARK' --column='NO' --column='FILENAME' --column='LINENO' --column='CODE' $data"


mod_record=$(eval $cmd 2> /dev/null)

IFS='|' read -r -a fields <<< "$mod_record"
num_fields=${#fields[@]}

#echo "fields: ${fields[@]}"
#echo "number of fields: $num_fields"

# Iterate through the fields
for (( i = 0 ; i < num_fields ; i += 4 )); do

	NO="${fields[i]}"    #; echo $NO
	FN="${fields[i+1]}"  #; echo $FN
	LN="${fields[i+2]}"  #; echo $LN
	MC="${fields[i+3]}"  #; echo $MC
	
	# HEAD and TAIL METHOD
	#top="$(head -n $((LN - 1)) $FN)"
	#bottom="$(tail -n $(($(cat $FN | wc -l) - $LN)) $FN)"
	#all=$(echo -e "$top\n$MC\n$bottom")
	#echo "$all" > "$FN.mod"
	
	# SED METHOD
	#leading_spaces=$(sed -n "$LN s|^\([[:space:]]*\).*|\1|p" $FN)
	#line=$(sed -n "$LN p" "$FN")
	#leading_spaces=$(echo "$line" | sed -e 's|^\([[:space:]]*\).*|\1|')
	#sed "$LN s|.*|$MC|" "$FN" > "$FN.mod"
	
	line=$(sed -n "$LN p" "$FN")
	leading_spaces=""
	for (( j = 0 ; j < ${#line} ; j++ )); do
    			char="${line:$j:1}"
    		if [[ "$char" == " " ]]; then
        		leading_spaces="${leading_spaces} "
    		else
        		break
    		fi
	done

	head -n $((LN - 1)) $FN > $FN.mod
	echo "$leading_spaces$MC" >> $FN.mod
	bottom="$(tail -n $(($(cat $FN | wc -l) - $LN)) $FN)"
	echo "$bottom" >> $FN.mod
	
	cp -f $FN.mod $FN
	rm -f $FM.mod
	
	#leading_spaces=$(echo "$line" | sed -e 's|^\([[:space:]]*\).*|\1|')
	#leading_spaces=$(python3 -c "\
	#	line='$line'
	#	import re
	#	match = re.match(r'^\s*', line)
	#	print(match.group(0))
	#")

done

#for mod_no in "${mod_record_array[@]}"; do
#	NO=$mod_no
#	LN="$(sed -n '$NO p' $LOG_FILE_DIR | cut -d' ' -f3)"
#	FN="$(sed -n '$NO p' $LOG_FILE_DIR | cut -d' ' -f4)"
#	OC="$(sed -n '$NO p' $LOG_FILE_DIR | cut -d' ' -f5)"
#
#	zenity --
#
#	sed -i '$LN s/.*/New content for line 3/' filename > 
#done
