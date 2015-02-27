#!/bin/sh
#
# Checking JARs on dev
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
GIT=/usr/bin/git

echo "Checking in JAR files on dev...";

# Make sure serverID makes sense
serverIDok=0
HN=`hostname`
if [ "$HN" != "unity.dev.vyew.com" ];then
	echo "Can only run on dev!";
	exit 2;
fi

cd $LIBDIR
[ "$?" != 0 ] || [ ! -d $BINDIR ] || [ ! -d $LIBDIR ] && echo "Cant find wowza bin dir: $BINDIR" && exit 1

if [ ! -d ../bin ] || [ ! -d $LIBDIR ];then
	echo "Must be run from the wowza /bin directory"
	exit 255
fi

git ci -am'auto-checkin'
git push

echo " "
echo "------"
echo " "


