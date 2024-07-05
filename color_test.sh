#!/bin/bash

source utils/jcktermio.inc
source utils/jckfuncalias.inc

#jck_logmsg "hello world"
#jck_logmsg_colored_formatted "GREEN" "\nhello world"
#jck_logmsg_colored_formatted "RED" " this is me."
#jck_logmsg hello world this is me

loge "wrong"
logcf "GREEN" "The processes have done without error.\n"
logcf "YELLOW" "Script exited with exit code 0.\n"
