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

        1 ) yum update -y && ym upgrade -y;;

        2 ) HISTFILE=~/.bash_history && set -o history && history > ./srv_cos_01-history_"$(date +%F_%H-%M-%S)".his && history -c && set +o history && HISTFILE="";;

        3 ) 
            \rm -f "$log"

            groupmod -g $Users_GID users

            cat << EOF > /etc/default/useradd
# useradd defaults file
GROUP=$Users_GID
HOME=/home
INACTIVE=-1
EXPIRE=
SHELL=/bin/bash
SKEL=/etc/skel
CREATE_MAIL_SPOOL=yes

EOF

cat << EOF > /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
$IpServ   $HostnameServ.$dominio.$extension $dominio.$extension $HostnameServ

EOF

hostnamectl set-hostname $HostnameServ.$dominio.$extension

ifdown eth0
cat << EOF > /etc/sysconfig/network-scripts/ifcfg-eth0
TYPE=Ethernet
PROXY_METHOD=none
BROWSER_ONLY=no
BOOTPROTO=static
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=no
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
NAME=eth0
UUID=$(uuidgen eth0)
DEVICE=eth0
ONBOOT=yes
IPADDR=$IpServ
NETMASK=$Netmask
GATEWAY=$IpGateway
DNS1=$Dns
DNS2=$DnsNat
DOMAIN=$dominio.$extension
SEARCH=$dominio.$extension

EOF
sleep 2 && ifup eth0

cat << EOF > /etc/yum.conf
[main]
bugtracker_url=http://bugs.centos.org/set_project.php?project_id=23&ref=http://bugs.centos.org/bug_report_page.php?category=yum
distroverpkg=centos-release
cachedir=/var/cache/yum/\$basearch/\$releasever
keepcache=0
debuglevel=2
logfile=/var/log/yum.log
exactarch=1
obsoletes=1
plugins=1
gpgcheck=1
#installonly_limit=5
installonly_limit=3
clean_requirements_on_remove=True
skip_if_unavailable=False
best=True
fastestmirror=True
max_parallel_downloads=10
#: Require all packages to be available
strict=False

#  This is the default, if you make this bigger yum won't see if the metadata
# is newer on the remote and so you'll "gain" the bandwidth of not having to
# download the new metadata and "pay" for it by yum not having correct
# information.
#  It is esp. important, to have correct metadata, for distributions like
# Fedora which don't keep old packages around. If you don't like this checking
# interupting your command line usage, it's much better to have something
# manually check the metadata once an hour (yum-updatesd will do this).
# metadata_expire=90m

# PUT YOUR REPOS HERE OR IN separate files named file.repo
# in /etc/yum.repos.d

EOF

cat << EOF > /etc/dnf/dnf.conf
[main]
gpgcheck=1
installonly_limit=3
clean_requirements_on_remove=True
best=True
skip_if_unavailable=False
fastestmirror=True
max_parallel_downloads=10
#: Require all packages to be available
strict=True

EOF

#wget https://download.opensuse.org/repositories/shells:/zsh-users:/zsh-completions/CentOS_8/shells:zsh-users:zsh-completions.repo -O /etc/yum.repos.d/zsh-completions.repo

#dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm && dnf -y update

#: [ [ CentOS 8 ] ] ==>
#dnf -y update && dnf -y install epel-release dnf-plugins-core openssh-server zsh-completions bpytop screen tmux && dnf -y update && dnf config-manager --set-enabled powertools && dnf -y update
#: [ [ CentOS 7 ] ] ==>
yum update -y && yum install -y dnf dnf-plugins-core yum-plugin-copr epel-release openssh-server screen tmux && yum copr enable -y sergiomb/SambaAD && yum update -y

yum install -y chrony gcc make perl bzip2 git elfutils-devel.x86_64 elfutils-libelf-devel dkms selinux-policy-devel #kernel-headers kernel-devel #python

#yum install https://www.elrepo.org/elrepo-release-8.el8.elrepo.noarch.rpm
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

cat << EOF > /etc/chrony.conf
# These servers were defined in the installation:
server 0.centos.pool.ntp.org iburst
server 1.centos.pool.ntp.org iburst
server 2.centos.pool.ntp.org iburst
server 3.centos.pool.ntp.org iburst
# Use public servers from the pool.ntp.org project.
# Please consider joining the pool (http://www.pool.ntp.org/join.html).

# Record the rate at which the system clock gains/losses time.
driftfile /var/lib/chrony/drift

# Allow the system clock to be stepped in the first three updates
# if its offset is larger than 1 second.
makestep 1.0 3

# Enable kernel synchronization of the real-time clock (RTC).
rtcsync

# Enable hardware timestamping on all interfaces that support it.
#hwtimestamp *

# Increase the minimum number of selectable sources required to adjust
# the system clock.
#minsources 2

# Allow NTP client access from local network.
allow $IpNetwork/$Mask

# Serve time even if not synchronized to a time source.
#local stratum 10

# Specify file containing keys for NTP authentication.
#keyfile /etc/chrony.keys

# Specify directory for log files.
logdir /var/log/chrony

# Select which information is logged.
#log measurements statistics tracking

# Get TAI-UTC offset and leap seconds from the system tz database.
#leapsectz right/UTC

EOF

systemctl restart chronyd
timedatectl set-ntp true
firewall-cmd --add-service=ntp --permanent 
firewall-cmd --reload

systemctl disable firewalld --now

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
