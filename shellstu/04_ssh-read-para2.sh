#!/bin/sh

# usage: ./ssh-read.sh  servers.txt free

file=$1
shift

while read server; do
	ssh -n "$server" "$@" 2>&1 | sed "s/^/$server: /" &
done < "$file"
wait
