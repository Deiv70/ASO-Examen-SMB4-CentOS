#!/bin/bash
echo
echo ##########################
echo # Creado por:  gomgardav #
echo # [ David Gómez García ] #
echo ##########################
echo

cd ~/samba || exit
# source ./00_00_VAR.sh

clear
getent passwd   > getentcli_gomgardav_passwd.txt
getent group    > getentcli_gomgardav_group.txt
