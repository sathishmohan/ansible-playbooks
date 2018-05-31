#!/bin/bash
# Script to install powershell v6.0.0-alpha.18 in ubuntu 14.04.1

echo "Installing powershell"

sudo apt-get update

sudo apt-get install libunwind8 libicu52 -y

wget https://github.com/PowerShell/PowerShell/releases/download/v6.0.0-alpha.18/powershell_6.0.0-alpha.18-1ubuntu1.14.04.1_amd64.deb

sudo dpkg -i powershell_6.0.0-alpha.18-1ubuntu1.14.04.1_amd64.deb

echo "Powershell Installation Completed"

echo "Installing PowerCLI"

sudo mkdir -p ~/.local/share/powershell

cd ~/.local/share/powershell

wget https://download3.vmware.com/software/vmw-tools/powerclicore/PowerCLI_Core.zip

sudo apt-get -y install unzip

sudo unzip ~/.local/share/powershell/PowerCLI_Core.zip

sudo unzip PowerCLI.ViCore.zip -d ~/.local/share/powershell/Modules

sudo unzip PowerCLI.Vds.zip -d ~/.local/share/powershell/Modules

echo "PowerCLI Installation Completed"

echo "Installing Python-pip and Shyaml"

sudo apt-get install python-pip -y

sudo pip install shyaml

echo " Shyaml Installtion Completed"

echo " Installing sshpass"

sudo apt-get install sshpass -y

echo "Pre-requiste Installation done"
#---------- End ---------------

