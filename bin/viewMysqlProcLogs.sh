#!/bin/bash

LOG=/var/log/mysqlprocs.log

if [ "$1" == "reset" ];then
	cat $LOG >> $LOG.1
	>$LOG
	echo "Truncated $LOG"
	exit
fi

if [ "$1" != "-l" ]; then

cat /var/log/mysqlprocs.log | \
egrep -v 'NULL$' | \
sed -r 's/Locked[^a-z]+(INSERT|SELECT|DELETE|UPDATE).*/Locked (query hidden)/i' | \
sed -r 's/^(.{600}).*/\1 (chopped)/' | \
less




else

cat /var/log/mysqlprocs.log | \
egrep -v 'NULL$' | \
sed -r 's/Locked[^a-z]+(INSERT|SELECT|DELETE|UPDATE).*/Locked (query hidden)/i' | \
sed -r 's/^(.{600}).*/\1 (chopped)/' 

fi




