#!/usr/bin/env bash

source $(dirname "$BASH_SOURCE")/jcktermio.inc
source $(dirname "$BASH_SOURCE")/jckdbgutils.inc

function logcf {
	jck_logmsg_colored_formatted "$@"	
}

function loge {
	jck_logmsg "$@"
}
