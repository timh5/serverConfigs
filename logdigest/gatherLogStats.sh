#!/bin/sh
#
# Records properties of certain log files and agregates them into one place
# so that collectd/rrdtool can graph it
#
# Since collectd is collecting every 10 seconds, and we only want check every 5mins or so,
# in between actually gathering stats, im going to print duplicates of the values for collectd
#

LOG=/var/log/logstats.log
DUPNUMBER=5
DUPSLEEP=10

# php.log - size

r1=`ls -l /vz/private/25/var/log/php.log|awk '{print $5}'`
r1="php.log-size $r1"


# wowza.err - size
r2=`ls -l /vz/private/24/usr/local/WowzaMediaServer-2.0.0/bin/wowza.err|awk '{print $5}'`
r2="wowza.err-size $r2"

# wowza.err - lines
r3=`wc -l /vz/private/24/usr/local/WowzaMediaServer-2.0.0/bin/wowza.err|awk '{print $1}'`
r3="wowza.err-lines $r3"


i=0
while [ $i -lt $DUPNUMBER ];do
	NOW=`date +%s`
	echo "$NOW $r1" |tee -a $LOG
	echo "$NOW $r2" |tee -a $LOG
	echo "$NOW $r3" |tee -a $LOG

	i=`expr $i + 1`
	sleep $DUPSLEEP
done


