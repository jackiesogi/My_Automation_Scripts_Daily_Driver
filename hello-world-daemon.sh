#!/bin/bash

# Dependency list
requirements=("command" "notify-send" "echo" "exit" "zenity" "date") 

function check_requirements() {
    for requirement in "${requirements[@]}"; do
        # See if the command exists on the system
        if ! command -v "$requirement" > /dev/null; then
            echo "Please install package \"$requirement\" first!"
            exit 1
        fi
    done
}

# Show a warning dialog using zenity.
#function show_dialog() {
#    zenity  --warning \
#            --text "Do not sleep in front of your computer too long! Take a break!" \
#            --width 300 \
#            --height 150
#}

function show_dialog() {
	notify-send \
		"Hello world service" \
		"Do not sit in front of your computer too long! Take a break!"
}

# Main function
function main() {
    check_requirements
    local time=""
    while true; do
        time="$(date '+%02S')"
        if [[ "$time" -eq 0 ]]; then
            show_dialog
        fi
        sleep 0.5
    done
}

# Entry point
main
