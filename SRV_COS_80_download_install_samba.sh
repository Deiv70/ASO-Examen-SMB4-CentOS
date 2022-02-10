#!/bin/bash
echo
echo ##########################
echo # Creado por:  gomgardav #
echo # [ David Gómez García ] #
echo ##########################
echo

log=./_LogScriptSMB_02_01.sal
. /mnt/_Shared/00_00_VAR.txt

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

        2 ) HISTFILE=~/.bash_history && set -o history && history >> history-002.his && history -c && set +o history && HISTFILE="";;

        3 ) 

dnf -y install wget acl attr gvfs gvfs-devel dbus dbus-tools dbus-glib-devel dbus-libs dbus-c++-devel quota \
               chrony nfs-utils nfs4-acl-tools #ntp ntpdate nfs-kernel-server &&
dnf -y install patch python3-markdown python3-iso8601 python3-cryptography python3-pyasn1 python3-asn1crypto \
               cups-devel oddjob oddjob-mkhomedir samba-winbind samba-winbind-clients &&
# libsystemd-dev dnsutils cups cups-ipp-utils cups-bsd

rm /usr/local/samba/var/{lock,locks,cache}/{*.tdb,*.ldb}
rm /usr/local/samba/private/{*.tdb,*.ldb}
mv /etc/krb5.conf /etc/krb5.conf.old

#rm -rf ./{samba-4*,samba-p*,samba-l*}

#wget https://download.samba.org/pub/samba/samba-pubkey.asc
#wget https://download.samba.org/pub/samba/samba-latest.tar.asc
#wget https://download.samba.org/pub/samba/samba-latest.tar.gz

#cd samba

gpg --import samba-pubkey.asc
gunzip samba-latest.tar.gz
gpg --verify samba-latest.tar.asc
tar -xf samba-latest.tar

cd samba-4.14.5

dnf -y install docbook-style-xsl gcc gdb gnutls-devel gpgme-devel jansson-devel \
      keyutils-libs-devel krb5-workstation libacl-devel libaio-devel \
      libarchive-devel libattr-devel libblkid-devel libtasn1 libtasn1-tools \
      libxml2-devel libxslt lmdb-devel openldap-devel pam-devel perl \
      perl-ExtUtils-MakeMaker perl-Parse-Yapp popt-devel python3-cryptography \
      python3-dns python3-gpg python36-devel readline-devel systemd-devel \
      tar zlib-devel \
      rpcgen libtirpc-devel rpcsvc-proto-devel acl attr \
      autoconf automake docbook-style-xsl gcc gdb jansson-devel \
      krb5-devel krb5-workstation libacl-devel libarchive-devel \
      libattr-devel libtasn1-tools libxslt lmdb-devel make openldap-devel \
      pam-devel python36-devel  &&

#. ./bootstrap/generated-dists/debian10/bootstrap.sh &&
# dnf config-manager --set-enabled devel
# yum install -y \
#     --setopt=install_weak_deps=False \
#     "@Development Tools" \
#     acl attr autoconf avahi-devel bind-utils binutils bison ccache chrpath \
#     cups-devel curl dbus-devel docbook-dtds docbook-style-xsl flex gawk gcc \
#     gdb git glib2-devel glibc-common glibc-langpack-en glusterfs-api-devel \
#     glusterfs-devel gnutls-devel gpgme-devel gzip hostname htop jansson-devel \
#     keyutils-libs-devel krb5-devel krb5-server libacl-devel libarchive-devel \
#     libattr-devel libblkid-devel libbsd-devel libcap-devel libcephfs-devel \
#     libicu-devel libnsl2-devel libpcap-devel libtasn1-devel libtasn1-tools \
#     libtirpc-devel libunwind-devel libuuid-devel libxslt lmdb lmdb-devel make \
#     mingw64-gcc ncurses-devel openldap-devel pam-devel patch perl perl-Archive-Tar \
#     perl-ExtUtils-MakeMaker perl-JSON perl-Parse-Yapp perl-Test-Simple \
#     perl-generators perl-interpreter pkgconfig popt-devel procps-ng psmisc python3 \
#     python3-cryptography python3-devel python3-dns python3-gpg python3-iso8601 \
#     python3-libsemanage python3-markdown python3-policycoreutils python3-pyasn1 \
#     python3-setproctitle quota-devel readline-devel redhat-lsb rpcgen rpcsvc-proto-devel \
#     rsync sed sudo systemd-devel tar tree wget which xfsprogs-devel yum-utils zlib-devel rng-tools
# dnf config-manager --set-disabled devel

dnf -y autoremove
dnf -y clean all

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

#./configure -j 3 --enable-fhs --libdir=/lib64 --prefix=/usr --sysconfdir=/etc --localstatedir=/var --sbindir=/sbin/ --bindir=/bin/ --mandir=/usr/share/man/ --with-systemd --with-quotas --enable-selftest --progress
./configure -j 3 --mandir=/usr/share/man/ --sysconfdir=/etc --with-systemd --with-quotas --enable-selftest --progress
make -j 3
#make -j 3 test
make -j 3 install

cd ..

export PATH=/usr/local/samba/bin/:/usr/local/samba/sbin/:$PATH
cat << EOF >> ~/.bashrc

export PATH=/usr/local/samba/bin/:/usr/local/samba/sbin/:$PATH

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

firewall-cmd --add-service={dns,ldap,ldaps,kerberos}
firewall-cmd --add-port={389/udp,135/tcp,135/udp,138/udp,138/tcp,137/tcp,137/udp,139/udp,139/tcp,445/tcp,445/udp,3268/udp,3268/tcp,3269/tcp,3269/udp,49152/tcp}


#ln -s /usr/local/samba/lib/libnss_winbind.so.2 /lib64/
#ln -s /lib64/libnss_winbind.so.2 /lib64/libnss_winbind.so
#ldconfig
#ln -s /usr/local/samba/lib/security/pam_winbind.so /lib64/security/


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

test -f /etc/samba/smb.conf.org && cp /etc/samba/smb.conf /etc/samba/smb.conf.bak || cp /etc/samba/smb.conf /etc/samba/smb.conf.org
rm /usr/local/samba/private/krb5.conf

samba-tool domain provision --server-role=dc --use-rfc2307 --host-name=$HostnameServ --domain=$dominio --realm=$dominio.$extension --adminpass=abc123. --dns-backend=SAMBA_INTERNAL
sleep 3

#cp /var/lib/samba/private/krb5.conf /etc/
rm /etc/krb5.conf
ln -s /usr/local/samba/private/krb5.conf /etc/

cat << EOF > /etc/nsswitch.conf
# Generated by authselect on Wed Jun 16 18:11:28 2021
# Do not modify this file manually.

# If you want to make changes to nsswitch.conf please modify
# /etc/authselect/user-nsswitch.conf and run 'authselect apply-changes'.
#
# Note that your changes may not be applied as they may be
# overwritten by selected profile. Maps set in the authselect
# profile takes always precedence and overwrites the same maps
# set in the user file. Only maps that are not set by the profile
# are applied from the user file.
#
# For example, if the profile sets:
#     passwd: sss files
# and /etc/authselect/user-nsswitch.conf contains:
#     passwd: files
#     hosts: files dns
# the resulting generated nsswitch.conf will be:
#     passwd: sss files # from profile
#     hosts: files dns  # from user file

passwd:     sss files winbind systemd
group:      sss files winbind systemd
netgroup:   sss files
automount:  sss files
services:   sss files

# Included from /etc/authselect/user-nsswitch.conf

#
# /etc/nsswitch.conf
#
# Name Service Switch config file. This file should be
# sorted with the most-used services at the beginning.
#
# Valid databases are: aliases, ethers, group, gshadow, hosts,
# initgroups, netgroup, networks, passwd, protocols, publickey,
# rpc, services, and shadow.
#
# Valid service provider entries include (in alphabetical order):
#
#	compat			Use /etc files plus *_compat pseudo-db
#	db			Use the pre-processed /var/db files
#	dns			Use DNS (Domain Name Service)
#	files			Use the local files in /etc
#	hesiod			Use Hesiod (DNS) for user lookups
#	nis			Use NIS (NIS version 2), also called YP
#	nisplus			Use NIS+ (NIS version 3)
#
# See ' info libc 'NSS Basics' ' for more information.
#
# Commonly used alternative service providers (may need installation):
#
#	ldap			Use LDAP directory server
#	myhostname		Use systemd host names
#	mymachines		Use systemd machine names
#	mdns*, mdns*_minimal	Use Avahi mDNS/DNS-SD
#	resolve			Use systemd resolved resolver
#	sss			Use System Security Services Daemon (sssd)
#	systemd			Use systemd for dynamic user option
#	winbind			Use Samba winbind support
#	wins			Use Samba wins support
#	wrapper			Use wrapper module for testing
#
# Notes:
#
# 'sssd' performs its own 'files'-based caching, so it should generally
# come before 'files'.
#
# WARNING: Running nscd with a secondary caching service like sssd may
# 	   lead to unexpected behaviour, especially with how long
# 	   entries are cached.
#
# Installation instructions:
#
# To use 'db', install the appropriate package(s) (provide 'makedb' and
# libnss_db.so.*), and place the 'db' in front of 'files' for entries
# you want to be looked up first in the databases, like this:
#
# passwd:    db files
# shadow:    db files
# group:     db files

# In order of likelihood of use to accelerate lookup.
shadow:     files sss winbind
hosts:      files dns wins myhostname

aliases:    files
ethers:     files
gshadow:    files
# Allow initgroups to default to the setting for group.
# initgroups: files
networks:   files dns
protocols:  files
publickey:  files
rpc:        files

EOF

systemctl start samba-ad-dc
systemctl status samba-ad-dc

cfdisk /dev/sdb

mkfs.ext4 -L Usuarios /dev/sdb1
mkfs.ext4 -L Comun /dev/sdb2

mkdir -p /comun/VentasExtranjero #&& mkdir /home/$dominio

cp -ra /usr/local/samba/var/locks/sysvol/$dominio.$extension/. /home/$dominio
chown "$dominio\Administrator":"$dominio\Domain Admins" /home/$dominio
rm -rf /home/$dominio/Policies

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

firewall-cmd --permanent --add-service=nfs
firewall-cmd --permanent --add-service=rpc-bind
firewall-cmd --permanent --add-service=mountd
firewall-cmd --reload

echo "/home/$dominio 	$IpNetwork/255.255.255.0(rw,no_root_squash,no_subtree_check)" > /etc/exports
echo "/comun 			$IpNetwork/255.255.255.0(rw,no_root_squash,no_subtree_check)" >> /etc/exports
service nfs-server restart
exportfs -v

#useradd general -M -N -u 1001
#passwd -l general
#setquota -u general $QuotaDefaultSize $QuotaDefaultSize  0 0 /home/$dominio

cp -ra /usr/local/samba/var/locks/sysvol/$dominio.$extension/. /home/$dominio/.
rm -rf /home/$dominio/Policies

#net rpc group add "Unix Admins" -L -U Administrator
<<<<<<< HEAD
samba-tool group add "Unix Admins" --gid-number 20000 --nis-domain="$dominio"
=======
samba-tool group add "Unix Admins" --gid-number $UnixAdmins_GID --nis-domain="$dominio"
>>>>>>> 2c2a4d8 (fix: various scripts errors fixed)
#net rpc group addmem "Administrators" "Unix Admins" -U Administrator
samba-tool group addmembers "Administrators" "Unix Admins"
echo -e "abc123." | net rpc user setprimarygroup Administrator "Domain Admins" -U Administrator
echo -e "abc123." | net rpc rights grant "$dominio\Unix Admins" SeDiskOperatorPrivilege -U "$dominio\Administrator"
#net rpc rights list privileges SeDiskOperatorPrivilege -U "Administrator"


chown "$dominio\Administrator":"$dominio\Unix Admins" /home/$dominio
mkdir -p /home/$dominio/{profiles,users,VentasExtranjero}
chown -R "$dominio\Administrator":"$dominio\Domain Admins" /home/$dominio/profiles
chown -R "$dominio\Administrator":"$dominio\Unix Admins" /home/$dominio/users
chmod o+rx /home/$dominio /home/$dominio/users
#chmod g-w /home/$dominio
chmod g-w -R /home/$dominio/users
#chown -R root:users /home/$dominio/{profiles,users}

mkdir -p /home/$dominio/users/Administrator
chown "$dominio\Administrator":"BUILTIN\Administrators" /home/$dominio/users/Administrator
mkdir -p /home/$dominio/VentasExtranjero
#chown -R root:"" /home/$dominio/VentasExtranjero

cp /etc/samba/smb.conf /etc/samba/smb.conf.generated

cat << EOF > /etc/samba/smb.conf
# Global parameters
[global]
	dns forwarder = 1.1.1.1
	netbios name = $HostnameServ
	realm = $dominio.$extension
	server role = active directory domain controller
	workgroup = $dominio

  rpc_server:tcpip = no
  rpc_daemon:spoolssd = embedded
  rpc_server:spoolss = embedded
  rpc_server:winreg = embedded
  rpc_server:ntsvcs = embedded
  rpc_server:eventlog = embedded
  rpc_server:srvsvc = embedded
  rpc_server:svcctl = embedded
  rpc_server:default = external
  winbindd:use external pipes = true

# idmap config * : backend = tdb
	idmap_ldb:use rfc2307 = yes

	winbind nss info = rfc2307
#	winbind use default domain = yes
	winbind offline logon = no
	winbind enum users = yes
	winbind enum groups = yes
	winbind nested groups = yes

	template shell = /bin/bash
	template homedir = /home/$dominio/users/%U

	vfs objects = dfs_samba4 acl_xattr
	map acl inherit = yes

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

[VentasExtranjero]
	path = /comun/VentasExtranjero
	read only = no
	vfs objects = dfs_samba4 acl_xattr

EOF

systemctl restart samba-ad-dc

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
