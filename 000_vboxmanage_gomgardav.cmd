@echo off
chcp 65001
echo
echo ##########################
echo # Creado por:  gomgardav #
echo # [ David Gómez García ] #
echo ##########################
echo

REM ## Añadir VBoxManage al Path:
PATH=%PATH%;"C:\Program Files\Oracle\VirtualBox"
REM set ISOsBaseFolder=
set OVAsBaseFolder=E:\_OVAs\ASO
set DisksBaseFolderSource=E:\_Disks
set DisksBaseFolderTarget=D:\gomgardav\_VBox\_Disks
set VMsBaseFolder=D:\gomgardav\_VBox\_VMs
REM set VMsBaseFolder=D:\Users\Deiv70\VirtualMachines\VirtualBox VMs
REM set VMsBaseFolder=G:\_VBox

REM ## VBoxManage Variables:
set NumPuesto=3
set NumEXA=6

set VarEXA=EXA21220%NumEXA%GOMGARDAV
REM set VarEXA=EXA2021MARZO05GOMGARDAV
set S1=S1%VarEXA%
	set VBoxNameS1=COSbase8
set C1=C1%VarEXA%
	set VBoxNameC1=ubase20_04
set C2=C2%VarEXA%
	set VBoxNameC2=wbase21H1

set NAT=%NumEXA%dpyme0%NumPuesto%
REM set NAT=%NumEXA%pyme0%NumPuesto%
REM set NAT=exa2021marzo05
REM	set OVA=E:\VirtualMachines\_OVAs\ASO\%VBoxName%.ova
REM	set Disk=%VMsBaseFolder%\%S1%\%VBoxName%-disk001.vmdk
REM	set SettingsFile=%VMsBaseFolder%\%S1%\%S1%.vbox
REM set BaseFolder=D:\gomgardav\ASO\dirEXA202104GOMGARDAV
cd > %temp%/SharedFolder && set /P SharedFolder=<%temp%\SharedFolder

VBoxManage natnetwork add --netname "%NAT%" --network "172.16.%NumPuesto%.0/24" --enable --dhcp off
VBoxManage natnetwork modify --netname "%NAT%" --port-forward-4 "SSH-%NumPuesto%1:tcp:[]:%NumPuesto%22%NumPuesto%1:[172.16.%NumPuesto%.%NumPuesto%1]:22"
VBoxManage natnetwork modify --netname "%NAT%" --port-forward-4 "80-%NumPuesto%1:tcp:[]:%NumPuesto%80%NumPuesto%1:[172.16.%NumPuesto%.%NumPuesto%1]:80"
VBoxManage natnetwork modify --netname "%NAT%" --port-forward-4 "SSH-%NumPuesto%2:tcp:[]:%NumPuesto%22%NumPuesto%2:[172.16.%NumPuesto%.%NumPuesto%2]:22"
VBoxManage natnetwork modify --netname "%NAT%" --port-forward-4 "SSH-%NumPuesto%3:tcp:[]:%NumPuesto%22%NumPuesto%3:[172.16.%NumPuesto%.%NumPuesto%3]:22"

REM VBoxManage import "%OVAsBaseFolder%\%VBoxNameS1%.ova" --vsys 0 --vmname "%S1%" --unit 12 --disk "%VMsBaseFolder%\%S1%\%VBoxNameS1%-disk001.vmdk" --settingsfile "%VMsBaseFolder%\%S1%\%S1%.vbox"
VBoxManage createvm --name "%S1%" --register --ostype RedHat_64
VBoxManage createmedium disk --filename "%DisksBaseFolderTarget%\%VBoxNameS1%-Datos.vdi" --size 10240 --format VDI
VBoxManage storagectl "%S1%" --name "IDE" --add ide --controller PIIX4 --portcount 1
VBoxManage storagectl "%S1%" --name "SATA" --add sata --controller IntelAHCI --portcount 2
VBoxManage storageattach "%S1%" --storagectl "SATA" --device 0 --port 0 --type hdd --medium "%DisksBaseFolderTarget%\%VBoxNameS1%.vdi"
VBoxManage storageattach "%S1%" --storagectl "SATA" --device 0 --port 1 --type hdd --medium "%DisksBaseFolderTarget%\%VBoxNameS1%-Datos.vdi"
VBoxManage storageattach "%S1%" --storagectl "IDE"  --device 0 --port 0 --type dvddrive --medium "none"
VBoxManage modifyvm "%S1%" --nic1 natnetwork --nictype1 virtio --nat-network1 "%NAT%" --vram 16 --graphicscontroller vmsvga --memory 2048 --cpus 8 --audio none
REM VBoxManage modifyvm "%S1%" --cpus 2
VBoxManage sharedfolder remove "%S1%" --name=_Shared
VBoxManage sharedfolder add "%S1%" --name=_Shared --hostpath="%SharedFolder%"

REM VBoxManage import "%OVAsBaseFolder%\%VBoxNameC1%.ova" --vsys 0 --vmname "%C1%" --unit 14 --disk "%VMsBaseFolder%\%C1%\%VBoxNameC1%-disk001.vmdk" --settingsfile "%VMsBaseFolder%\%C1%\%C1%.vbox"
VBoxManage createvm --name "%C1%" --register --ostype Ubuntu_64
VBoxManage storagectl "%C1%" --name "IDE" --add IDE --controller PIIX4 --portcount 1
VBoxManage storagectl "%C1%" --name "SATA" --add sata --controller IntelAHCI --portcount 1
VBoxManage storageattach "%C1%" --storagectl "SATA" --device 0 --port 0 --type hdd --medium "%DisksBaseFolderTarget%\%VBoxNameC1%.vdi"
VBoxManage storageattach "%C1%" --storagectl "IDE"  --device 0 --port 0 --type dvddrive --medium "none"
VBoxManage modifyvm "%C1%" --nic1 natnetwork --nictype1 virtio --nat-network1 "%NAT%" --vram 128 --graphicscontroller vmsvga --memory 2048 --cpus 2 --audio none
VBoxManage sharedfolder remove "%C1%" --name=_Shared
VBoxManage sharedfolder add "%C1%" --name=_Shared --hostpath="%SharedFolder%"

REM VBoxManage import "%OVAsBaseFolder%\%VBoxNameC2%.ova" --vsys 0 --vmname "%C2%" --unit 14 --disk "%VMsBaseFolder%\%C2%\%VBoxNameC2%-disk001.vmdk" --settingsfile "%VMsBaseFolder%\%C2%\%C2%.vbox"
VBoxManage createvm --name "%C2%" --register --ostype Windows10_64
VBoxManage storagectl "%C2%" --name "SATA" --add sata --controller IntelAHCI --portcount 2
VBoxManage storageattach "%C2%" --storagectl "SATA" --device 0 --port 0 --type hdd --medium "%DisksBaseFolderTarget%\%VBoxNameC2%.vdi"
VBoxManage storageattach "%C2%" --storagectl "SATA" --device 0 --port 1 --type dvddrive --medium "none"
VBoxManage modifyvm "%C2%" --nic1 natnetwork --nictype1 virtio --nat-network1 "%NAT%" --vram 128 --graphicscontroller vboxsvga --memory 2048 --cpus 2 --audio none
VBoxManage sharedfolder remove "%C2%" --name=_Shared
VBoxManage sharedfolder add "%C2%" --name=_Shared --hostpath="%SharedFolder%"

pause
