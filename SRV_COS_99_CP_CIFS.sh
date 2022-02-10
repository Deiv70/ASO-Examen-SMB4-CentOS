#!/bin/bash
echo
echo ##########################
echo # Creado por:  gomgardav #
echo # [ David Gómez García ] #
echo ##########################
echo

log=./srv_cos_99_salida.sal
cd ~/samba || exit
source ./00_00_VAR.sh

cp -r . /mnt/_Shared/_Entrega

Enter="Enter"
while [[ -n "$Enter" ]]; do
	echo
	read -sp "Pulsa Enter para Continuar..." Enter
done

cp -r . /mnt/lucus/dir$VarExa
