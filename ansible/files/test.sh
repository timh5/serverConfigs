#!/bin/bash
hn=$1;
hn2=`hostname`

if [ "$hn" == "$hn2" ];then
	echo "OK $hn"
	exit 0;
fi
	echo "Looking for $hn, but found $hn2"
	exit 1
fi
