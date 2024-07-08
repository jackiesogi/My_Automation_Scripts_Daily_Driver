#!/bin/bash

if [[ $# == 1 ]]; then
	source "${HOME}/.bashrc"
	alias "$1" | tr '=' ' ' | awk '{print$3}' | tr -d "'"
else
	echo "require only one argument"
fi
