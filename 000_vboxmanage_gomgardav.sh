#!/bin/bash
echo
echo ##########################
echo # Creado por:  gomgardav #
echo # [ David Gómez García ] #
echo ##########################
echo

cd "${0%/*}" || exit
log=./vbm_000_salida.sal
# cd /run/media/deiv70/P300-NF/gomgardav/_ASIR2/ASO/_Exa/dirEXA212201GOMGARDAV/
cd /home/deiv70/Documentos/dirEXA212203GOMGARDAV/ || exit
source ./00_00_VAR.sh

# VMsBaseFolder=/run/media/$USER/P300-NF/_VBox/
OVAsBaseFolder=/run/media/$USER/P300-BF/_OVAs/ASO
DisksBaseFolderSource=/run/media/$USER/P300-BF/_Disks
DisksBaseFolderTarget=/run/media/$USER/5C5C75F75C75CC70/VMs/Disks
VMsBaseFolder=/run/media/$USER/5C5C75F75C75CC70/VMs/Disks

## VBoxManage Variables:
NumPuesto=3
NumEXA=4

VarEXA=EXA21220${NumEXA}GOMGARDAV
# VarEXA=EXA2021MARZO05GOMGARDAV
S1=S1$VarEXA
	VBoxNameS1=COSbase8
C1=C1$VarEXA
	VBoxNameC1=ubase20_04
C2=C2$VarEXA
	VBoxNameC2=wbase21H1

NAT=${NumEXA}pyme0$NumPuesto
# NAT=exa2021marzo05
#	OVA=/run/media/$USER/P300-BF\VirtualMachines\_OVAs\ASO\%VBoxName%.ova
#	Disk="$VMsBaseFolder/$S1\%VBoxName%-disk001.vmdk"
#	SettingsFile="$VMsBaseFolder/$S1/$S1.vbox"
# BaseFolder=D:\gomgardav\ASO\dirEXA202104GOMGARDAV
SharedFolder=$(pwd)

VBoxManage natnetwork add --netname "$NAT" --network "172.$NumEXA.$NumPuesto.0/24" --enable --dhcp off
VBoxManage natnetwork modify --netname "$NAT" --port-forward-4 "SSH-${NumPuesto}1:tcp:[]:${NumPuesto}22${NumPuesto}1:[172.$NumEXA.$NumPuesto.${NumPuesto}1]:22"
VBoxManage natnetwork modify --netname "$NAT" --port-forward-4 "80-${NumPuesto}1:tcp:[]:${NumPuesto}80${NumPuesto}1:[172.$NumEXA.$NumPuesto.${NumPuesto}1]:80"
VBoxManage natnetwork modify --netname "$NAT" --port-forward-4 "SSH-${NumPuesto}2:tcp:[]:${NumPuesto}22${NumPuesto}2:[172.$NumEXA.$NumPuesto.${NumPuesto}2]:22"
VBoxManage natnetwork modify --netname "$NAT" --port-forward-4 "SSH-${NumPuesto}3:tcp:[]:${NumPuesto}22${NumPuesto}3:[172.$NumEXA.$NumPuesto.${NumPuesto}3]:22"
VBoxManage natnetwork start --netname "$NAT"

VBoxManage import "/run/media/$USER/P300-BF/_OVAs/ASO/$VBoxNameS1.ova" --vsys 0 --vmname "$S1" --unit 14 --disk "$VMsBaseFolder/$S1/$VBoxNameS1-disk001.vmdk" --settingsfile "$VMsBaseFolder/$S1/$S1.vbox"
VBoxManage createmedium disk --filename "$VMsBaseFolder/$S1/$VBoxNameS1-Datos.vmdk" --size 10240 --format VMDK
VBoxManage storageattach "$S1" --storagectl "SATA" --device 0 --port 1 --type hdd --medium "$VMsBaseFolder/$S1/$VBoxNameS1-Datos.vmdk"
VBoxManage modifyvm "$S1" --nic1 natnetwork --nictype1 virtio --nat-network1 "$NAT"
# VBoxManage modifyvm "$S1" --memory 512
VBoxManage modifyvm "$S1" --memory 1024
VBoxManage modifyvm "$S1" --cpus 1
VBoxManage sharedfolder remove "$S1" --name=_Shared
VBoxManage sharedfolder add "$S1" --name=_Shared --hostpath="$SharedFolder"

VBoxManage import "/run/media/$USER/P300-BF/_OVAs/ASO/$VBoxNameC1.ova" --vsys 0 --vmname "$C1" --unit 14 --disk "$VMsBaseFolder/$C1/$VBoxNameC1-disk001.vmdk" --settingsfile "$VMsBaseFolder/$C1/$C1.vbox"
VBoxManage modifyvm "$C1" --nic1 natnetwork --nictype1 virtio --nat-network1 "$NAT"
# VBoxManage modifyvm "$C1" --memory 1024
VBoxManage modifyvm "$C1" --memory 2048
VBoxManage modifyvm "$C1" --cpus 1
VBoxManage sharedfolder remove "$C1" --name=_Shared
VBoxManage sharedfolder add "$C1" --name=_Shared --hostpath="$SharedFolder"
VBoxManage setextradata "$C1" GUI/MenuBar/Enabled false
VBoxManage setextradata "$C1" GUI/StatusBar/Enabled false

VBoxManage import "/run/media/$USER/P300-BF/_OVAs/ASO/$VBoxNameC2.ova" --vsys 0 --vmname "$C2" --unit 14 --disk "$VMsBaseFolder/$C2/$VBoxNameC2-disk001.vmdk" --settingsfile "$VMsBaseFolder/$C2/$C2.vbox"
VBoxManage modifyvm "$C2" --nic1 natnetwork --nictype1 virtio --nat-network1 "$NAT"
# VBoxManage modifyvm "$C2" --memory 1024
VBoxManage modifyvm "$C2" --memory 2048
VBoxManage modifyvm "$C2" --cpus 1
VBoxManage sharedfolder remove "$C2" --name=_Shared
VBoxManage sharedfolder add "$C2" --name=_Shared --hostpath="$SharedFolder"

VBoxManage setextradata global GUI/MiniToolBarAlignment Top
