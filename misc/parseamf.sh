#!/bin/sh

#parses amf logs out to find out which cgi calls were never completed
#each call starts with "randid ###########"
#and ends with "endrand ##########" 
#where ###### = unique id

#usage: parseamf.sh <file> [lines to tail, default=10,000]

if [ "$2" == "" ];then
	LINES=$2
else
	LINES=10000
fi


tail $1 -n$LINES  \
| sed -r 's/[^a-zA-Z0-9\.\: \t-]//g' \
| sed -r 's/(.*)(endrand.*)/\2/g' \
| awk '{print  $1 " " $2}' \
| sort -k2 \
| uniq -c -f1 \
| sort -r

#tail
#strip out all binary data
#strip out all but "endrand", on "endrand" lines
#strip all but columns 1 and 2
#sort on col2
#uniq sort on col2 (which is field1)
#sort in reverse so we can see the single pairs at the bottom



#sed -r 's/(.*)(rand.*)/\2/g'  | awk '{print  $2 " " $3}' | sort | uniq -c | sort -r

