#!/bin/sh

# usage: ./ssh-read.sh hostname < servers.txt
while read server; do
	ssh -n "$server" "$@" 2>&1 | sed "s/^/$server: /" &
done
wait
