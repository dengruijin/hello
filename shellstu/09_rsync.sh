#!/bin/sh

SERVER="user01@backup.example.com"
LOCAL="/home/user01/documents/"
REMOTE="/home/user01/backup/documents/"

LOCAL_TSFILE="/home/user01/.backup_timestamp"
REMOTE_TSFILE="/home/user01/.backup_timestamp"

function confirm {
	echo -n "$1"
	read answer
	if [[ $answer != "y" ]];then
		echo "Exit!"
		exit 0
	fi
}

function backup {
	rsync -n -av --delete $LOCAL ${SERVER}:${REMOTE}
	confirm "Are you sure to backup local files? (y/n)"
	rsync  -av --delete $LOCAL ${SERVER}:${REMOTE}
	ts_local=$( date +%Y%m%d%H%M%S )
	echo -n $ts_local > $LOCAL_TSFILE
	ssh $SERVER "echo -n $ts_local > $REMOTE_TSFILE"
}
function download {
	rsync -n -av --delete ${SERVER}:${REMOTE} $LOCAL
	confirm "Are you sure to download remote files? (y/n)"
	rsync  -av --delete  ${SERVER}:${REMOTE} $LOCAL
	ts_local=$( date +%Y%m%d%H%M%S )
	echo -n $ts_local > $LOCAL_TSFILE
}

ts_remote=$( ssh $SERVER "cat $REMOTE_TSFILE" )
ts_local=$( cat $LOCAL_TSFILE )
$ts_remote" echo "remote timestamp: $ts_remote"
$ts_local" echo "remote timestamp: $ts_local"
echo "----------------"

if [[ $1 == "backup" ]];then
	echo "Force backup."
	backup
	exit 0
fi

if [[ $1 == "download" ]];then
	echo "Force download."
	download
	exit 0
fi

if [[ $ts_local -ge $ts_remote ]]; then
	echo "local files is changed"
	backup
	exit 0
fi

if [[ $ts_local -lt $ts_remote ]]; then
	echo "remote files is changed."
	download
	exit 0
fi

