#!/bin/bash
echo
echo ##########################
echo # Creado por:  gomgardav #
echo # [ David Gómez García ] #
echo ##########################
echo

cd /mnt/_Shared || exit
log=./srv_cos_00_salida.sal
source ./00_00_VAR.sh

rm -rf ~/samba && mkdir ~/samba
\cp -rf . ~/samba/.
