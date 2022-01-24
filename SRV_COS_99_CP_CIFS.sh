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

rm -rf ./samba*

cp -r . /mnt/_Shared/_Entrega

Enter="Enter"
while [[ -n "$Enter" ]]; do
	echo
	read -sp "Pulsa Enter para Continuar..." Enter
done;;

cp -r . /mnt/lucus/dir$VarEXA
