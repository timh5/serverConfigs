#!/bin/sh

LOG=/var/log/dbsize.log

[[ "`hostname`" =~ "web2" ]] && VZ=21 || VZ=11
DBDIR="/vz/private/$VZ/data/mysql/vyew"

DT=`/bin/date +%s`
SZ=`ls -l $DBDIR | awk '{x+=$5}END{print x}'`

#echo -e "$DT\t$SZ" >> $LOG
echo -e "$SZ" >> $LOG

