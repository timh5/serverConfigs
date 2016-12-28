#!/bin/bash
#
# simple syncing script
# usage: dont.sync.sh [-n|-c|-h] [filename (if a filename is set, sync the file only)]
# 	-n 	dry run only
#	-c	check sync only
# 	

# exit out if any params are directories
if [ $1 ] || [ $2 ];then
	if [ -d $1 ] || [ -d $2 ]; then
		echo "Error: do not specifiy a directory for a param. File only."
		#exit 255
	fi
fi

# Make sure only run from web2
ifconfig | grep -E 'inet addr:[0-9.]*?\.25' >/dev/null
if [ $? -ne 0 ]; then
        echo "ARE YOU CRAZY?! ONLY RUN THIS FROM WEB2"
        exit
fi

# Make sure only run from certain directories
MYDIR=`pwd`
tmp=`echo $MYDIR|egrep '(\/data\/vhosts|\/root\/vyew|\/opt\/vyew)'`
if [ $? -ne 0 ];then
	echo "MUST RUN THIS IN A SUBDIR or /data/vhosts"
	exit 2
fi


SYNC_DIR=$PWD
DEST_USER=root
DEST_PATH=$PWD
DEST_HOST=192.168.156.15

RSYNC_EXCLUDE='.git *.flock *.ob *.flm tmp.* *.tmp *.$wf *.\$wf /log/* screens math copy chats _rsync_backup .rsync_backup vyewtubecache *screendev* *.zip *.ppt cache/* *VoteResults* .svn .DS_Store .*.sw? *~ *.log logs *.cache *.out *_page*.swf recordings/ captchas/ v3*/ v4.0*/ v4.1*/ objectcache/ dbcache/ pgcache/'

#Convert EXCL string to proper exclude file format (sepr by \n)
echo "$RSYNC_EXCLUDE" > .rsync_excl.tmp
sed 's/ /\n/g' .rsync_excl.tmp -i

OPT_RSYNC="";
OPT_EXCL="--exclude-from .rsync_excl.tmp";
DT=`/bin/date +%Y%m%d-%H%M-%S`
while getopts "nch" flag;do
   case $flag in
    n)  OPT_RSYNC="-n";;
    c)  
		rsync -n -va -essh -q  \
			--exclude 'recordings/' \
			--exclude '/logs' --exclude cache --include '*/' \
			--exclude 'log/*' \
			--include '*.swf' --include '*.xml' \
			--include '*.js' --include '*.css' \
			--include '*.html' \
			--include '*.php' --exclude '*'  -m \
			$SYNC_DIR/ root@192.168.156.15:$SYNC_DIR \
			| grep -v '\/$' \
			| grep -v 'rsync_backup' \
			| grep -v 'screens' \
			| grep -v 'screendev' \
			| grep -v 'dev\.' \
			| grep -v 'userver..xml' \
			| grep -v '\.doc\.swf' \
			| grep -v 'config.inc' \
			| grep -v 'TestFlash' \
			| grep -v 'bak\.'

		exit
		;;

    h)  echo "Usage: $0 [-n = dryrun | -c = check sync ]";
		exit;;
   esac
done

echo "Syncing $PWD"



## if were on ph1 web2, then sync to ph1 web1 and dev2
if [ `hostname` == 'www1.ph1hn2.vyew.com' ];then

	DEST_HOST=www1.ph1hn1.vyew.com
	OPT_RSYNC="$OPT_RSYNC -va -essh --backup --delete --backup-dir .rsync_backup --progress"
	#OPT_RSYNC="$OPT_RSYNC -va -essh  --delete  --progress"
	rsync $OPT_RSYNC --include '.htaccess' --include '*.php' $OPT_EXCL $SYNC_DIR/$1 $DEST_USER@$DEST_HOST:$SYNC_DIR 

	## Sync to web1.dev2
	DEST_HOST=web1.dev2.vyew.com
	#rsync $OPT_RSYNC --include '.htaccess' --include '*.php' $OPT_EXCL $SYNC_DIR/$1 $DEST_USER@$DEST_HOST:$SYNC_DIR 



## if were on the old web2 (atl), then error out for now
else
	echo "NOT ON ph1hn2!!"
	exit

	OPT_RSYNC="$OPT_RSYNC -va -essh --backup --delete --backup-dir .rsync_backup --progress"
	#OPT_RSYNC="$OPT_RSYNC -va -essh  --delete  --progress"
	rsync $OPT_RSYNC --include '.htaccess' --include '*.php' $OPT_EXCL $SYNC_DIR/$1 $DEST_USER@$DEST_HOST:$SYNC_DIR 
fi

exit





DEST_HOST=www1.ph1hw1.vyew.com
#echo "-------- Sync to $DEST_HOST"
#rsync $OPT_RSYNC --include '.htaccess' --include '*.php' $OPT_EXCL $SYNC_DIR/$1 $DEST_USER@$DEST_HOST:$SYNC_DIR 


DEST_HOST=www1.ph1hn2.vyew.com
echo "-------- Sync to $DEST_HOST"
rsync $OPT_RSYNC --include '.htaccess' --include '*.php' $OPT_EXCL $SYNC_DIR/$1 $DEST_USER@$DEST_HOST:$SYNC_DIR 
