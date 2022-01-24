#!/bin/sh

samba_ver=$(lynx -dump -listonly https://download.samba.org/pub/samba/ | grep http | grep LATEST-IS-SAMBA- | awk -F'-' '{print $4}')
if [ $samba_ver == $() ]
then
	echo "Samba is Up to Date ( "$samba_ver" )" > /root/Descargas/samba-ver.txt
else
	sh /root/Descargas/download-samba.sh
fi
