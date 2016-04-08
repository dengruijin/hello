#!/bin/sh 
TMPFILE=/tmp/snapshot.log.$$

{
	echo "=== Rsync from /data/ to /snapshot/: $(date)"
	mount -o rw,remount /dev/sdc
	rsync -av /data/ /snapshot/
	rc=$?
	mpunt -o ro,remount /dev/sdc
	
	if [[ $rc -eq 0 ]];then
		echo "===Snapshot succeeded: $(date)"
		SUBJECT="Snapshot report (succeeded)"
	else
		echo "===Snapshot failed with rc=$rc: $(date)"
		SUBJECT="Snapshot report (failed)"
	fi
} 2>&1 | tee $TMPFILE | logger -t "snapshot"

iconv -f utf-8 -t iso-2022-jp $TMPFILE | mail -s "$SUBJECT" admin@example.com
