#!/usr/bin/env bash

# Stack initialization
stack=()
stack_top=-1

# Stack operations
push_stack() {
	if [[ $# -gt 0 ]]; then
		for element in $@; do
			stack+=("$element")
		done
	fi

	stack_top=$((stack_top + $#))
}

pop_stack() {
	if [[ $1 -gt 0 ]]; then
		for ((i = 0 ; i < $1 ; i++)); do
			local position=$((stack_top - $i))
			#echo "unset stack[$position]"
			unset stack[$position]
		done
	fi
	stack_top=$((stack_top - $1))
}

print_stack() {
	echo "${stack[@]}"
}

print_top() {
	echo $stack_top
}
