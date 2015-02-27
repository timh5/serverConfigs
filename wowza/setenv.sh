#!/bin/sh

_EXECJAVA=java
JAVA_OPTS="-Xmx1024M -XX:+HeapDumpOnOutOfMemoryError"

# Uncomment to run server environment (faster), Note: will only work if server VM install, comes with JDL
#JAVA_OPTS="$JAVA_OPTS -server"

# Better garbage collection setting to avoid long pauses
#JAVA_OPTS="$JAVA_OPTS -XX:+UseConcMarkSweepGC -XX:+CMSIncrementalMode -XX:NewSize=1024m"

# Uncomment to fix multicast crosstalk problem when streams share multicast port
#JAVA_OPTS="$JAVA_OPTS -Djava.net.preferIPv4Stack=true"

WMSAPP_HOME=/usr/local/WowzaMediaServer
WMSCONFIG_HOME=/usr/local/WowzaMediaServer
WMSCONFIG_URL=

export WMSAPP_HOME WMSCONFIG_HOME JAVA_OPTS _EXECJAVA
