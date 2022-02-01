#!/bin/bash
echo
echo ##########################
echo # Creado por:  gomgardav #
echo # [ David Gómez García ] #
echo ##########################
echo

log=./srv_cos_04_salida.sal
cd ~/samba || exit
source ./00_00_VAR.sh

Menu () {
   SalidaMenu=$(whiptail    --title "Script 04"                         \
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

        2 ) HISTFILE=~/.bash_history && set -o history && history > ./srv_cos_04-history_"$(date +%F_%H-%M-%S)".his && history -c && set +o history && HISTFILE="";;

        3 ) 

samba-tool domain provision --server-role=dc --use-rfc2307 --host-name=$HostnameServ --domain=$dominio --realm=$dominio.$extension --adminpass=abc123. --dns-backend=SAMBA_INTERNAL
sleep 3

#cp /var/lib/samba/private/krb5.conf /etc/
\rm /etc/krb5.conf
ln -s /usr/local/samba/private/krb5.conf /etc/


systemctl start samba-ad-dc
systemctl status samba-ad-dc

cp /usr/local/samba/etc/smb.conf /usr/local/samba/etc/smb.conf.generated

cat << EOF > /usr/local/samba/etc/smb.conf
# Global parameters
[global]
	dns forwarder = $DnsNat
	netbios name = $HostnameServ
	realm = $dominio.$extension
	server role = active directory domain controller
	workgroup = $dominio
	log level = 3 passdb:5 auth:5

#	rpc_server	: tcpip = no
#	rpc_daemon	: spoolssd = embedded
#	rpc_server	: spoolss = embedded
#	rpc_server	: winreg = embedded
#	rpc_server	: ntsvcs = embedded
#	rpc_server	: eventlog = embedded
#	rpc_server	: srvsvc = embedded
#	rpc_server	: svcctl = embedded
#	rpc_server	: default = external
#	winbindd	: use external pipes = true

	idmap_ldb	: use rfc2307 = yes

#	idmap config * : backend = tdb
#	idmap config * : range = 3000-7999

#	idmap config $dominio	: backend = ad
#	idmap config $dominio	: schema_mode = rfc2307
#	idmap config $dominio	: range = 10000-999999
#	idmap config $dominio	: unix_nss_info = yes

	winbind nss info = rfc2307
	winbind refresh tickets = yes
#	winbind use default domain = yes
	winbind offline logon = no
	winbind enum users = yes
	winbind enum groups = yes
	winbind nested groups = yes

	template shell = /bin/bash
	template homedir = /home/$dominio/users/%U

	vfs objects = dfs_samba4 acl_xattr
	map acl inherit = yes
	acl allow execute always = yes
	store dos attributes = yes

[sysvol]
	path = /usr/local/samba/var/locks/sysvol
	read only = No

[netlogon]
	path = /home/$dominio/scripts
	read only = No

[profiles]
	comment = Users profiles
	path = /home/$dominio/profiles/
	browseable = No
	read only = No
	csc policy = disable
	vfs objects = dfs_samba4 acl_xattr

[users]
	path = /home/$dominio/users/
	read only = no
#	force create mode = 0600
#	force directory mode = 0700
	vfs objects = dfs_samba4 acl_xattr

[comun]
	path = /comun
	read only = no
	vfs objects = dfs_samba4 acl_xattr

[Ventas]
	path = /comun/Ventas
	read only = no
	vfs objects = dfs_samba4 acl_xattr

EOF

systemctl restart samba-ad-dc
sleep 3

getent passwd
getent group
sleep 3


      Enter="Enter"
            while [ -n "$Enter" ]; do
                echo
                read -p "Pulsa Enter para Continuar..." Enter
            done

            HISTFILE=~/.bash_history && set -o history && history > ./srv_cos_04-history_"$(date +%F_%H-%M-%S)".his && history -c && set +o history && HISTFILE="";;

        4 ) reboot; exit;;
        
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
