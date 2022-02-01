#!/bin/bash
echo
echo ##########################
echo # Creado por:  gomgardav #
echo # [ David Gómez García ] #
echo ##########################
echo

log=./clie_ub_01_salida.sal
cd /mnt/_Shared || exit
source ./00_00_VAR.sh

Menu () {
   SalidaMenu=$(whiptail    --title "Script 01"                         \
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

        2 ) HISTFILE=~/.bash_history && set -o history && history > ./clie_ub_01-history_"$(date +%F_%H-%M-%S)".his && history -c && set +o history && HISTFILE="";;

        3 ) 
# 			cat << EOF > /etc/resolv.conf
# nameserver $Dns
# search $dominio.$extension

# EOF

# 			cat << EOF > /etc/netplan/01-network-manager-all.yaml
# network:
#   version: 2
#   renderer: networkd
#   ethernets:
#     enp0s3:
#       dhcp4: yes
#       addresses: [$IpClie/24]
#       gateway4: $IpGateway
#       nameservers:
#         addresses: [$Dns]
#         search: [$dominio.$extension]

# EOF

      cat << EOF > /etc/netplan/00-enp0s3-default.yaml
# Let NetworkManager manage all devices on this system
network:
  version: 2
#  renderer: NetworkManager
  ethernets:
    enp0s3:
      dhcp4: yes
#      addresses: [ $IpClie/$Mask ]
#      gateway4: $IpGateway
      nameservers:
#        addresses: [ $Dns ]
        search: [ $dominio.$extension ]

EOF

      netplan apply

      #apt install -y winbind libpam-winbind libnss-winbind krb5-config samba-dsdb-modules samba-vfs-modules

			cat << EOF > /etc/nsswitch.conf
# /etc/nsswitch.conf
#
# Example configuration of GNU Name Service Switch functionality.
# If you have the 'glibc-doc-reference' and 'info' packages installed, try:
# 'info libc "Name Service Switch"' for information about this file.

passwd:         compat winbind systemd
group:          compat winbind systemd
shadow:         compat
gshadow:        files

hosts:          files mdns4_minimal dns wins [NOTFOUND=return]
networks:       files

protocols:      db files
services:       db files
ethers:         db files
rpc:            db files

netgroup:       nis

EOF

      cat << EOF > /etc/hosts
127.0.0.1   localhost
$IpClie $HostnameClie.$dominio.$extension $HostnameClie
$IpServ   $HostnameServ.$dominio.$extension $dominio.$extension $HostnameServ

# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters

EOF

      cat << EOF > /etc/hostname
$HostnameClie
EOF
      hostnamectl set-hostname $HostnameClie.$dominio.$extension

      apt -y install chrony

cat << EOF > /etc/chrony/chrony.conf
# Welcome to the chrony configuration file. See chrony.conf(5) for more
# information about usuable directives.

# This will use (up to):
# - 4 sources from ntp.ubuntu.com which some are ipv6 enabled
# - 2 sources from 2.ubuntu.pool.ntp.org which is ipv6 enabled as well
# - 1 source from [01].ubuntu.pool.ntp.org each (ipv4 only atm)
# This means by default, up to 6 dual-stack and up to 2 additional IPv4-only
# sources will be used.
# At the same time it retains some protection against one of the entries being
# down (compare to just using one of the lines). See (LP: #1754358) for the
# discussion.
#
# About using servers from the NTP Pool Project in general see (LP: #104525).
# Approved by Ubuntu Technical Board on 2011-02-08.
# See http://www.pool.ntp.org/join.html for more information.
#pool ntp.ubuntu.com        iburst maxsources 4
#pool 0.ubuntu.pool.ntp.org iburst maxsources 1
#pool 1.ubuntu.pool.ntp.org iburst maxsources 1
#pool 2.ubuntu.pool.ntp.org iburst maxsources 2
server $IpServ  iburst

# This directive specify the location of the file containing ID/key pairs for
# NTP authentication.
keyfile /etc/chrony/chrony.keys

# This directive specify the file into which chronyd will store the rate
# information.
driftfile /var/lib/chrony/chrony.drift

# Uncomment the following line to turn logging on.
#log tracking measurements statistics

# Log files location.
logdir /var/log/chrony

# Stop bad estimates upsetting machine clock.
maxupdateskew 100.0

# This directive enables kernel synchronisation (every 11 minutes) of the
# real-time clock. Note that it can’t be used along with the 'rtcfile' directive.
rtcsync

# Step the system clock instead of slewing it if the adjustment is larger than
# one second, but only in the first three clock updates.
makestep 1 3

EOF

systemctl restart chronyd
timedatectl set-ntp true


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
