#!/bin/bash
echo
echo ##########################
echo # Creado por:  gomgardav #
echo # [ David Gómez García ] #
echo ##########################
echo

log=./srv_cos_01-00_salida.sal
cd ~/samba || exit
source ./00_00_VAR.sh

dnf -y install whois expect

#echo -e "abc123." > /tmp/openssl-passwd.txt
#openssl passwd -1 -noverify -in /tmp/openssl-passwd.txt > /tmp/passwd.txt
python -c 'import crypt; print(crypt.crypt("abc123.", crypt.mksalt(crypt.METHOD_SHA512)))' > /tmp/passwd.txt
\rm -f /tmp/openssl-passwd.txt

useradd gomgardav   -u ${UidTucuenta}   -m -U -s /bin/bash -p "$( cat /tmp/passwd.txt )"
useradd antonio     -u ${UidAntonio}    -m -U -s /bin/bash -p "$( cat /tmp/passwd.txt )"

\rm -f /tmp/passwd.txt
