#!/bin/sh
OVB=/opt/vyew/bin

log=/var/log/vyew/sentMtgReminders.log
hn=`hostname`
[ ${hn:0:3} != "www" ] && log="/vz/private/25$log"

uldate=`tail -n8 $log|egrep '^\[[0-9]{4}-[0-9]{2}'|tail -n1|sed -r 's/^.([^]]+).*/\1/'`
ldate=`$OVB/utc2epoch "$uldate"`
now=`date +%s`
maxtime_sec=1000

diff=`expr $now - $ldate`
if [ $diff -gt 0 ] && [ $diff -lt $maxtime_sec ];then
	echo "OK - Sched Meets reminders ran $diff seconds ago"
	exit 0
else
	echo "FAIL - Sched Meets Reminders ran $diff seconds ago ($uldate)"
	exit 1
fi


