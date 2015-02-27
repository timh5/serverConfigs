#!/bin/sh
#
#	How to use - 
#		1. With firebug in firefox, login to support email acct
#		2. In firebug goto HTML tab, select the root HTML note and copy it
#		3. Paste it into a text file on this server
#		4. run parsewebinaremails.sh <text_filename>
#
#

# TODO .. the script isnt working, so replace step 4 above, and run this manually:

#cat $infile | grep 'Webinar Reg' | sed -r 's/.*email="([^"]*)"(.*)/\1\t\2/' | sed 's/","/\t/g' | cut -f1,8 | grep -v 'support.vyew.com' | sed 's/",.*//'

SEARCHWORD="Webinar Reg"

infile=$1
cp $infile $infile.tmp
infile=$infile.tmp

pl=`grep -n  'VIEW_DATA' $infile | cut -f1 -d:`
sed "$pl,999999p" $infile -n -i

pl=`grep '<\/script>' -n $infile | cut -f1 -d:`
sed "1,${pl}p" $infile -n -i
sed 's/<\/script>.*/<\/script>/' $infile -i

sed 's/\\u003d/=/g' $infile -i
sed 's/\\u003c/</g' $infile -i
sed 's/\\u003e/>/g' $infile -i
sed 's/\\"/"/g' $infile -i

cat $infile | grep "$SEARCHWORD" \
	| sed -r 's/.*email="([^"]*)"(.*)/\1\t\2/' \
	| sed 's/","/\t/g' | cut -f1,8 \
	| grep -v 'support.vyew.com' | sed 's/",.*//'

echo "------------------------------------------"

for e in `cat $infile | grep "$SEARCHWORD" \
	| sed -r 's/.*email="([^"]*)"(.*)/\1\t\2/' \
	| sed 's/","/\t/g' | cut -f1 \
	| grep -v 'support.vyew.com' | sed 's/$/,/' `;
	do
	echo -n "$e "
done


