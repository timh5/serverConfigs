#!/bin/sh
# USAGE: source /root/svn.tim/bin/timlib.sh

function nowiso {
	date "+%Y-%m-%d %H:%M:%S"
}
function nowepoch {
	 date +%s
}
# Converts iso format to epoch unix time: iso2sec "2008-12-11 01:00:01" = 1228986001
function iso2epoch {
    date +%s -d "$1"
}
# Convert epoch to iso date: sec2iso 1228986001 = 2008-12-11 01:00:01
function epoch2iso {
    date "+%Y-%m-%d %H:%M:%S" -d @$1
}
# Add or subtract hours to iso date: isooffset "2008-12-11 01:00:01" 8 = "2008-12-11 09:00:01"
function isooffset {
    ZONEOFFSET=$2;
    SECOFFSET=`expr $ZONEOFFSET \* 3600`
    ep=`iso2epoch "$1"`
    ep=`expr $ep + $SECOFFSET`
    epoch2iso $ep
}


