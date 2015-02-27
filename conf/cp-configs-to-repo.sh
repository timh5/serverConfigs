#!/bin/sh

if [ "$1" == "--help" ];then
	echo "Will copy all relevant config files into a directory corresponding with hostname"
	echo "Usage: $0 [hostname-directory]"
	echo "Examples: 	1. $0 - will copy configs into matching host name of this box into the directory "
	echo "         		2. $0 dev.vyew.com - will copy into dev.vyew.com directory"
	exit
fi

if [ "$1" == "" ];then
	host=`hostname`;
else
	host=$1
fi



### Apache
cp -vf /etc/httpd/conf $host/etc-httpd-conf-httpd.conf 
mkdir -p $host/etc-httpd-conf.d
cp -vf /etc/httpd/conf.d/* $host/etc-httpd-conf.d

### Certs
mkdir -p $host/etc-pki-tls-certs
cp -vf /etc/pki/tls/certs/* $host/etc-pki-tls-certs
mkdir -p $host/etc-pki-tls-private
cp -vf /etc/pki/tls/private/* $host/etc-pki-tls-private

### PHP/Mysql
cp -vf /etc/my.cnf 	$host/etc-my.cnf
cp -vf /etc/php.ini 	$host/etc-php.ini

### Unity
cp -vf /opt/unity/policy.xml 	$host/opt-unity-policy.xml
cp -vf /opt/unity/uconfig.txt 	$host/opt-unity-uconfig.txt
cp -vf /opt/unity/uconfig.xml 	$host/opt-unity-uconfig.xml

### Conversions
cp -vf /home/converter			$host/home-converter-conv.sh
cp -vf /home/converter/DocumentConverter.py  $host/home-converter-DocumentConverter.py

### Wowza
cp -vf /opt/WowzaMediaServerPro/bin/wconfig.txt $host/opt-WowzaMediaServerPro-bin-wconfig.txt
mkdir -p $host/opt-WowzaMediaServerPro-conf
cp -vfa /opt/WowzaMediaServerPro/conf/* $host/opt-WowzaMediaServerPro-conf



