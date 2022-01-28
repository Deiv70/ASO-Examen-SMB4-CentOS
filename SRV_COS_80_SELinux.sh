#!/bin/bash
##########################
# Creado por:  gomgardav #
# [ David Gómez García ] #
##########################




setsebool -P domain_can_mmap_files 1

semanage fcontext -a -t rpm_var_run_t -f a '/usr/local/samba/var/run/winbindd/pipe'
semanage fcontext -m -t rpm_var_run_t -f a '/usr/local/samba/var/run/winbindd/pipe'
/sbin/restorecon -Rv /usr/local/samba/
/sbin/restorecon -Rv /usr/share/man/

#/sbin/restorecon -v /usr/local/samba/sbin/smbd
ausearch -c 'smbd' --raw | audit2allow -M my-smbd
semodule -X 300 -i my-smbd.pp

#/sbin/restorecon -v /usr/local/samba/sbin/samba
#ausearch -c '(samba)' --raw | audit2allow -M my-samba
#semodule -X 300 -i my-samba.pp
ausearch -c 'samba' --raw | audit2allow -M my-samba
semodule -X 300 -i my-samba.pp

#/sbin/restorecon -v /usr/local/samba/lib/libnss_winbind.so.2
ausearch -c 'dbus-daemon-lau' --raw | audit2allow -M my-dbusdaemonlau
semodule -X 300 -i my-dbusdaemonlau.pp

#/sbin/restorecon -v /usr/local/samba/lib/private/libwinbind-client-samba4.so
ausearch -c 'polkitd' --raw | audit2allow -M my-polkitd
semodule -X 300 -i my-polkitd.pp

ausearch -c 'systemd-logind' --raw | audit2allow -M my-systemdlogind
semodule -X 300 -i my-systemdlogind.pp

ausearch -c 'pmdaproc' --raw | audit2allow -M my-pmdaproc
semodule -X 300 -i my-pmdaproc.pp

ausearch -c 'auditd' --raw | audit2allow -M my-auditd
semodule -X 300 -i my-auditd.pp

ausearch -c 'mandb' --raw | audit2allow -M my-mandb
semodule -X 300 -i my-mandb.pp

systemctl restart samba-ad-dc
