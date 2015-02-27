#!/bin/sh
#
# Creates local links for .dot files from /opt/vyew into ~/ (root)
#

# UsagE: linkfile ~/.filename
function linkfile
{
	file=$1
	dir=`dirname $file`
	fname=`basename $file`
	now=`date +%s`
	[ -h $file ] && echo "ALREADY A SYMLINK: $file" && return 
	[ ! -f /opt/vyew/$fname ] && echo "Missing file: /opt/vyew/$fname" && return 255
	[ -f $file ] && cp $file /tmp/$fname.$file.$now
	[ -f $file ] && mv $file $file.bak
	cd $dir
	ln -sv /opt/vyew/$fname 
}

linkfile ~/.gitconfig
linkfile ~/.vimrc


tmp=`cat ~/.bashrc | grep "\-f./opt/vyew/.bash"`
if [ $? != 0 ];then
	echo "[ -f /opt/vyew/.bash_profile ] && . /opt/vyew/.bash_profile" >> ~/.bash_prfile
	echo "Added source link to ~/.bash_profile"
fi

cd ~/
ln -s /opt/vyew 
