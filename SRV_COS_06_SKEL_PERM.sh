#!/bin/bash
echo
echo ##########################
echo # Creado por:  gomgardav #
echo # [ David Gómez García ] #
echo ##########################
echo

log=./srv_cos_06_salida.sal
cd ~/samba || exit
source ./00_00_VAR.sh

Menu () {
   SalidaMenu=$(whiptail    --title "Script 06"                         \
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

        1 ) dnf -y update && dnf -y upgrade;;

        2 ) HISTFILE=~/.bash_history && set -o history && history > ./srv_cos_06-history_"$(date +%F_%H-%M-%S)".his && history -c && set +o history && HISTFILE="";;

        3 ) 

mkdir -p /comun/VentasExtranjero
mkdir -p /home/$Dominio/{users,profiles,scripts}
mkdir /home/$Dominio/scripts

setfacl -m g:"$Dominio\Domain Admins":rwx /home/$Dominio/profiles/
setfacl -dm g:"$Dominio\Domain Admins":rwx /home/$Dominio/profiles/
setfacl -m g:"$Dominio\Domain Users":rwx /home/$Dominio/profiles/

#mkdir -p /comun/VentasExtranjero #&& mkdir /home/$Dominio

#cp -ra /usr/local/samba/var/locks/sysvol/$dominio.$extension/. /comun
#cp -ra /comun/scripts /comun/VentasExtranjero
#rm -rf /comun/Policies
#rm -rf /comun/scripts
# chown -R "$Dominio\\Administrator":"$Dominio\\Domain Users" /comun/VentasExtranjero
# chmod -R 750 /comun/VentasExtranjero

#cp -ra /usr/local/samba/var/locks/sysvol/$dominio.$extension/. /home/$Dominio


# chown -R "$Dominio\\Administrator":"$Dominio\\Domain Users" /home/$Dominio
# chmod -R 750 /home/$Dominio
#rm -rf /home/$Dominio/Policies

echo "/dev/sdb1					/home/$Dominio		ext4		defaults,acl,user_xattr,errors=remount-ro,usrjquota=aquota.user,grpjquota=aquota.group,jqfmt=vfsv0                 0 0" >> /etc/fstab
echo "/dev/sdb2					/comun			ext4		defaults,acl,user_xattr,errors=remount-ro,usrjquota=aquota.user,grpjquota=aquota.group,jqfmt=vfsv0                 0 0" >> /etc/fstab
#echo "/dev/sdb1					/home/$Dominio		ext4		defaults,acl,user_xattr,uid=0,gid=100,umask=007                 0 0" >> /etc/fstab
#echo "/dev/sdb2					/comun			ext4		defaults,acl,user_xattr,uid=0,gid=100,umask=007                 0 0" >> /etc/fstab
#touch /home/$Dominio/aquota.user /home/$Dominio/aquota.group /comun/aquota.user /comun/aquota.group
#chmod 600 /home/$Dominio/aquota.* && chmod 600 /comun/aquota.*
#quotacheck -fugm /home/$Dominio && quotacheck -fugm /comun
#quotaon -v /home/$Dominio && quotaon -v /comun
mount -a
quotacheck -vaugfcm
quotaon -vaug

firewall-cmd --permanent --add-service=nfs
firewall-cmd --permanent --add-service=rpc-bind
firewall-cmd --permanent --add-service=mountd
firewall-cmd --reload

echo "/home/$Dominio 	$IpNetwork/255.255.255.0(rw,no_root_squash,no_subtree_check)" > /etc/exports
echo "/comun 			$IpNetwork/255.255.255.0(rw,no_root_squash,no_subtree_check)" >> /etc/exports
systemctl enable nfs-server.service
service nfs-server restart
exportfs -v

#useradd general -M -N -u 1001
#passwd -l general
#setquota -u general $QuotaDefaultSize $QuotaDefaultSize  0 0 /home/$Dominio

#cp -ra /usr/local/samba/var/locks/sysvol/$dominio.$extension/. /home/$Dominio/.
#rm -rf /home/$Dominio/Policies

#cp -ra /home/$Dominio/scripts /home/$Dominio/users
#cp -ra /home/$Dominio/scripts /home/$Dominio/profiles

#net rpc group add "Unix Admins" -L -U Administrator
samba-tool group add "Unix Admins" --gid-number 20000 --nis-domain="$Dominio"
#net rpc group addmem "Administrators" "Unix Admins" -U Administrator
samba-tool group addmembers "Administrators" "Unix Admins"
echo -e "abc123." | net rpc user setprimarygroup Administrator "Domain Admins" -U Administrator
echo -e "abc123." | net rpc rights grant "$Dominio\\Unix Admins" SeDiskOperatorPrivilege -U "$Dominio\\Administrator"
#net rpc rights list privileges SeDiskOperatorPrivilege -U "Administrator"
systemctl restart samba-ad-dc.service && sleep 3 && getent group && sleep 3

# chown "$Dominio\\Administrator":"$Dominio\\Unix Admins" /home/$Dominio
# mkdir -p /home/$Dominio/{profiles,users,VentasExtranjero}
# chown -R "$Dominio\\Administrator":"$Dominio\\Domain Admins" /home/$Dominio/profiles
# chown -R "$Dominio\\Administrator":"$Dominio\\Unix Admins" /home/$Dominio/users
# chmod o+rx /home/$Dominio /home/$Dominio/users
# #chmod g-w /home/$Dominio
# chmod g-w -R /home/$Dominio/users
#chown -R root:users /home/$Dominio/{profiles,users}

# mkdir -p /home/$Dominio/users/Administrator
# chown "$Dominio\\Administrator":"BUILTIN\\Administrators" /home/$Dominio/users/Administrator
# mkdir -p /home/$Dominio/VentasExtranjero
#chown -R root:"" /home/$Dominio/VentasExtranjero


            Enter="Enter"
            while [ -n "$Enter" ]; do
                echo
                read -p "Pulsa Enter para Continuar..." Enter
            done

            HISTFILE=~/.bash_history && set -o history && history > ./srv_cos_06-history_"$(date +%F_%H-%M-%S)".his && history -c && set +o history && HISTFILE="";;

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
