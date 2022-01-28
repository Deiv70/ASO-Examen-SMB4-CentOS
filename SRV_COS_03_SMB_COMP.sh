#!/bin/bash
echo
echo ##########################
echo # Creado por:  gomgardav #
echo # [ David Gómez García ] #
echo ##########################
echo

log=./srv_cos_03_salida.sal
cd ~/samba || exit
source ./00_00_VAR.sh

Menu () {
   SalidaMenu=$(whiptail    --title "Script 03"                         \
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

        2 ) HISTFILE=~/.bash_history && set -o history && history > ./srv_cos_03-history_"$(date +%F_%H-%M-%S)".his && history -c && set +o history && HISTFILE="";;

        3 ) 

rm /usr/local/samba/var/{lock,locks,cache}/{*.tdb,*.ldb}
rm /usr/local/samba/private/{*.tdb,*.ldb}
\mv /etc/krb5.conf /etc/krb5.conf.old

#rm -rf ./{samba-4*,samba-p*,samba-l*}

#wget https://download.samba.org/pub/samba/samba-pubkey.asc
#wget https://download.samba.org/pub/samba/samba-latest.tar.asc
#wget https://download.samba.org/pub/samba/samba-latest.tar.gz

#cd samba

#gpg --import samba-pubkey.asc
gunzip samba-4.14.8.tar.gz
#gpg --verify samba-latest.tar.asc
tar -xf samba-4.14.8.tar

cd samba-4.14.8 || ( return 1 && exit )


#./configure -j 3 --enable-fhs --libdir=/lib64 --prefix=/usr --sysconfdir=/etc --localstatedir=/var --sbindir=/sbin/ --bindir=/bin/ --mandir=/usr/share/man/ --with-systemd --with-quotas --enable-selftest --progress
./configure -j $Threads --mandir=/usr/share/man/ --with-systemd --with-quotas --enable-selftest --progress &
wait
make -j $Threads & wait
#make -j 3 test
make -j $Threads install & wait

cd ..

export PATH=/usr/local/samba/bin/:/usr/local/samba/sbin/:$PATH
cat << EOF >> ~/.bashrc

export PATH=/usr/local/samba/bin/:/usr/local/samba/sbin/:$PATH

EOF

ln -s /usr/local/samba/lib/libnss_winbind.so.2 /lib64/
ln -s /lib64/libnss_winbind.so.2 /lib64/libnss_winbind.so
ldconfig
ln -s /usr/local/samba/lib/security/pam_winbind.so /lib64/security/


firewall-cmd --add-service={dns,ldap,ldaps,kerberos}
firewall-cmd --add-port={88/tcp,88/udp,389/tcp,389/udp,135/tcp,135/udp,53/tcp,53/udp,138/udp,138/tcp,137/tcp,137/udp,139/udp,139/tcp,445/tcp,445/udp,464/tcp,464/udp,636/tcp,3268/udp,3268/tcp,3269/tcp,3269/udp,49152/tcp}


cat << EOF > /etc/systemd/user/samba-ad-dc.service
[Unit]
Description=Samba Active Directory Domain Controller
After=network.target remote-fs.target nss-lookup.target

[Service]
Type=forking
ExecStart=/usr/local/samba/sbin/samba -D
PIDFile=/usr/local/samba/var/run/samba.pid
ExecReload=/bin/kill -HUP \$MAINPID

[Install]
WantedBy=multi-user.target

EOF
systemctl daemon-reload
systemctl enable /etc/systemd/user/samba-ad-dc.service

test -f /usr/local/samba/etc/smb.conf.org && cp /usr/local/samba/etc/smb.conf /usr/local/samba/etc/smb.conf.bak || mv /usr/local/samba/etc/smb.conf /usr/local/samba/etc/smb.conf.org
rm /usr/local/samba/private/krb5.conf

systemctl disable firewalld --now


            Enter="Enter"
            while [ -n "$Enter" ]; do
                echo
                read -p "Pulsa Enter para Continuar..." Enter
            done

            HISTFILE=~/.bash_history && set -o history && history > ./srv_cos_03-history_"$(date +%F_%H-%M-%S)".his && history -c && set +o history && HISTFILE="";;

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
