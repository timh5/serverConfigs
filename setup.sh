#!/bin/sh
#
# Creates local links for .dot files into ~/
#

# because ubuntu uses ~/.profile, not .bash_profile
if [ "$1" == "" ];then
	profileFileName=.bash_profile
else
	profileFileName=$1
fi


cd `dirname $0`
mydir=$PWD

# linkfile ~/.filename
function linkfile
{
	[ "$1" == "" ] && exit
	file=$1
	dir=`dirname $file`
	fname=`basename $file`
	now=`date +%s`
	[ -h $file ] && echo "ALREADY A SYMLINK: $file" && return 
	[ ! -f $mydir/$fname ] && echo "Missing file: $mydir/$fname" && return 255
	[ -f $file ] && cp $file /tmp/$fname.$file.$now
	[ -f $file ] && mv $file $file.bak
	cd $dir
	ln -sv $mydir/$fname 
}

linkfile ~/.gitconfig
linkfile ~/.vimrc
linkfile ~/.screenrc


## setup .bash_profile
if [ -e ~/$profileFileName ];then
	## Check if line exists
	tmp=`cat ~/$profileFileName | grep "\-f.$mydir"`
	if [ $? != 0 ];then
		echo "[ -f $mydir/$profileFileName ] && . $mydir/$profileFileName" >> ~/$profileFileName
	fi

else
	echo "[ -f $mydir/$profileFileName ] && . $mydir/$profileFileName" >> ~/$profileFileName
fi


cd ~/
[ ! -e $mydir ] && ln -s $mydir

exit 0
