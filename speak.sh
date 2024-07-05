#!/usr/bin/env bash

# Related files
# 	crontab
#	during 12AM to 8AM `mimic3-server` is down

# Variables
PROGRAM="mimic3"
VOICE=('en_US/ljspeech_low' 'en_UK/apope_low')
WAVDIR="/home/jck/Downloads/temp"
PLAYER="aplay"
TEXT=""

function select_random_voice() {
    echo $((RANDOM % 2))
}

# Function to use when mimic3-server is on
function use_mimic3_server_on() {
    TEXT="$*"
    RANDOM_VOICE_INDEX=$(select_random_voice)
    SELECTED_VOICE="${VOICE[$RANDOM_VOICE_INDEX]}"
    curl -s -X POST --data "$TEXT" --output - "localhost:59125/api/tts?voice=$SELECTED_VOICE" | "$PLAYER" >/dev/null 2>&1
}

# Function to use when mimic3-server is off
function use_mimic3_server_off() {
    TEXT="$*"
    "$PROGRAM" --voice "en_US/ljspeech_low" "$TEXT" > "$WAVDIR/output.wav"
    "$PLAYER" "${WAVDIR}/output.wav"
    rm "${WAVDIR}/output.wav"
}

# Function to check the time and call appropriate function
function check_time_and_call_function() {
    HOUR=$(date +%H)
    if (( HOUR >= 5 && HOUR < 8 )); then
        use_mimic3_server_off "$1"
    else
        use_mimic3_server_on "$1"
    fi
}

# Main script
#if [[ $# -eq 1 ]]; then
    check_time_and_call_function "$*"
#fi

