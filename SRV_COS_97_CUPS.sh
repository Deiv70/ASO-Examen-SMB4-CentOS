#!/bin/bash
echo
echo ##########################
echo # Creado por:  gomgardav #
echo # [ David Gómez García ] #
echo ##########################
echo

cd ~/samba || exit
# source ./00_00_VAR.sh

dnf -y install cups cups-ipptool hplip
clear
lpadmin -p HP_Aula210 -E -v ipp://172.16.210.99/ipp
lpstat -t

getent passwd   > getentsrv_gomgardav_passwd.txt
lpr -P HP_Aula210 getentsrv_gomgardav_passwd.txt

getent group    > getentsrv_gomgardav_group.txt
lpr -P HP_Aula210 getentsrv_gomgardav_group.txt
