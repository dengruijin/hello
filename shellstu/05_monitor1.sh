#!/bin/sh

while [[ true ]]; do
	pgrep -x httpd >/dev/null 2>&1
	rc=$?
	if [[ $rc -ne 0 ]]; then
		logger -t "monitor" "httpd is down"
	fi
	sleep 10
done
