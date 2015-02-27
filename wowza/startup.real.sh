#!/bin/sh
. ./setenv.sh

mv wowza.err.3 wowza.err.4
mv wowza.err.2 wowza.err.3
mv wowza.err.1 wowza.err.2
mv wowza.err wowza.err.1

addtime ()
{
        while read line; do
                echo "`date +%H:%M:%S`: $line" >> wowza.err
        done
}


ERR=`mktemp /tmp/annotate.XXXXXX` || exit 1

rm -f $ERR

mkfifo $ERR || exit 1

addtime < $ERR &

#chmod 600 ../conf/jmxremote.password
#chmod 600 ../conf/jmxremote.access

# NOTE: Here you can configure the JVM's built in JMX interface.
# See the "Server Management Console and Monitoring" chapter
# of the "User's Guide" for more information on how to configure the
# remote JMX interface in the [install-dir]/conf/Server.xml file.

JMXOPTIONS=-Dcom.sun.management.jmxremote=true
#JMXOPTIONS="$JMXOPTIONS -Djava.rmi.server.hostname=192.168.1.7"
#JMXOPTIONS="$JMXOPTIONS -Dcom.sun.management.jmxremote.port=1099"
#JMXOPTIONS="$JMXOPTIONS -Dcom.sun.management.jmxremote.authenticate=true"
#JMXOPTIONS="$JMXOPTIONS -Dcom.sun.management.jmxremote.ssl=false"
#JMXOPTIONS="$JMXOPTIONS -Dcom.sun.management.jmxremote.password.file=$WMSCONFIG_HOME/conf/jmxremote.password"
#JMXOPTIONS="$JMXOPTIONS -Dcom.sun.management.jmxremote.access.file=$WMSCONFIG_HOME/conf/jmxremote.access"

ulimit -n 20000

CDOPTS="-Djcd.tmpl=javalang,wowza -Djcd.dest=udp://reporting.dev.vyew.com:25826 -Djcd.host=red5.web1 -Djcd.instance=wowza -javaagent:collectd.jar"

# log interceptor com.wowza.wms.logging.LogNotify - see Javadocs for ILogNotify

nohup ./logwatcher.pl &
sleep 1

echo "`date +%H:%M:%S` I: Started" >> wowza.err

nohup $_EXECJAVA $JAVA_OPTS $JMXOPTIONS $CDOPTS -Dcom.wowza.wms.AppHome="$WMSAPP_HOME" -Dcom.wowza.wms.ConfigURL="$WMSCONFIG_URL" -Dcom.wowza.wms.ConfigHome="$WMSCONFIG_HOME" -cp $WMSAPP_HOME/bin/wms-bootstrap.jar com.wowza.wms.bootstrap.Bootstrap start > wowza.log.fifo 2>>$ERR ; EXIT=$?

rm -f $ERR
wait

echo "`date +%H:%M:%S` I: Finished with exitcode $EXIT" >> wowza.err

exit $EXIT
