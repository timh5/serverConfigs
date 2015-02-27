#!/bin/sh
# 
# Sends shutdown command to wowza,
# waits a timeout period, and checks that it shut down,
# if not, sends a kill command, and waits
# if that doesnt work, sends a kill -9
#
# @exitstatus	0 - shutdown ok
#				1 - shutdown failed
#

. ./setenv.sh
$_EXECJAVA -Dcom.wowza.wms.AppHome="$WMSAPP_HOME" -Dcom.wowza.wms.ConfigHome="$WMSCONFIG_HOME" -cp $WMSAPP_HOME/bin/wms-bootstrap.jar com.wowza.wms.bootstrap.Bootstrap stop
echo "Sent stop event"


## sleep 10 and ps aux|grep wowza
timeout=7
timeout_sec=`expr $timeout \* 60`

echo "Verifying stop ($timeout min timeout)..."
starttime=`date +%s`
while [ 1 ];do
	
	# Check if wowza exists in ps
	tmp=`ps aux|grep 'java.*WowzaMediaServer'|grep -v grep|grep Wowza`
	if [ $? == 1 ];then
		echo "Shutdown OK"
		exit 0
	fi

	# Check timeout
	now=`date +%s`
	diff=`expr $now - $starttime`
	if [ $diff -gt $timeout_sec ];then 
		echo "Timeout waiting for stop. Attempting to kill"
		break;
	fi

	sleep 7
done


echo "Stop event failed. Sending kill command."

## Find a wowza PID
pid=`ps aux|grep 'java.*WowzaMediaServer'|grep -v grep|grep Wowza |awk '{print $2}'`
if [ $pid -gt 0 ];then
	kill $pid	
else
	echo "ERROR Couldnt find Wowza PID"
	exit 1
fi


starttime=`date +%s`
while [ 1 ];do

	sleep 7

        # Check if wowza exists in ps
        tmp=`ps aux|grep 'java.*WowzaMediaServer'|grep -v grep|grep Wowza`
        if [ $? == 1 ];then
                echo "Shutdown OK"
                exit 0
        fi

	# Check timeout
	now=`date +%s`
        diff=`expr $now - $starttime`
        if [ $diff -gt $timeout_sec ];then
                echo "Timeout waiting for kill. Attempting to kill -9"
                break;
        fi
done


## Find a wowza PID
pid=`ps aux|grep 'java.*WowzaMediaServer'|grep -v grep|grep Wowza |awk '{print $2}'`
if [ $pid -gt 0 ];then
        kill -9 $pid
else
        echo "ERROR Couldnt find Wowza PID"
        exit 1
fi


sleep 10

## Check again if its killed
tmp=`ps aux|grep 'java.*WowzaMediaServer'|grep -v grep|grep Wowza`
if [ $? == 1 ];then
	echo "Shutdown OK"
	exit 0
fi

echo "ERROR kill -9 failed"
exit 1




