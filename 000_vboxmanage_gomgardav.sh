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
# cd /home/deiv70/Documentos/dirEXA212205GOMGARDAV/ || exit
source ./00_00_VAR.sh

VBoxManage natnetwork add --netname "$NAT" --network "172.16.$NumExa.0/24" --enable --dhcp off
VBoxManage natnetwork modify --netname "$NAT" --port-forward-4 "SSH-${NumUser}1:tcp:[]:${NumUser}22${NumUser}1:[172.16.${NumExa}.${NumUser}1]:22"
VBoxManage natnetwork modify --netname "$NAT" --port-forward-4 "80-${NumUser}1:tcp:[]:${NumUser}80${NumUser}1:[172.16.${NumExa}.${NumUser}1]:80"
VBoxManage natnetwork modify --netname "$NAT" --port-forward-4 "SSH-${NumUser}2:tcp:[]:${NumUser}22${NumUser}2:[172.16.${NumExa}.${NumUser}2]:22"
VBoxManage natnetwork modify --netname "$NAT" --port-forward-4 "SSH-${NumUser}3:tcp:[]:${NumUser}22${NumUser}3:[172.16.${NumExa}.${NumUser}3]:22"
VBoxManage natnetwork start --netname "$NAT"

# VBoxManage import "$OVAsBaseFolder/${VBoxNameS1}.ova" --vsys 0 --vmname "%S1%" --unit 12 --disk "%VMsBaseFolder%\%S1%/${VBoxNameS1}-disk001.vmdk" --settingsfile "%VMsBaseFolder%\%S1%\%S1%.vbox"
VBoxManage createvm --name "$S1" --register --ostype RedHat_64
VBoxManage createmedium disk --filename "${DisksBaseFolderTarget}/${VBoxNameS1}-Datos.qcow" --size 10240 --format QCOW
VBoxManage storagectl "$S1" --name "VirtIO" --add virtio --controller VirtIO
VBoxManage storagectl "$S1" --name "SATA" --add sata --controller IntelAHCI --portcount 2
VBoxManage storageattach "$S1" --storagectl "VirtIO" --device 0 --port 0 --type hdd --medium "${DisksBaseFolderTarget}/${VBoxNameS1}.qcow"
VBoxManage storageattach "$S1" --storagectl "SATA" --device 0 --port 0 --type hdd --medium "${DisksBaseFolderTarget}/${VBoxNameS1}-Datos.qcow"
VBoxManage storageattach "$S1" --storagectl "SATA" --device 0 --port 1 --type dvddrive --medium "none"
VBoxManage modifyvm "$S1" --nic1 natnetwork --nictype1 virtio --nat-network1 "${NAT}" --vram 16 --memory 1536 --cpus 1 --cpuhotplug on --paravirtprovider kvm
VBoxManage sharedfolder remove "$S1" --name=_Shared
VBoxManage sharedfolder add "$S1" --name=_Shared --hostpath="${SharedFolder}"

# VBoxManage import "$OVAsBaseFolder/${VBoxNameC1}.ova" --vsys 0 --vmname "$C1" --unit 14 --disk "%VMsBaseFolder%/${C1}/${VBoxNameC1}-disk001.vmdk" --settingsfile "%VMsBaseFolder%/${C1}/${C1}.vbox"
VBoxManage createvm --name "$C1" --register --ostype Ubuntu_64
VBoxManage storagectl "$C1" --name "VirtIO" --add virtio --controller VirtIO
VBoxManage storagectl "$C1" --name "SATA" --add sata --controller IntelAHCI --portcount 2
VBoxManage storageattach "$C1" --storagectl "VirtIO" --device 0 --port 0 --type hdd --medium "${DisksBaseFolderTarget}/${VBoxNameC1}.qcow"
VBoxManage storageattach "$C1" --storagectl "SATA" --device 0 --port 1 --type dvddrive --medium "none"
VBoxManage modifyvm "$C1" --nic1 natnetwork --nictype1 virtio --nat-network1 "$NAT" --vram 36 --memory 1536 --cpus 1 --cpuhotplug on --paravirtprovider kvm
VBoxManage sharedfolder remove "$C1" --name=_Shared
VBoxManage sharedfolder add "$C1" --name=_Shared --hostpath="${SharedFolder}"
#VBoxManage setextradata "$C1" GUI/MenuBar/Enabled false
#VBoxManage setextradata "$C1" GUI/StatusBar/Enabled false

# VBoxManage import "$OVAsBaseFolder/${VBoxNameC2}.ova" --vsys 0 --vmname "$C2" --unit 14 --disk "%VMsBaseFolder%/${C2}/${VBoxNameC2}-disk001.vmdk" --settingsfile "%VMsBaseFolder%/${C2}/${C2}.vbox"
VBoxManage createvm --name "$C2" --register --ostype Windows10_64
VBoxManage storagectl "$C2" --name "SATA" --add sata --controller IntelAHCI --portcount 2
VBoxManage storageattach "$C2" --storagectl "SATA" --device 0 --port 0 --type hdd --medium "${DisksBaseFolderTarget}/${VBoxNameC2}.qcow"
VBoxManage storageattach "$C2" --storagectl "SATA" --device 0 --port 1 --type dvddrive --medium "none"
VBoxManage modifyvm "$C2" --nic1 natnetwork --nictype1 virtio --nat-network1 "$NAT" --vram 36 --memory 1536 --cpus 1 --cpuhotplug on --paravirtprovider kvm
VBoxManage sharedfolder remove "$C2" --name=_Shared
VBoxManage sharedfolder add "$C2" --name=_Shared --hostpath="${SharedFolder}"

VBoxManage setextradata global GUI/MiniToolBarAlignment Top
