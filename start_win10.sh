## NAME: win10
## DESCRIPTION: Starts the required environments for windows 10 kvm virtual machine.
## AUTHOR: Jackie Chen

#!/usr/bin/env bash

source utils/jckfuncalias.inc

sudo systemctl stop named.service
logcf "BLUE" "Temporarily disable /etc/systemd/system/named.service...\n"

sleep 1

sudo virsh net-start default
logcf "BLUE" "Starting the NAT network for the virtual machine...\n"

sleep 1
sudo virsh start Windows10 & >/dev/null 2>&1
logcf "BLUE" "Trying to start the virtual machine...\n"

sleep 1
sudo systemctl start named.service
logcf "BLUE" "Restarting the named service again in order to connect to the internet...\n"

sleep 2
logcf "GREEN" "Done!\n"

