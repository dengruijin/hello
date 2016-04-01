#!/bin/bash

servers=(
	"root@192.168.40.111"
	"root@192.168.40.114"
	"root@192.168.40.119"
	"root@192.168.40.234"
	"QUIT"
)
PS3="Connect to server? "
select server in "${servers[@]}"; do
	if  [[ -z "$server" ]];then
		echo "please type the valid number:"
		continue
	fi
	if [[ "$server" == "QUIT" ]];then
		echo "Exiting.."
		exit 0
	fi
	echo "Connecting to $server"
	ssh "$server"
done
