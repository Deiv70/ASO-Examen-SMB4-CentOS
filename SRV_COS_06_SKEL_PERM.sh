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

        1 ) yum update -y && ym upgrade -y;;

        2 ) HISTFILE=~/.bash_history && set -o history && history > ./srv_cos_06-history_"$(date +%F_%H-%M-%S)".his && history -c && set +o history && HISTFILE="";;

        3 ) 

<<<<<<< HEAD
#mkdir -p /comun/VentasExtranjero #&& mkdir /home/$dominio

#cp -ra /usr/local/samba/var/locks/sysvol/$dominio.$extension/. /comun
#cp -ra /comun/scripts /comun/VentasExtranjero
#rm -rf /comun/Policies
#rm -rf /comun/scripts
# chown -R "$dominio\\Administrator":"$dominio\\Domain Users" /comun/VentasExtranjero
# chmod -R 750 /comun/VentasExtranjero

#cp -ra /usr/local/samba/var/locks/sysvol/$dominio.$extension/. /home/$dominio


# chown -R "$dominio\\Administrator":"$dominio\\Domain Users" /home/$dominio
# chmod -R 750 /home/$dominio
#rm -rf /home/$dominio/Policies
mkdir /{comun,home/$dominio}

=======
mkdir /{comun,home/$dominio}

>>>>>>> 2c2a4d8 (fix: various scripts errors fixed)
echo "/dev/sdb1					/home/$dominio		ext4		defaults,acl,user_xattr,errors=remount-ro,usrjquota=aquota.user,grpjquota=aquota.group,jqfmt=vfsv0                 0 0" >> /etc/fstab
echo "/dev/sdb2					/comun			ext4		defaults,acl,user_xattr,errors=remount-ro,usrjquota=aquota.user,grpjquota=aquota.group,jqfmt=vfsv0                 0 0" >> /etc/fstab
#echo "/dev/sdb1					/home/$dominio		ext4		defaults,acl,user_xattr,uid=0,gid=100,umask=007                 0 0" >> /etc/fstab
#echo "/dev/sdb2					/comun			ext4		defaults,acl,user_xattr,uid=0,gid=100,umask=007                 0 0" >> /etc/fstab
#touch /home/$dominio/aquota.user /home/$dominio/aquota.group /comun/aquota.user /comun/aquota.group
#chmod 600 /home/$dominio/aquota.* && chmod 600 /comun/aquota.*
#quotacheck -fugm /home/$dominio && quotacheck -fugm /comun
#quotaon -v /home/$dominio && quotaon -v /comun
mount -a

quotacheck -vaugfcm
quotaon -vaug

<<<<<<< HEAD
mkdir -p /comun/Ventas/{Ventas_Extranjero,Ventas_Local,Vasia,Veuropa,Voceania}
mkdir -p /home/$dominio/{users,profiles,scripts}
#mkdir /home/$dominio/scripts

setfacl -m g:"$dominio\Domain Admins":rwx /home/$dominio/profiles/
setfacl -dm g:"$dominio\Domain Admins":rwx /home/$dominio/profiles/
=======
mkdir -p /comun/Ventas/{$CarpetasVentas}
mkdir -p /home/$dominio/{users,profiles,scripts}
#mkdir /home/$dominio/scripts

chown -R root:unix-admins /home/$dominio
setfacl -dm g:"$dominio\Unix Admins":rwx /home/$dominio

setfacl -m g:"$dominio\Unix Admins":rwx /home/$dominio/profiles/
setfacl -dm g:"$dominio\Unix Admins":rwx /home/$dominio/profiles/
>>>>>>> 2c2a4d8 (fix: various scripts errors fixed)
setfacl -m g:"$dominio\Domain Users":rwx /home/$dominio/profiles/

firewall-cmd --permanent --add-service=nfs
firewall-cmd --permanent --add-service=rpc-bind
firewall-cmd --permanent --add-service=mountd
firewall-cmd --reload

echo "/home/$dominio 	$IpNetwork/255.255.255.0(rw,no_root_squash,no_subtree_check)" > /etc/exports
echo "/comun 			$IpNetwork/255.255.255.0(rw,no_root_squash,no_subtree_check)" >> /etc/exports
systemctl enable nfs-server.service
service nfs-server restart
exportfs -v

getent group

#useradd general -M -N -u 1001
#passwd -l general
#setquota -u general $QuotaDefaultSize $QuotaDefaultSize  0 0 /home/$dominio

#cp -ra /usr/local/samba/var/locks/sysvol/$dominio.$extension/. /home/$dominio/.
#rm -rf /home/$dominio/Policies

#cp -ra /home/$dominio/scripts /home/$dominio/users
#cp -ra /home/$dominio/scripts /home/$dominio/profiles

<<<<<<< HEAD
#net rpc group add "Unix Admins" -L -U Administrator
samba-tool group add "Unix Admins" --gid-number 20000 --nis-domain="$dominio"
#net rpc group addmem "Administrators" "Unix Admins" -U Administrator
samba-tool group addmembers "Administrators" "Unix Admins"
echo -e "abc123." | net rpc user setprimarygroup Administrator "Domain Admins" -U Administrator
echo -e "abc123." | net rpc rights grant "$dominio\\Unix Admins" SeDiskOperatorPrivilege -U "$dominio\\Administrator"
#net rpc rights list privileges SeDiskOperatorPrivilege -U "Administrator"
systemctl restart samba-ad-dc.service && sleep 3 && getent group && sleep 3

# chown "$dominio\\Administrator":"$dominio\\Unix Admins" /home/$dominio
# mkdir -p /home/$dominio/{profiles,users,VentasExtranjero}
# chown -R "$dominio\\Administrator":"$dominio\\Domain Admins" /home/$dominio/profiles
# chown -R "$dominio\\Administrator":"$dominio\\Unix Admins" /home/$dominio/users
# chmod o+rx /home/$dominio /home/$dominio/users
# #chmod g-w /home/$dominio
# chmod g-w -R /home/$dominio/users
#chown -R root:users /home/$dominio/{profiles,users}

=======
# chown "$dominio\\Administrator":"$dominio\\Unix Admins" /home/$dominio
# mkdir -p /home/$dominio/{profiles,users,VentasExtranjero}
# chown -R "$dominio\\Administrator":"$dominio\\Domain Admins" /home/$dominio/profiles
# chown -R "$dominio\\Administrator":"$dominio\\Unix Admins" /home/$dominio/users
# chmod o+rx /home/$dominio /home/$dominio/users
# #chmod g-w /home/$dominio
# chmod g-w -R /home/$dominio/users
#chown -R root:users /home/$dominio/{profiles,users}

>>>>>>> 2c2a4d8 (fix: various scripts errors fixed)
# mkdir -p /home/$dominio/users/Administrator
# chown "$dominio\\Administrator":"BUILTIN\\Administrators" /home/$dominio/users/Administrator
# mkdir -p /home/$dominio/VentasExtranjero
#chown -R root:"" /home/$dominio/VentasExtranjero


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
