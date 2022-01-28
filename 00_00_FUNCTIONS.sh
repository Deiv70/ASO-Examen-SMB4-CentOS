#!/bin/sh
##########################
# Creado por:  gomgardav #
# [ David Gómez García ] #
##########################

## [ Logs and Function Definition ]:

#rm "$log"
exec 3>&1 1>&2 2>&3

alllog () {
	("$@"; ExitCode=$?) | tee -a "$log"
	(echo && echo "Exit Code is: "$ExitCode) | tee -a "$log"
	(echo && echo) | tee -a "$log"
	error=$(grep "error" "$log")
	if [ -z "$error" ]
	then
		echo | tee -a "$log"
	else
		echo $error
		echo Consulta el log: $log
		#exit
	fi
}

teelog () {
	"$@" | tee -a "$log"
	(echo && echo) | tee -a "$log"
}

systemctllog () {
	systemctl "$@" && teelog echo Estado del Servico [ "$2" ] Modificado || teelog echo Error, Estado del Servicio [ "$2" ] NO Modificado"!!"
}
