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

_convert_to_array () {
	for Var_Name in "$@"
	do
		a=0
		Var="${!Var_Name}"
		export Bak_$Var_Name="$Var"

#		echo $A_Var=\"${!A_Var}\" >> Variables.txt

		declare -a Var_Array=()
		declare -g "A_$Var_Name=()"
		if $( echo "$Var" | grep -q ',' )
		then
			while [ -n "$( echo $Var | awk -F',' '{print $2}' )" ]
			do
				Var_Value="$( echo $Var | awk -F',' '{print $1}' )"
				Var="$( echo $Var | cut -d',' -f 2- )"
				#Var_Array+=([$n]=$Var_Value)
				declare -g A_$Var_Name[$a]="$Var_Value"
				((a++))
			done
			#Var_Array+=([$n]=$Var)
			declare -g A_$Var_Name[$a]="$Var"
			((a++))
		else
			#Var_Array+=([$n]=$Var)
			declare -g A_$Var_Name[$a]="$Var"
			((a++))
		fi

	#echo "${Var_Array[@]}"
	#declare -g "A_$Var_Name[$n]=$( echo ${Var_Array[$n]} )"
	done
}

_initialize_array () {
	for i in "$@"; do
		declare -g "$i=()"
	done
}

_initialize_arrays () {
	_initialize_array A_Counter A_UserUID A_User \
		A_UserFullName A_UserFullName_64 A_UserFullName_Unaccent \
		A_UserNameSurname A_UserNameSurname_64 \
		A_UserNameSurname_Unaccent A_UserName A_UserName_64 \
		A_UserName_Unaccent A_Initials A_UE_GrupoP A_UE_GruposS \
		A_UE_Bak_GruposS
}
#_initialize_arrays () {
#	declare -g A_Counter=()

#	declare -g A_UserUID=()
#	declare -g A_User=()
#	declare -g A_UserFullName=()
#	declare -g A_UserFullName_64=()
#	declare -g A_UserFullName_Unaccent=()
#	declare -g A_UserNameSurname=()
#	declare -g A_UserNameSurname_64=()
#	declare -g A_UserNameSurname_Unaccent=()
#	declare -g A_UserName=()
#	declare -g A_UserName_64=()
#	declare -g A_UserName_Unaccent=()
#	declare -g A_Initials=()
#	declare -g A_UE_GrupoP=()
#	declare -g A_UE_GruposS=()
#	declare -g A_UE_Bak_GruposS=()
#}

_process_Add_Users_file () {
	n=0

	while read UserEntry
	do
		if [[ -z "$UserEntry" || "$( echo "$UserEntry" | cut -c 1 )" = "#" ]]
		then
			((n--))
		else
			## Comprobación:
			A_Counter+=([$n]=$n)

			## 1º Campo:
			A_UserUID+=([$n]="$( echo "$UserEntry" | awk -F':' '{print $1}' )")
			
			## 2º Campo:
			A_User+=([$n]="$( echo "$UserEntry" | awk -F':' '{print $2}' )")
			
			## 3º Campo:
			A_UserFullName+=([$n]="$( echo "$UserEntry" | awk -F':' '{print $3}' )")
			A_UserFullName_64+=([$n]="$( echo "${UserFullName[$n]}" | base64 )")
			A_UserFullName_Unaccent+=([$n]="$( echo "${UserFullName[$n]}" | iconv -f utf8 -t ascii//TRANSLIT )")
			
			if $( echo "$UserFullName" | grep -q ' - '  )
			then
				A_UserNameSurname+=([$n]="$( echo "$UserFullName" | awk -F' - ' '{print $2}' )")
			else
				A_UserNameSurname+=([$n]="$UserFullName")
			fi
			A_UserNameSurname_64+=([$n]="$( echo "${UserNameSurname[$n]}" | base64 )")
			A_UserNameSurname_Unaccent+=([$n]="$( echo "${UserNameSurname[$n]}" | iconv -f utf8 -t ascii//TRANSLIT )")
			
			A_UserName+=([$n]="$( echo "$UserNameSurname" | awk -F' ' '{print $1}'  )")
			A_UserName_64+=([$n]="$( echo "${UserName[$n]}" | base64 )")
			A_UserName_Unaccent+=([$n]="$( echo "${UserName[$n]}" | iconv -f utf8 -t ascii//TRANSLIT )")
			
			A_Initials+=([$n]="$( echo "${UserNameUnaccent[$n]}" | cut -c 1 )""$( echo "${UserSurnameUnaccent[$n]}" | cut -c 1 )")
			
			## 4º Campo:
			A_UE_GrupoP+=([$n]="$( echo "$UserEntry" | awk -F':' '{print $4}' )")
			## 5º Campo:
			export UE_GruposS_$n="$( echo "$UserEntry" | awk -F':' '{print $5}' )"
			export UE_Bak_GruposS_$n="$( echo "$UserEntry" | awk -F':' '{print $5}' )"
		fi

		((n++))
	done < "$UserAddVariables"
}

EstadoSalidaMenu=0
while [ "$EstadoSalidaMenu" = 0 ]; do

    Menu
    Exit=no

    case "$SalidaMenu" in

        1 ) yum update -y && ym upgrade -y;;

        2 ) HISTFILE=~/.bash_history && set -o history && history > ./srv_cos_08-history_"$(date +%F_%H-%M-%S)".his && history -c && set +o history && HISTFILE="";;

        3 ) 
			_convert_to_array GruposP GruposS GruposM
			_initialize_arrays
			_process_Add_Users_file

			samba-tool group add "Unix Admins" --gid-number $UnixAdmins_GID --nis-domain="$dominio"

			#m=$n+1
			cat << EOF > ~/samba/SRV_COS_09_QUOTA.sh
#!/bin/bash
echo
echo ##########################
echo # Creado por:  gomgardav #
echo # [ David Gómez García ] #
echo ##########################
echo

log=./srv_cos_09_salida.sal
cd ~/samba || exit
source ./00_00_VAR.sh

useradd general -M -N -u 1001
passwd -l general
setquota -u general $QuotaDefaultSize $QuotaDefaultSize 0 0 /home/$dominio
setquota -u general $QuotaDefaultSize $QuotaDefaultSize 0 0 /comun

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
net use V: \\\\$HostnameServ\Ventas
net use L: \\\\$HostnameServ\users\${A_User[$n]}


EOF

				chown "$dominio\\${A_User[$n]}":"BUILTIN\\Administrators" /home/"$dominio"/scripts/"${A_User[$n]}".cmd
				chmod u+x /home/"$dominio"/scripts/"${A_User[$n]}".cmd

				mkdir -p /home/$dominio/users/${A_User[$n]}/.config/gtk-3.0
				cat << EOF > /home/$dominio/users/${A_User[$n]}/.config/gtk-3.0/bookmarks
file:///comun comun
file:///comun/Ventas Ventas

EOF
				chown -R "$dominio\\${A_User[$n]}":"$dominio\\${A_UE_GrupoP[$n]}" /home/"$dominio"/users/${A_User[$n]}

					cat << EOF >> ~/samba/SRV_COS_09_QUOTA.sh
edquota -p general "${A_User[$n]}"

EOF
				
				nn=$((n+1))
				if [[ "${A_Counter[$nn]}" != "$nn" ]]
				then
					i=1
				fi
			done

			cat << EOF >> ~/samba/SRV_COS_09_QUOTA.sh
repquota -vugas | tee ./repquota.sal

EOF

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
