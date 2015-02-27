#!/bin/sh
#
# Check for a memory error in wowza
# If one exists, and server has not been restarted in the last hour,
# Then restart it
#

LOG=/var/log/wowza.restart.log
TSTAMP_LOG=$LOG.tstamp
ERRLOG="/opt/WowzaMediaServerPro/bin/wowza.err"

## IF no timestamp log, put a valid time in there that way old
[ ! -e $TSTAMP_LOG ] && echo 1311000000 > $TSTAMP_LOG

now=`date +%s`

# See how many lines in error log
TOTLINES=`tail -n50000 $ERRLOG | wc -l`

# Look for error
tmp=`tail -n50000 $ERRLOG | grep OutOfMemoryError -n`
if [ "$?" == "0" ];then

	## Found an error, so gather some info
    ERRLINE=`echo $tmp|tail -n1|awk 'BEGIN{FS=":"};{print $1}'`
	echo "" |tee -a $LOG
	date "+%Y-%m-%d %H:%I:%S" |tee -a %LOG
    echo "$now: OutOfMemoryErr found on line $ERRLINE of last $TOTLINES lines" | tee -a $LOG
    echo "$now: $tmp" |tee -a $LOG
	
	## Check if restarted recently
	linec=`wc -l $TSTAMP_LOG`
	lastrestart=`tail -n1 $TSTAMP_LOG`

	if [ $lastrestart ] && [ "$lastrestart" -gt "1310000000" ] && [ "$lastrestart" -lt "$now" ];then
		## last restart date is within bounds, see if it was more than an hour ago
		diff=`expr $now - $lastrestart`
		if [ $diff -gt 3600 ];then
			## Its older than hour, so restart
			echo "Restarting..." | tee -a $LOG
			echo $now >> $TSTAMP_LOG
			## Do restart here
		else
			echo "WARNING: Was just restarted!" | tee -a $LOG
		fi

	else
		echo "FAIL: Last Restart date is out of bounds: $lastrestart" | tee -a  $LOG
	fi
else
	echo "$now: OK"
fi




