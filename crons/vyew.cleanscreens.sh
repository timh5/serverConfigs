#!/bin/sh

echo RUNNING CLEANER >> /tmp/clean1.log
cd ~vyew/httpdocs/screens/live
nice -20 php clean.php >> /tmp/clean.log 2>&1
echo RUNNING CLEANER2 >> /tmp/clean1.log
cd ~vyew/httpdocs/screendev/livedev
nice -20 php clean.php >> /tmp/clean.log 2>&1
echo RUNNING CLEANER3 >> /tmp/clean1.log
cd /var/www/html/screens/live
nice -20 php clean.php >> /tmp/clean.log 2>&1
echo RUNNING CLEANER4 >> /tmp/clean1.log
cd /tmp/screens
nice -20 php clean.php >> /tmp/clean.log 2>&1
echo CLEANER DONE >> /tmp/clean1.log

