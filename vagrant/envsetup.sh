#!/bin/bash
#THIS SCRIPT IS TO INSTALL VIRTUALBOX AND VAGRANT

echo "-- BEGIN OF VIRTUALBOX AND VAGRANT SETUP --"

#ADDING TO SOURCE LIST AND REGISTERING KEYS

sudo sh -c "echo 'deb http://download.virtualbox.org/virtualbox/debian '$(lsb_release -cs)' contrib non-free' > /etc/apt/sources.list.d/virtualbox.list" 

wget -q http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc -O- | sudo apt-key add -

#UPDATING PACKAGE AND INSTALLING VIRTUALBOX

sudo apt-get install dkms -y

sudo apt-get update -y -qq

echo "Installing VirtualBox"

sudo apt-get install virtualbox-5.1 -y

echo "Installing Vagrant"

wget https://releases.hashicorp.com/vagrant/2.1.1/vagrant_2.1.1_x86_64.deb

sudo dpkg -i vagrant_2.1.1_x86_64.deb

echo "-- END OF VIRTUALBOX AND VAGRANT SETUP --"
