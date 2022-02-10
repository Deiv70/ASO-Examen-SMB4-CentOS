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

<<<<<<< HEAD
			samba-tool group add "Unix Admins" --gid-number 20000 --nis-domain="$dominio"

			#m=$n+1
			cat << EOF > ~/samba/SMB_04_02_QUOTA.sh
#!/bin/bash
echo
echo ##########################
echo # Creado por:  gomgardav #
echo # [ David Gómez García ] #
echo ##########################
echo

log=./_LogScriptSMB_04_02.sal
. /mnt/_Shared/00_00_VAR.txt

useradd general -M -N -u 1001
passwd -l general
setquota -u general $QuotaDefaultSize $QuotaDefaultSize 0 0 /home/$dominio
#setquota -u general $QuotaDefaultSize $QuotaDefaultSize 0 0 /comun

#setquota -u  $QuotaDefaultSize $QuotaDefaultSize 0 0 /home/$dominio
#setquota -u  $QuotaDefaultSize $QuotaDefaultSize 0 0 /comun

EOF

			for (( i = 0, n = 0 ; i <= 0 ; n++ ))
			do
				samba-tool group add "${A_GruposP[$n]}" --gid-number 1500$n --nis-domain="$dominio"

				export "${A_GruposP[$n]}"=1500$n
				nn=$((n+1))
				if [[ -z "${A_GruposP[$nn]}" ]]
				then
					i=1
				fi
			done

			for (( i = 0, n = 0 ; i <= 0 ; n++ ))
			do
				samba-tool group add "${A_GruposS[$n]}" --gid-number 1700$n --nis-domain="$dominio"

				export "${A_GruposS[$n]}"=1700$n
				nn=$((n+1))
				if [[ -z "${A_GruposS[$nn]}" ]]
				then
					i=1
				fi
			done

			for (( i = 0, n = 0 ; i <= 0 ; n++ ))
			do
				samba-tool user create "${A_User[$n]}" abc123. --nis-domain="$dominio" --login-shell=/bin/bash --uid-number="${A_UserUID[$n]}" --gid-number="${!A_UE_GrupoP[$n]}" --unix-home=/home/"$dominio"/users/"${A_User[$n]}" --home-directory="\\\\S1\users\\${A_User[$n]}" --home-drive=L: --profile-path="\\\\S1\profiles\\${A_User[$n]}" --script-path="\\\\S1\netlogon\\${A_User[$n]}.cmd"

				samba-tool group addmembers "${A_UE_GrupoP[$n]}" "${A_User[$n]}"

				samba-tool group addmembers "Domain Users" "${A_User[$n]}"

				echo -e "abc123." | net rpc user setprimarygroup "${A_User[$n]}" "${A_UE_GrupoP[$n]}" -U Administrator

				_convert_to_array UE_GruposS_$n
				Var_Name=A_UE_GruposS_$n
				export Var_Content="$(eval echo \${$Var_Name[@]})"
				for m in $Var_Content
				do
					samba-tool group addmembers "$m" "${A_User[$n]}"
				done
				
					mkdir /home/"$dominio"/users/"${A_User[$n]}"
					chown "$dominio\\${A_User[$n]}":"$dominio\\${A_UE_GrupoP[$n]}" /home/"$dominio"/users/"${A_User[$n]}"
					#mkdir /home/"$dominio"/profiles/"${A_User[$n]}".V6
					#chown "$dominio\\${A_User[$n]}":"$dominio\\${A_UE_GrupoP[$n]}" /home/"$dominio"/profiles/"${A_User[$n]}".V6

					cat << EOF > /home/"$dominio"/scripts/"${A_User[$n]}".cmd
@echo off
chcp 65001

net use S: \\\\$HostnameServ\comun


EOF

				chown "$dominio\\${A_User[$n]}":"BUILTIN\\Administrators" /home/"$dominio"/scripts/"${A_User[$n]}".cmd
				chmod u+x /home/"$dominio"/scripts/"${A_User[$n]}".cmd

					cat << EOF >> ~/samba/SMB_04_02_QUOTA.sh
edquota -p general "${A_User[$n]}"

EOF
				
				nn=$((n+1))
				if [[ "${A_Counter[$nn]}" != "$nn" ]]
				then
					i=1
				fi
			done

			cat << EOF >> ~/samba/SMB_04_02_QUOTA.sh
repquota -vugas | tee ./repquota.sal

EOF
=======
        

chmod +x ~/samba/SRV_COS_09_QUOTA.sh
>>>>>>> 2c2a4d8 (fix: various scripts errors fixed)

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
