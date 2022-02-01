#!/bin/bash
echo
echo ##########################
echo # Creado por:  gomgardav #
echo # [ David Gómez García ] #
echo ##########################
echo

cd /mnt/_Shared || exit
log=./srv_cos_00_salida.sal
source ./00_00_VAR.sh

rm -rf ~/samba && mkdir ~/samba
\cp -rf . ~/samba/.

#: To pre-download used tools, use the next command:
#dnf -y install --downloadonly epel-release dnf-plugins-core openssh-server zsh-completions bpytop screen tmux  gcc make perl bzip2 git elfutils-devel.x86_64 elfutils-libelf-devel dkms selinux-policy-devel  whois expect  docbook-style-xsl gcc gdb gnutls-devel gpgme-devel jansson-devel keyutils-libs-devel krb5-workstation libacl-devel libaio-devel libarchive-devel libattr-devel libblkid-devel libtasn1 libtasn1-tools libxml2-devel libxslt lmdb-devel openldap-devel pam-devel perl perl-ExtUtils-MakeMaker perl-Parse-Yapp popt-devel python3-cryptography python3-dns python3-gpg python36-devel readline-devel systemd-devel tar zlib-devel rpcgen libtirpc-devel rpcsvc-proto-devel acl attr autoconf automake docbook-style-xsl gcc gdb jansson-devel krb5-devel krb5-workstation libacl-devel libarchive-devel libattr-devel libtasn1-tools libxslt lmdb-devel make openldap-devel pam-devel python36-devel  patch python3-markdown python3-iso8601 python3-cryptography python3-pyasn1 python3-asn1crypto cups-devel oddjob oddjob-mkhomedir  wget acl attr gvfs gvfs-devel dbus dbus-tools dbus-glib-devel dbus-libs dbus-c++-devel quota chrony nfs-utils nfs4-acl-tools  dhcp-server  cups cups-ipptool hplip  dbus-c++-devel dbus-glib-devel gvfs gvfs-devel avahi-glib dbus-c++ dbus-c++-glib dbus-devel gcr glib2-devel gvfs-client libcdio libcdio-paranoia pcre-cpp pcre-devel pcre-utf16 pcre-utf32 cups-devel python3-asn1crypto python3-cryptography python3-iso8601 python3-markdown python3-pyasn1 gmp-c++ gmp-devel gnutls-c++ gnutls-dane gnutls-devel keyutils-libs-devel krb5-devel libcom_err-devel libidn2-devel libkadm5 libselinux-devel libsepol-devel libtasn1-devel libverto-devel nettle-devel p11-kit-devel pcre2-devel pcre2-utf32 python3-cffi python3-pycparser gpgme-devel jansson-devel krb5-workstation libacl-devel libaio-devel libarchive-devel libattr-devel libblkid-devel libtasn1-tools libtirpc-devel libxml2-devel lmdb-devel openldap-devel pam-devel perl-Parse-Yapp popt-devel python3-dns python36-devel readline-devel rpcgen rpcsvc-proto-devel systemd-devel cyrus-sasl-devel libgpg-error-devel libuuid-devel ncurses-c++-libs ncurses-devel platform-python-devel python3-rpm-generators

#yum install -y device-mapper-multipath-libs gsettings-desktop-schemas dbus-c++-devel dbus-glib-devel gvfs gvfs-devel nfs-utils nfs4-acl-tools adwaita-cursor-theme adwaita-icon-theme at-spi2-atk at-spi2-core avahi-glib cairo-gobject colord-libs dbus-c++ dconf device-mapper-multipath dosfstools gcr gdisk glib-networking gssproxy gtk3 gvfs-client json-glib keyutils libatasmart libbasicobjects libblockdev libblockdev-crypto libblockdev-fs libblockdev-loop libblockdev-mdraid libblockdev-part libblockdev-swap libblockdev-utils libbluray libbytesize libcdio libcdio-paranoia libcollection libepoxy libgudev1 libgusb libini_config libnfsidmap libpath_utils libref_array libsecret libsoup libudisks2 libwayland-cursor libwayland-egl libxkbcommon mdadm rest udisks2 volume_key-libs xkeyboard-config 
#yum install -y wget acl attr gvfs gvfs-devel dbus dbus-tools dbus-glib-devel dbus-libs dbus-c++-devel quota nfs-utils nfs4-acl-tools patch python36-markdown python36-iso8601 python36-cryptography python36-pyasn1 python36-asn1crypto cups-devel oddjob oddjob-mkhomedir 
