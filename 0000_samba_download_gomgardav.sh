#!/bin/bash
echo
echo ##########################
echo # Creado por:  gomgardav #
echo # [ David Gómez García ] #
echo ##########################
echo

wget https://download.samba.org/pub/samba/samba-pubkey.asc
wget https://download.samba.org/pub/samba/stable/samba-4.14.12.tar.asc
wget https://download.samba.org/pub/samba/stable/samba-4.14.12.tar.gz

gpg --import samba-pubkey.asc
gunzip samba-4.14.12.tar.gz
gpg --verify samba-4.14.12.tar.asc
