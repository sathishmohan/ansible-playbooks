#!/bin/bash  
# usage : sudo ./pulsar-cluster-launch.sh
# Author - sathishm@cavirin.com


#Function to read from the yaml file

function joval_read_yaml () {
   joval_vm_name=`cat /var/lib/cavirin/conf/clusterdetail.yaml | shyaml get-value JOVAL_NODE.system_specs.0.vm_name`
   joval_vm_cpu=`cat /var/lib/cavirin/conf/clusterdetail.yaml | shyaml get-value JOVAL_NODE.system_specs.1.vm_memory`
   joval_vm_memory=`cat /var/lib/cavirin/conf/clusterdetail.yaml | shyaml get-value JOVAL_NODE.system_specs.2.vm_cpu`
   joval_vm_storage=`cat /var/lib/cavirin/conf/clusterdetail.yaml | shyaml get-value JOVAL_NODE.system_specs.3.vm_storage`
   number_of_vms=`cat /var/lib/cavirin/conf/clusterdetail.yaml | shyaml get-value JOVAL_NODE.system_specs.4.number_of_vms`
   joval_vm_ova_location=`cat /var/lib/cavirin/conf/clusterdetail.yaml | shyaml get-value JOVAL_NODE.system_specs.5.ova_location` 
   joval_vm_datastore=`cat /var/lib/cavirin/conf/clusterdetail.yaml | shyaml get-value JOVAL_NODE.system_specs.6.vm_datastore`
}  


function patch_read_yaml () {
   patch_vm_name=`cat /var/lib/cavirin/conf/clusterdetail.yaml | shyaml get-value PATCHES_NODE.system_specs.0.vm_name`
   patch_vm_cpu=`cat /var/lib/cavirin/conf/clusterdetail.yaml | shyaml get-value PATCHES_NODE.system_specs.1.vm_memory`
   patch_vm_memory=`cat /var/lib/cavirin/conf/clusterdetail.yaml | shyaml get-value PATCHES_NODE.system_specs.2.vm_cpu`
   patch_vm_storage=`cat /var/lib/cavirin/conf/clusterdetail.yaml | shyaml get-value PATCHES_NODE.system_specs.3.vm_storage`
   number_of_vms=`cat /var/lib/cavirin/conf/clusterdetail.yaml | shyaml get-value PATCHES_NODE.system_specs.4.number_of_vms`
   patch_vm_ova_location=`cat /var/lib/cavirin/conf/clusterdetail.yaml | shyaml get-value PATCHES_NODE.system_specs.5.ova_location`
   patch_vm_datastore=`cat /var/lib/cavirin/conf/clusterdetail.yaml | shyaml get-value PATCHES_NODE.system_specs.6.vm_datastore` 
}  


#Function to create vm using powercli

function create_jovalvm () { 
    echo "Creating joval vm"
    x=1
    if [ -f /var/lib/cavirin/conf/multivmdeployment.ps1 ] ; then
      while [ $x -le $number_of_vms ]
      do
         str=$joval_vm_name
         updatestr=$str"-$x"
         if [ -f /var/lib/cavirin/conf/jovalvm_output.log ] ; then
          sudo rm -f /var/lib/cavirin/conf/jovalvm_output.log
         fi
         powershell -executionPolicy bypass -file /var/lib/cavirin/conf/multivmdeployment.ps1 -vm_name $updatestr -ova_location $joval_vm_ova_location -vm_cpu $joval_vm_cpu -vm_memory $joval_vm_memory -vm_storage $joval_vm_storage -vm_datastore $joval_vm_datastore >> /var/lib/cavirin/conf/jovalvm_output.log
         grep "IP of the Virtual Machine :" /var/lib/cavirin/conf/jovalvm_output.log | awk '{print $7}' > /var/lib/cavirin/conf/jovalvm_temp.txt
         while read line ;do
         sed -i '/JOVAL_NODE:/s/.*/&\n\  - '$line'/' /var/lib/cavirin/conf/cluster-nodes-ips.yaml
         done < /var/lib/cavirin/conf/jovalvm_temp.txt
         grep "Virtual Machine Launched with Name " /var/lib/cavirin/conf/jovalvm_output.log
         x=$(( $x + 1 ))
      done
    fi
    echo "End of create joval vm" 
}


function create_patchvm () {
    echo "Creating patch vm"
    x=1
    if [ -f /var/lib/cavirin/conf/multivmdeployment.ps1 ] ; then
      while [ $x -le $number_of_vms ]
      do
         str=$patch_vm_name
         updatestr=$str"-$x"
         if [ -f /var/lib/cavirin/conf/patchvm_output.log ] ; then
           sudo rm -f /var/lib/cavirin/conf/patchvm_output.log
         fi
         powershell -executionPolicy bypass -file /var/lib/cavirin/conf/multivmdeployment.ps1 -vm_name $updatestr -ova_location $patch_vm_ova_location -vm_cpu $patch_vm_cpu -vm_memory $patch_vm_memory -vm_storage $patch_vm_storage -vm_datastore $patch_vm_datastore >> /var/lib/cavirin/conf/patchvm_output.log
         grep "IP of the Virtual Machine :" /var/lib/cavirin/conf/patchvm_output.log | awk '{print $7}' > /var/lib/cavirin/conf/patchvm_temp.txt
         while read line ;do
         sed -i '/PATCHES_NODE:/s/.*/&\n\  - '$line'/' /var/lib/cavirin/conf/cluster-nodes-ips.yaml
         done < /var/lib/cavirin/conf/patchvm_temp.txt
         grep "Virtual Machine Launched with Name " /var/lib/cavirin/conf/patchvm_output.log
         x=$(( $x + 1 ))
      done
    fi
    echo "End of create patch vm" 
}
     
joval_read_yaml
patch_read_yaml
create_jovalvm
create_patchvm

# ------ End of Script ------

