#!/bin/sh

if [ "$1" == "" ];then
	echo "Usage: . $0 </path/to/add/>";
	exit 1;
fi

PATH="$PATH:$1";
echo "New path:$PATH"
export PATH
