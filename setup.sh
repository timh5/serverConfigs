#!/bin/sh
#
# Creates local links for .dot files into ~/
#


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
if [ -e ~/.bash_profile ];then
	## Check if line exists
	tmp=`cat ~/.bash_profile | grep "\-f.$mydir"`
	if [ $? != 0 ];then
		echo "[ -f $mydir/.bash_profile ] && . $mydir/.bash_profile" >> ~/.bash_profile
	fi

else
	echo "[ -f $mydir/.bash_profile ] && . $mydir/.bash_profile" >> ~/.bash_profile
fi


cd ~/
ln -s $mydir

