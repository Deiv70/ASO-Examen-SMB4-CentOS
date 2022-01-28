#!/bin/bash
echo
echo ##########################
echo # Creado por:  gomgardav #
echo # [ David Gómez García ] #
echo ##########################
echo

log=./srv_cos_01_salida.sal
cd ~/samba || exit
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

        1 ) dnf -y update && dnf -y upgrade;;

        2 ) HISTFILE=~/.bash_history && set -o history && history > ./srv_cos_01-history_"$(date +%F_%H-%M-%S)".his && history -c && set +o history && HISTFILE="";;

        3 ) 
            \rm -f "$log"

cat << EOF > /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
$IpServ   $HostnameServ.$Dominio.$Extension $Dominio.$Extension $HostnameServ

EOF

hostnamectl set-hostname $HostnameServ.$Dominio.$Extension

ifdown enp0s3
cat << EOF > /etc/sysconfig/network-scripts/ifcfg-enp0s3
TYPE=Ethernet
PROXY_METHOD=none
BROWSER_ONLY=no
BOOTPROTO=static
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
NAME=enp0s3
UUID=$(uuidgen enp0s3)
DEVICE=enp0s3
ONBOOT=yes
IPADDR=$IpServ
NETMASK=$Netmask
GATEWAY=$IpGateway
DNS1=$DnsNat
DNS2=$Dns
DOMAIN=$Dominio.$Extension
SEARCH=$Dominio.$Extension

EOF
sleep 2 && ifup enp0s3

cat << EOF > /etc/dnf/dnf.conf
[main]
gpgcheck=1
installonly_limit=3
clean_requirements_on_remove=True
best=True
skip_if_unavailable=False
fastestmirror=True
max_parallel_downloads=10

EOF

wget https://download.opensuse.org/repositories/shells:/zsh-users:/zsh-completions/CentOS_8/shells:zsh-users:zsh-completions.repo -O /etc/yum.repos.d/zsh-completions.repo

#dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm && dnf -y update
dnf -y update && dnf -y install epel-release dnf-plugins-core openssh-server zsh-completions bpytop screen tmux && dnf -y update && dnf config-manager --set-enabled powertools && dnf -y update
dnf -y install gcc make perl bzip2 git elfutils-devel.x86_64 elfutils-libelf-devel dkms selinux-policy-devel #kernel-headers kernel-devel #python

#dnf install https://www.elrepo.org/elrepo-release-8.el8.elrepo.noarch.rpm
#rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
#dnf -y install xorg-x11-server-Xorg.x86_64 xorg-x11-server-common.x86_64 xorg-x11-drv-vesa.x86_64 xorg-x11-drv-vmware.x86_64 xorg-x11-utils.x86_64 

#mkdir /mnt/sr0
#mkdir /mnt/_Shared
#mount /dev/sr0 /mnt/sr0

#/mnt/sr0/VBoxLinuxAdditions.run --nox11

#sleep 2
#mount -t vboxsf _Shared /mnt/_Shared/

#setenforce 0
cat << EOF > /etc/selinux/config

# This file controls the state of SELinux on the system.
# SELINUX= can take one of these three values:
#     enforcing - SELinux security policy is enforced.
#     permissive - SELinux prints warnings instead of enforcing.
#     disabled - No SELinux policy is loaded.
SELINUX=disabled
# SELINUXTYPE= can take one of these three values:
#     targeted - Targeted processes are protected,
#     minimum - Modification of targeted policy. Only selected processes are protected.
#     mls - Multi Level Security protection.
SELINUXTYPE=targeted

EOF

#cat << EOF >> /etc/apparmor.d/local/usr.sbin.named &&
## Samba DLZ and Active Directory Zones (default source installation)
#/usr/local/samba/lib/** rm,
#/usr/local/samba/bind-dns/dns.keytab rk,
#/usr/local/samba/bind-dns/named.conf r,
#/usr/local/samba/bind-dns/dns/** rwk,
#/usr/local/samba/etc/smb.conf r,

#EOF

# bind_ver=$(named -v | awk -F' ' '{print $2}' | cut -d . -f -2)

			#mkdir ~/samba && cp -r /mnt/_Shared/. ~/samba/.

			Enter="Enter"
            while [ -n "$Enter" ]; do
                echo
                read -p "Pulsa Enter para Continuar..." Enter
            done

            HISTFILE=~/.bash_history && set -o history && history > ./srv_cos_01-history_"$(date +%F_%H-%M-%S)".his && history -c && set +o history && HISTFILE="";;

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
