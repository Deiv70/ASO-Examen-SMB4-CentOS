#!/bin/bash
echo
echo ##########################
echo # Creado por:  gomgardav #
echo # [ David Gómez García ] #
echo ##########################
echo

log=./clie_ub_02_salida.sal
cd /mnt/_Shared || exit
source ./00_00_VAR.sh

Menu () {
   SalidaMenu=$(whiptail    --title "Script 02"                         \
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

        1 ) apt update && apt -y full-upgrade;;

        2 ) HISTFILE=~/.bash_history && set -o history && history > ./clie_ub_02-history_"$(date +%F_%H-%M-%S)".his && history -c && set +o history && HISTFILE="";;

        3 ) #export DEBIAN_FRONTEND=noninteractive
			apt update && apt -y install cifs-utils nfs-common winbind libnss-winbind libpam-winbind acl ntpdate krb5-config krb5-user smbclient samba-dsdb-modules samba-vfs-modules samba
			#unset DEBIAN_FRONTEND

			cat << EOF > /etc/nsswitch.conf
# /etc/nsswitch.conf
#
# Example configuration of GNU Name Service Switch functionality.
# If you have the 'glibc-doc-reference' and 'info' packages installed, try:
# 'info libc "Name Service Switch"' for information about this file.

passwd:         compat winbind systemd
group:          compat winbind systemd
shadow:         compat winbind
gshadow:        files

hosts:          files mdns4_minimal dns wins [NOTFOUND=return]
networks:       files

protocols:      db files
services:       db files
ethers:         db files
rpc:            db files

netgroup:       nis

EOF

			mkdir -p /home/$dominio
			mkdir -p /comun

			cat << EOF > /etc/$HostnameServ.cred
user=Administrator
password=abc123.
EOF
			chmod 700 /etc/$HostnameServ.cred

			#echo "\\\\$HostnameServ\users\					/home/$dominio/users		cifs		defaults,rw,relatime,acl,user_xattr                 0 0" >> /etc/fstab
			#echo "\\\\$HostnameServ\comun\					/comun			cifs		defaults,rw,relatime,acl,user_xattr                 0 0" >> /etc/fstab

			echo "$HostnameServ:/home/$dominio  /home/$dominio nfs   auto,defaults,rw,relatime,acl,_netdev,nolock,intr,bg,timeo=300,actimeo=1800 0 0" >> /etc/fstab
			echo "$HostnameServ:/comun       /comun    nfs   auto,defaults,rw,relatime,acl,_netdev,relatime,nolock,intr,bg,timeo=300,actimeo=1800 0 0" >> /etc/fstab
			
			mount -a

			mv /etc/samba/smb.conf /etc/samba/smb.conf.org

			cat << EOF > /etc/samba/smb.conf
# Global parameters
[global]
	realm = $dominio.$extension
	workgroup = $dominio
	security = ads
	kerberos method = secrets and keytab
    log file = /var/log/samba/%m.log
    dedicated keytab file = /etc/krb5.keytab
	
	winbind offline logon = no
	winbind enum users = yes
	winbind enum groups = yes
	winbind nested groups = yes

	winbind nss info = rfc2307
	winbind refresh tickets = yes
#	winbind use default domain = yes

	idmap_ldb:use rfc2307 = yes

	idmap config * : backend = tdb  
	idmap config * : range = 3000-7999

	idmap config $dominio : default = yes
	idmap config $dominio : backend = ad
	idmap config $dominio : schema_mode = rfc2307
	idmap config $dominio : range = 10000-999999
	idmap config $dominio : unix_nss_info = yes
	idmap config $dominio : unix_primary_group = yes

	username map = /etc/samba/user.map

	template shell = /bin/bash
	template homedir = /home/$dominio/users/%U

	vfs objects = dfs_samba4 acl_xattr
	map acl inherit = yes

EOF

 			cat << EOF > /etc/samba/user.map
root = $dominio\Administrator
users = BUILTIN\users
EOF

			net ads join -U Administrator

			Enter="Enter"
			while [ -n "$Enter" ]; do
				echo
				read -p "Pulsa Enter para Continuar..." Enter
			done;;

		4 ) init 6;;
		
		0 ) Exit=yes; break;;

		* ) echo "Error en el Script !!!";;

	esac

done

clear
if [ "$Exit" = "yes" ] && [ "$EstadoSalidaMenu" = "0" ]; then
	echo "Has Salido Correctamente !"

elif [ "$EstadoSalidaMenu" = "1" ]; then
	echo "Has seleccionado Cancelar !"

else
	echo "Ha habido un Error !!!"

fi
