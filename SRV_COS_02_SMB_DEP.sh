#!/bin/bash
echo
echo ##########################
echo # Creado por:  gomgardav #
echo # [ David Gómez García ] #
echo ##########################
echo

log=./srv_cos_02_salida.sal
cd ~/samba || exit
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

        1 ) yum update -y && ym upgrade -y;;

        2 ) HISTFILE=~/.bash_history && set -o history && history > ./srv_cos_02-history_"$(date +%F_%H-%M-%S)".his && history -c && set +o history && HISTFILE="";;

        3 ) 

yum install -y wget acl attr gvfs gvfs-devel dbus dbus-tools dbus-glib-devel dbus-libs dbus-c++-devel quota \
               nfs-utils nfs4-acl-tools #ntp ntpdate nfs-kernel-server &&
yum install -y patch python36-markdown python36-iso8601 python36-cryptography python36-pyasn1 python36-asn1crypto \
               cups-devel oddjob oddjob-mkhomedir #samba-winbind samba-winbind-clients &&
# libsystemd-dev dnsutils cups cups-ipp-utils cups-bsd


cat << EOF > /etc/nsswitch.conf
#
# /etc/nsswitch.conf
#
# An example Name Service Switch config file. This file should be
# sorted with the most-used services at the beginning.
#
# The entry '[NOTFOUND=return]' means that the search for an
# entry should stop if the search in the previous entry turned
# up nothing. Note that if the search failed due to some other reason
# (like no NIS server responding) then the search continues with the
# next entry.
#
# Valid entries include:
#
#	nisplus			Use NIS+ (NIS version 3)
#	nis			Use NIS (NIS version 2), also called YP
#	dns			Use DNS (Domain Name Service)
#	files			Use the local files
#	db			Use the local database (.db) files
#	compat			Use NIS on compat mode
#	hesiod			Use Hesiod for user lookups
#	sss			Use sssd (System Security Services Daemon)
#	[NOTFOUND=return]	Stop searching if not found so far
#
# WARNING: Running nscd with a secondary caching service like sssd may lead to
# 	   unexpected behaviour, especially with how long entries are cached.

# To use db, put the "db" in front of "files" for entries you want to be
# looked up first in the databases
#
# Example:
#passwd:    db files nisplus nis
#shadow:    db files nisplus nis
#group:     db files nisplus nis

passwd:     files sss winbind
shadow:     files sss winbind
group:      files sss winbind
#initgroups: files sss

#hosts:     db files nisplus nis dns
hosts:      files dns wins myhostname

# Example - obey only what nisplus tells us...
#services:   nisplus [NOTFOUND=return] files
#networks:   nisplus [NOTFOUND=return] files
#protocols:  nisplus [NOTFOUND=return] files
#rpc:        nisplus [NOTFOUND=return] files
#ethers:     nisplus [NOTFOUND=return] files
#netmasks:   nisplus [NOTFOUND=return] files     

bootparams: nisplus [NOTFOUND=return] files

ethers:     files
netmasks:   files
networks:   files
protocols:  files
rpc:        files
services:   files sss

netgroup:   nisplus sss

publickey:  nisplus

automount:  files nisplus sss
aliases:    files nisplus

EOF

test -f /etc/pam.d/password-auth.org && cp /etc/pam.d/password-auth /etc/pam.d/password-auth.bak || cp /etc/pam.d/password-auth /etc/pam.d/password-auth.org
authselect select winbind with-mkhomedir --force
systemctl enable oddjobd --now
# cat << EOF > /etc/pam.d/password-auth
# #%PAM-1.0
# auth        required      pam_env.so
# auth        sufficient    pam_unix.so nullok try_first_pass
# auth        requisite     pam_succeed_if.so uid >= 1000 quiet_success
# auth        sufficient    pam_winbind.so use_first_pass
# auth        required      pam_deny.so

# account     required      pam_unix.so broken_shadow
# account     sufficient    pam_localuser.so
# account     sufficient    pam_succeed_if.so uid < 1000 quiet
# account     [default=bad success=ok user_unknown=ignore] pam_winbind.so
# account     required      pam_permit.so

# password    requisite     pam_cracklib.so try_first_pass retry=3 type=
# password    sufficient    pam_unix.so sha512 shadow nullok try_first_pass use_authtok
# password    sufficient    pam_winbind.so use_authtok
# password    required      pam_deny.so

# session     optional      pam_keyinit.so revoke
# session     required      pam_limits.so
# session     [success=1 default=ignore] pam_succeed_if.so service in crond quiet use_uid
# session     required      pam_unix.so

# EOF

# dnf config-manager --set-enabled devel
# dnf config-manager --set-disabled devel

#: [[ CentOS 8 ]] ==>
# dnf -y install docbook-style-xsl gcc gdb gnutls-devel gpgme-devel jansson-devel \
#       keyutils-libs-devel krb5-workstation libacl-devel libaio-devel \
#       libarchive-devel libattr-devel libblkid-devel libtasn1 libtasn1-tools \
#       libxml2-devel libxslt lmdb-devel openldap-devel pam-devel perl \
#       perl-ExtUtils-MakeMaker perl-Parse-Yapp popt-devel python3-cryptography \
#       python3-dns python3-gpg python36-devel readline-devel systemd-devel \
#       tar zlib-devel \
#       rpcgen libtirpc-devel rpcsvc-proto-devel acl attr \
#       autoconf automake docbook-style-xsl gcc gdb jansson-devel \
#       krb5-devel krb5-workstation libacl-devel libarchive-devel \
#       libattr-devel libtasn1-tools libxslt lmdb-devel make openldap-devel \
#       pam-devel python36-devel  &&

#: [[ CentOS 7 ]] ==>
set -xueo pipefail

yum update -y
yum install -y epel-release
yum install -y yum-plugin-copr
yum copr enable -y sergiomb/SambaAD
yum update -y

yum install -y \
    "@Development Tools" \
    acl \
    attr \
    autoconf \
    avahi-devel \
    bind-utils \
    binutils \
    bison \
    ccache \
    chrpath \
    compat-gnutls34-devel \
    cups-devel \
    curl \
    dbus-devel \
    docbook-dtds \
    docbook-style-xsl \
    flex \
    gawk \
    gcc \
    gdb \
    git \
    glib2-devel \
    glibc-common \
    gpgme-devel \
    gzip \
    hostname \
    htop \
    jansson-devel \
    keyutils-libs-devel \
    krb5-devel \
    krb5-server \
    lcov \
    libacl-devel \
    libarchive-devel \
    libattr-devel \
    libblkid-devel \
    libbsd-devel \
    libcap-devel \
    libicu-devel \
    libnsl2-devel \
    libpcap-devel \
    libsemanage-python \
    libtasn1-devel \
    libtasn1-tools \
    libtirpc-devel \
    libunwind-devel \
    libuuid-devel \
    libxslt \
    lmdb \
    lmdb-devel \
    make \
    mingw64-gcc \
    ncurses-devel \
    openldap-devel \
    pam-devel \
    patch \
    perl-Archive-Tar \
    perl-ExtUtils-MakeMaker \
    perl-JSON-Parse \
    perl-Parse-Yapp \
    perl-Test-Base \
    perl-core \
    perl-generators \
    perl-interpreter \
    pkgconfig \
    policycoreutils-python \
    popt-devel \
    procps-ng \
    psmisc \
    python36 \
    python36-cryptography \
    python36-devel \
    python36-dns \
    python36-markdown \
    python36-pyasn1 \
    quota-devel \
    readline-devel \
    redhat-lsb \
    rng-tools \
    rpcgen \
    rsync \
    sed \
    sudo \
    systemd-devel \
    tar \
    tree \
    wget \
    which \
    xfsprogs-devel \
    yum-utils \
    zlib-devel

if [ ! -f /usr/bin/python3 ]; then
    ln -sf /usr/bin/python3.6 /usr/bin/python3
fi

#dnf -y autoremove
#dnf -y clean all

            Enter="Enter"
            while [ -n "$Enter" ]; do
                echo
                read -p "Pulsa Enter para Continuar..." Enter
            done

            HISTFILE=~/.bash_history && set -o history && history > ./srv_cos_02-history_"$(date +%F_%H-%M-%S)".his && history -c && set +o history && HISTFILE="";;

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
