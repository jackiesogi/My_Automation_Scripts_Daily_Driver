#!/usr/bin/env python3
import sys
import subprocess

# Read the command from stdin
command = sys.stdin.readline().rstrip()

# Execute the command
try:
    output = subprocess.check_output(command, shell=True, stderr=subprocess.STDOUT, universal_newlines=True)
    print(output)
except subprocess.CalledProcessError as e:
    print(e.output)

