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
export NumExa=5
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

## VBoxManage Variables:
export OVAsBaseFolder=/run/media/$USER/P300-BF/_OVAs/ASO
export DisksBaseFolderSource=/run/media/$USER/P300-BF/_Disks
export DisksBaseFolderTarget=/mnt/5C5C75F75C75CC70/VMs/Disks
export VMsBaseFolder=/mnt/5C5C75F75C75CC70/VMs/Disks
# export OVA=/run/media/$USER/P300-BF\VirtualMachines\_OVAs\ASO\%VBoxName%.ova
# export Disk="$VMsBaseFolder/$S1\%VBoxName%-disk001.vmdk"
# export SettingsFile="$VMsBaseFolder/$S1/$S1.vbox"
# export BaseFolder=D:\gomgardav\ASO\dirEXA202104GOMGARDAV

export S1=S1$VarExa
export VBoxNameS1=COSbase8
export C1=C1$VarExa
export VBoxNameC1=ubase20_04
export C2=C2$VarExa
export VBoxNameC2=wbase21H1

export NAT=${dominio}
# export NAT=exa2021marzo05
SharedFolder="$(pwd)"
export SharedFolder

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
