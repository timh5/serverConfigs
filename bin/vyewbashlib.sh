#!/bin/bash
# USAGE: source /opt/vyew/bin/vyewbashlib.sh
# then... now=`nowiso`

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

# Convert epoch to iso date: epoch2iso 1228986001 = 2008-12-11 01:00:01
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


#Purpose:   for each file specified, checks if X days old, and deletes if so
#Usage:     deloldfiles 5 "/mydir/dir2/filesomething.*"   #deletes 5 day old files
#           deloldfiles 14 "/mydir/*"                   #deletes 2 week old files
function deloldfiles(){
    dayold=$1
    filelist=$2
    if [ {$filelist} ]; then
        #delete old logs
        for delfile in "$( /usr/bin/find $filelist -type f -mtime +$dayold )"; do
            /bin/rm -f $delfile
        done
    else
        echo "deloldfiles not used correctly. Usage: deloldfiles days \"filemask\""
    fi
}


# delete logfiles older than four weeks
#find $LOGPATH -name 'atop_*' -mtime +28 -exec rm {} \;


                                           
