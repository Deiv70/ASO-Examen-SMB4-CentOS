#!/bin/bash
echo
echo ##########################
echo # Creado por:  gomgardav #
echo # [ David Gómez García ] #
echo ##########################
echo

cd ~/samba || exit
export VariablesSh=00_00_VAR.sh
. ./"$VariablesSh"

find . \( -name '*.csv' -or -name '*.txt' -or -name '*.cmd' -or -name '*.conf' -or -name '*.sh' -or -name '*.sal' -or -name '*.his' -or -name '*.ldif' \) -print0 | \
    xargs -0 tar -vzcf $VarEXA.tar.gz

mkdir /mnt/lucus

read -p "Escribe la Contraseña de gomgardav para continuar..." PSWD
mount -t cifs //172.16.0.52/2_adsiinre/aso/gomgardav /mnt/lucus -o domain=iescalquera.net,username=gomgardav,password=$PSWD
