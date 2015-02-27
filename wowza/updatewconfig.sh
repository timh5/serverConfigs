#!/bin/sh
#
# Updates version number in wconfig
# Usage: updatewconfig vN.NN
#

SREPLACE="/opt/vyew/bin/sreplace"
FILENAME=wconfig.txt
VERS=$1

# Usage: doReplace <file> <version>
function doReplace
{
	FILE=$1
	VERS=$2
	cp -f $FILE $FILE.bak
	$SREPLACE -nqf v[0-9]+\.[0-9]+[a-z]? $VERS $FILE  >/dev/null

	## NOW MAKE SURE IT WORKED

	LN=`cat $FILE | grep $VERS | wc -l`
	if [ $LN -lt 2 ] || [ $LN -gt 4 ];then
   	 	echo "ERROR: There are $LN lines with $VERS in $FILE"
   	 	return 1
	fi
	return 0
}


## If file exists, use it
if [ ! -z $2 ] && [ -f $2 ] ;then		
	FILE=$2

## Check if file passed in is a directory
elif [ ! -z $2 ] && [ -d $2 ] && [ -f "$2/$FILENAME" ] ;then
	FILE="$2/$FILENAME"
else
	FILE=$FILENAME
fi

## If FILE still not found, look in ..
[ ! -f $FILE ] && FILE="../$FILENAME"

if [ ! -f $FILE ] || [[ $VERS != v[0-9]* ]];then
	ME=`basename $0`
	echo "Update the version number in wconfig.txt"
	echo "Usage: $ME vN.NN [/path/to/wconfig.txt]"
	echo "Should be run in same directory as wconfig.txt, if path to wconfig not specified"
	exit 255
fi

doReplace $FILE $VERS
[[ $? != 0 ]] && echo "There was a problem updating $FILE" && exit 1

## Just in case, also replace file in ../wconfig.txt if it exists
cd ..
[ -f $FILE ] && doReplace $FILE $VERS

exit 0
