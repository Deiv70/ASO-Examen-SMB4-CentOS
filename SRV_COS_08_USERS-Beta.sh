#!/bin/bash
echo
echo ##########################
echo # Creado por:  gomgardav #
echo # [ David Gómez García ] #
echo ##########################
echo

if [ "$(readlink /proc/$$/exe)" != "/bin/bash" ] && [ "$(readlink /proc/$$/exe)" != "/usr/bin/bash" ]
then
	echo "Este Script debe ser ejecutado con: [ /bin/bash ]"
	exit
fi

log=./srv_cos_08_salida.sal
cd ~/samba || exit
source ./00_00_VAR.sh

Menu () {
   SalidaMenu=$(whiptail    --title "Script 08"                         \
                            --menu "Selecciona una Opción" 13 35 5      \
                                    1       "Actualizar"                \
                                    2       "Generar History"           \
                                    3       "Ejecutar Script"           \
                                    4       "Reiniciar"                 \
                                    0       "Salir" 3>&1 1>&2 2>&3)
    EstadoSalidaMenu=$?
}

EstadoSalidaMenu=0
while [ "$EstadoSalidaMenu" = 0 ]; do

    Menu
    Exit=no

    case "$SalidaMenu" in

        1 ) yum update -y && ym upgrade -y;;

        2 ) HISTFILE=~/.bash_history && set -o history && history > ./srv_cos_08-history_"$(date +%F_%H-%M-%S)".his && history -c && set +o history && HISTFILE="";;

        3 ) 

        

chmod +x ~/samba/SRV_COS_09_QUOTA.sh

			Enter="Enter"
			while [[ -n "$Enter" ]]; do
				echo
				read -sp "Pulsa Enter para Continuar..." Enter
			done

            HISTFILE=~/.bash_history && set -o history && history > ./srv_cos_07-history_"$(date +%F_%H-%M-%S)".his && history -c && set +o history && HISTFILE="";;

		4 ) reboot; exit;;

		0 ) Exit=yes; break;;

		* ) echo "Error en el Script !!!";;

	esac

done

#clear
if [ "$Exit" = "yes" ] && [ "$EstadoSalidaMenu" = "0" ]; then
	echo "Has Salido Correctamente !"

elif [ "$EstadoSalidaMenu" = "1" ]; then
	echo "Has seleccionado Cancelar !"

else
	echo "Ha habido un Error !!!"

fi
