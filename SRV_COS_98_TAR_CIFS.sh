#!/bin/bash
echo
echo ##########################
echo # Creado por:  gomgardav #
echo # [ David Gómez García ] #
echo ##########################
echo

log=./srv_cos_98_salida.sal
cd ~/samba || exit
source ./00_00_VAR.sh

rm -rf ./samba*

find . \( -name '*.csv' -or -name '*.txt' -or -name '*.cmd' -or -name '*.conf' -or -name '*.sh' -or -name '*.sal' -or -name '*.his' -or -name '*.ldif' \) -print0 | \
    xargs -0 tar -vzcf $VarExa.tar.gz

mkdir /mnt/lucus

read -p "Escribe la Contraseña de gomgardav para continuar..." PSWD
mount -t cifs //172.16.0.52/2_adsiinre/aso/gomgardav /mnt/lucus -o domain=iescalquera.net,username=gomgardav,password=$PSWD
