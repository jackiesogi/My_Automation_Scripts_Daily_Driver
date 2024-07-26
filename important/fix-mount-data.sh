#!/usr/bin/env bash

# Color table 
declare -A COLORS=(
    ["RED"]="\033[31m"
    ["GREEN"]="\033[32m"
    ["YELLOW"]="\033[33m"
    ["BLUE"]="\033[34m"
    ["WHITE"]="\033[0m"
)

# Function to get the color code by color name
get_color_code() {
    local color_name="$1"
    echo "${COLORS[$color_name]}"
}

# Function to log formatted colored message
log_formatted_colored_msg() {
    local color_name="$1"
    local message="$2"
    
    # Check if the color name exists in the COLORS array
    if [[ -v COLORS[$color_name] ]]; then
        local color_code
        color_code=$(get_color_code "$color_name")
        echo -e "${color_code}${message}${COLORS[WHITE]}"
    else
        echo -e "${COLORS[RED]}Color not supported!${COLORS[WHITE]}"
    fi
}

# Main function
log_formatted_colored_msg "BLUE" "[RUN] sudo fusermount -u /media/jck/Data"
sudo fusermount -u /media/jck/Data
sleep 3
log_formatted_colored_msg "BLUE" "[RUN] sudo mount /media/jck/Data"
sudo mount /media/jck/Data
sleep 3
nautilus --quit
log_formatted_colored_msg "BLUE" "[RUN] nautilus --quit"
sleep 1
log_formatted_colored_msg "GREEN" "Done! Now restart nautilus to see if the problem has been resolved!"
