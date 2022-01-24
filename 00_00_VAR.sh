#!/bin/bash
##########################
# Creado por:  gomgardav #
# [ David Gómez García ] #
##########################

exec > >(tee "$log") 2>&1
## [ Functions ]:
#export Functions=00_00_FUNCTIONS.sh
#source ./"$Functions"

export NumUser=3
export NumExa=4
export VarExa=EXA21220${NumExa}GOMGARDAV
#export VarExa=EXA2021MARZO05GOMGARDAV
export Threads=9

## Dominio
# export Dominio=${NumExa}PYME0$NumUser
export Dominio=${NumExa}APYME0$NumUser
export Extension=LOCAL
# export dominio=${NumExa}pyme0$NumUser
export dominio=${NumExa}apyme0$NumUser
export extension=local

export HostnameServ=S1
export HostnameClie=C1

export UidTucuenta=2204
export UidAntonio=2100

export PrefIpServInve=$NumExa.16.172
export PrefIpServ=172.16.$NumExa
#export PrefIpServ2=172.16

export SufiIpServ=${NumUser}1
export SufiIpClie=${NumUser}2

export IpServ=$PrefIpServ.$SufiIpServ
export IpClie=$PrefIpServ.$SufiIpClie
export MacClie=08:00:27:A6:83:89

export Mask=24
export Netmask=255.255.255.0
export IpNetwork=$PrefIpServ.0
export IpGateway=$PrefIpServ.1
export DnsNat=$IpGateway
export Dns=$IpServ

## DHCP Specific:
export IpDhcpIni=$PrefIpServ.${NumUser}2
export IpDhcpFin=$PrefIpServ.150
export NetmaskDhcp=$Netmask
export IpNetworkDhcp=$IpNetwork
export IpGatewayDhcp=$IpGateway
export DnsDhcp=ns.$Dominio.$Extension

## Old Variables:
export DIR_HOME_LDAP=/home/$Dominio
export DIR_COMUN=/comun

## SMB Specific:
export UserAddVariables=00_00_ADD_USERS.txt
export QuotaDefaultSize=70M
export Users_GID=15000

export OuUsuarios=usuarios
export OuGrupos=grupos
export OuMaquinas=maquinas

export GruposP=empleado,encargado
export GruposS=ventas,desarrollo,g_ventas,g_vental,g_ventae,g_vasia,g_veuropa,g_voceania
export GruposM=aula01,aula02

export GruposP_T=empleado
export GruposPM_T=encargado #(Estos Grupos Principales pueden estár en más de 1 Grupo)
export GruposS_T=ventas,desarrollo,g_ventas,g_vental,g_ventae,g_vasia,g_veuropa,g_voceania
export GruposM_T=aula01,aula02
