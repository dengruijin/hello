#!/bin/sh

status=""

while [[ true ]]; do
	pgrep -x httpd >/dev/null 2>&1
	rc=$?
	if [[ $rc -eq 0 && "$status" != "up"]]; then
		status="up"
		logger -t "monitor" "httpd is up"
	fi
	if [[ $rc -ne 0 && "$status" != "down"]]; then
		status="down"
		logger -t "monitor" "httpd is down"
	fi
	sleep 10
done
