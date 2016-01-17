#!/bin/sh


function monitor {
	pgrep -x $1 >/dev/null 2>&1
	return $?
}

if monitor "httpd";then
	status="up"
else
	status="down"
fi

while [[ true ]]; do
	monitor "httpd"
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
