#!/bin/sh
#
# Stops wowza, sets JARs and wconfig to a version (vN.NN) and starts wowza
# Usage: setwowzaversion <serverID> <vN.NN> [--force-restart]
# SERVER ID REQUIRED FOR EXTRA CONFIRMATION
#
# Sequence of events:
# - Check if vN.NN exists in git, if not, create new version in git and switch to it
#			(note: the new version should branch off the latest)
# - call shutdownkill.sh 
# - if exit 0, git pull, git checkout vN.NN
# - if ok, updatewconfig.sh vN.NN
# - startup.sh
#

WOWZADIR=/opt/WowzaMediaServerPro
LIBDIR="$WOWZADIR/lib"
BINDIR="$WOWZADIR/bin"
SHUTDOWN=shutdownkill.sh
STARTUP="startup.sh"
UPDATE=updatewconfig.sh
GIT=/usr/bin/git
SERVERID=$1
VERS=$2


# Checkin JARs on dev
ssh root@unity.dev.vyew.com /opt/vyew/wowza/checkinDev.sh 

# Make sure serverID makes sense
serverIDok=0
HN=`hostname`
if [ ! -z $SERVERID ];then 
    [[ $SERVERID == 4 ]] && [[ "`hostname`" =~ "(red5.web1|unity.dev)" ]] && serverIDok=1
    [[ $SERVERID == 5 ]] && [[ "`hostname`" =~ "red5.web2" ]] && serverIDok=1
    [[ $SERVERID == 7 ]] && [[ "`hostname`" =~ "red5.db1.vyew.com" ]] && serverIDok=1
    [[ $SERVERID == 8 ]] && [[ "`hostname`" =~ "dev2.vyew.com" ]] && serverIDok=1
    [[ $SERVERID == 9 ]] && [[ "`hostname`" =~ "red5.ph1hn1.vyew.com" ]] && serverIDok=1
    [[ $SERVERID == 10 ]] && [[ "`hostname`" =~ "red5.ph1hn2.vyew.com" ]] && serverIDok=1
    [[ $SERVERID == 11 ]] && [[ "`hostname`" =~ "red5-11.ph1hn2.vyew.com" ]] && serverIDok=1
    [[ $SERVERID == 12 ]] && [[ "`hostname`" =~ "red5-12.ph1hn1.vyew.com" ]] && serverIDok=1
	[[ $serverIDok != 1 ]] && echo "ServerID passed ($SERVERID) doesnt match hostname ($HN) in $0" && VERS=
fi

[ "$3" == "--force-restart" ] && DORESTART=1 || DORESTART=0
[[ $DORESTART == 1 ]] && echo "Will restart wowza" || echo "Will not restart wowza"

cd $BINDIR
[ "$?" != 0 ] || [ ! -d $BINDIR ] || [ ! -d $LIBDIR ] && echo "Cant find wowza bin dir: $BINDIR" && exit 1

if [ ! -f $GIT ] || [ ! -f $SHUTDOWN ] || [ ! -f $STARTUP ] || [ ! -f $UPDATE ]; then
	echo "Missing a required file: $GIT, $SHUTDOWN, $UPDATE or $STARTUP"
	exit 254
fi

[ -z $VERS ] && echo "Usage: $0 <serverID> <vN.NN> [--force-restart]" && exit 255

if [ ! -d ../bin ] || [ ! -d $LIBDIR ];then
	echo "Must be run from the wowza /bin directory"
	exit 255
fi



# @usage 	chkGitVersionExists vN.NN
# @return 	INT: 0-ok, 1-no
# and echoes a status or error message
function chkGitVersionExists
{
	cd $LIBDIR
	tmp=`git status|grep modified`
	[ $? == 0 ] && echo "git status fail: $PWD has modified files" && return 1
	tmp=`git status|grep on.branch -i`
	[ $? != 0 ] && echo "Error running git status on $PWD" && return 1
	tmp=`git fetch`
	[ $? != 0 ] && echo "Error fetching in $PWD" && return 1
	tmp=`git branch -a|egrep "[ /]$1$"` 
	[ $? == 0 ] && return 0
	
	echo "Branch $1 does not exist in $PWD"
	cd -	
	return 1
}

# Creates a new branch based on latest version
function makeNewGitVersion
{
	newVer=$1;
	cd $LIBDIR
	echo "Looking for latest version to branch to...";
	latestVer=`git branch|egrep -v '\*'|grep 'v[0-9]'|sort -r|head -n1|sed -r 's/[\* ]//g'`
	if [ "$latestVer" == "" ];then
		echo "Cant find it!!";
		return 0
	fi
	
	echo "Found latest version: $latestVer"
	echo "Checking out latest version: $latestVer"
	git checkout $latestVer

	git push origin $latestVer:$newVer
	git checkout $newVer	
	return $?
}


# Checks out a branch locally, if not, from remote
# @usage: gitCheckoutVer <branch>
#
function gitCheckoutVer
{
	[ -z $1 ] && return 1
	cd $LIBDIR
	# see if branch already checked out locally
	RTN=1
	BRANCH=`git branch|sed -r 's/\*//'|awk '{print $1}'|grep "^$1$"`
	if [ $? == 0 ];then
		echo "Checking out $BRANCH in $LIBDIR"
		git checkout $BRANCH  >/dev/null
		git pull
		RTN=$?
	elif [ $? != 0 ]; then
		BRANCH=`git branch -a|sed -r 's/\*//'|awk '{print $1}'|egrep "\/$1$"`
		[ $? != 0 ] && echo "Couldnt find branch $1 in $LIBDIR" && return 1
		echo "Checking out $BRANCH to $LIBDIR"
		git checkout $BRANCH --track >/dev/null
		RTN=$?
	fi
	return $RTN
}


function getGitStatus
{
	cd $LIBDIR
	git status | grep -i on.branch
	exit 0	
}






## ------------------------------------------------- MAIN
## ------------------------------------------------- MAIN
## ------------------------------------------------- MAIN


if [ "$VERS" == "check" ]; then
	getGitStatus
fi

echo "checking: $VERS"
chkGitVersionExists $VERS
if [ $? == 1 ];  then
	makeNewGitVersion $VERS
	[ $? != 0 ] && echo "Failed to create new branch" && exit 1
fi

if [ $DORESTART -eq 1 ];then 
	cd $BINDIR
	sh $SHUTDOWN
	[ $? != 0 ] && echo "Failed to shutdown wowza" && exit 1
fi

gitCheckoutVer $VERS
[ $? != 0 ] && echo "git Checkout errored out" && exit 1

cd $BINDIR
/bin/sh $UPDATE $VERS
[ $? != 0 ] && echo "Problem updating wconfig.txt" &&  exit 1
echo "Updated wconfig.txt with $VERS"

if [ $DORESTART -eq 1 ];then
	echo "Starting wowza"
	cd $BINDIR
	sh $STARTUP >/dev/null 2>&1
	[[ $? != 0 ]] && echo "Startup Failed" && exit 1

	## Make sure it worked
	sleep 4
	tmp=`ps aux|grep com.wowza|grep -v grep|grep com.wowza`
	[[ $? != 0 ]] && echo "Startup failed" && exit 1

	sleep 4
	tmp=`ps aux|grep com.wowza|grep -v grep|grep com.wowza`
	[[ $? != 0 ]] && echo "Startup failed" && exit 1
	
	sleep 5
	tmp=`ps aux|grep com.wowza|grep -v grep|grep com.wowza`
	[[ $? != 0 ]] && echo "Startup failed" && exit 1
fi

echo "Restart OK"
exit 0


