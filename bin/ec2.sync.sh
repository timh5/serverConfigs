#!/bin/bash
#
# simple syncing script
# usage: dont.sync.sh [-n|-c|-h]
# 	-n 	dry run only
#	-c	check sync only
# 	

##MAKE SURE ONLY RUN FROM WEB2
ifconfig | grep -E 'inet addr:[0-9.]*?\.25' >/dev/null
if [ $? -ne 0 ]; then
        echo "ARE YOU CRAZY?! ONLY RUN THIS FROM WEB2"
        exit
fi


SYNC_DIR=httpdocs
DEST_USER=root
DEST_PATH=/data/vhosts/vyew.com
DEST_HOST=ec2.vyew.com

cd ~vyew


RSYNC_EXCLUDE='*.flock *.ob *.flm tmp.* *.tmp *.$wf *.\$wf /log/* screens math copy chats _rsync_backup .rsync_backup vyewtubecache *screendev* *.zip *.ppt cache *VoteResults* .svn .DS_Store .*.sw? *~ *.log logs *.cache *.out *_page*.swf recordings/ captchas/'


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
			$SYNC_DIR/ root@192.168.156.15:/data/vhosts/vyew.com/$SYNC_DIR \
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

echo "Sync running at $DT" >> sync.log
echo "Syncing httpdocs:"

OPT_RSYNC="$OPT_RSYNC -va -essh --backup --delete --backup-dir .rsync_backup --progress"
#OPT_RSYNC="$OPT_RSYNC -va -essh  --delete  --progress"

rsync $OPT_RSYNC --include '.htaccess' --include '*.php' $OPT_EXCL $SYNC_DIR/ $DEST_USER@$DEST_HOST:$DEST_PATH/$SYNC_DIR 



#if [ "$1" == "all" ]; then
#	sh ~vyew/web3.sync.sh
#else
#	echo !!!
#	echo Make sure to also run ~vyew/web3.sync.sh !
#fi



