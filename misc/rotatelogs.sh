#!/bin/sh

mydir=`dirname $0`
cd $mydir

for LOGNAME in `ls *.log`;do

	[ ! -e $LOGNAME ] && continue
	echo "Rotating $LOGNAME..."
	[ -e $LOGNAME.2 ] && mv -f $LOGNAME.2 $LOGNAME.3
	[ -e $LOGNAME.1 ] && mv -f $LOGNAME.1 $LOGNAME.2
	if [ -e $LOGNAME ];then 
		tail -c50000000 $LOGNAME > $LOGNAME.1
		>$LOGNAME
	fi

done


