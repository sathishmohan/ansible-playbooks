#!/bin/bash  
# usage : sudo ./pulsar-cluster-launch.sh
# Author - sathishm@cavirin.com


#Create the required output file


if [ -f /var/lib/cavirin/conf/cluster-nodes-ips.yaml ]; then
	echo "cluster-nodes-ips.yaml is present already"
else	
    echo "Creating cluster-nodes-ips.yaml file"
    sudo touch /var/lib/cavirin/conf/cluster-nodes-ips.yaml
    sudo chmod -R 777 /var/lib/cavirin/conf/cluster-nodes-ips.yaml
    echo -e "---\n\nJOVAL_NODE:\n\n\nPATCHES_NODE:\n\n\nWORKFLOW_NODE:\n\n\nCONTROL_PLANE_NODE:\n\n\nDB_NODE:\n\n\n" >>/var/lib/cavirin/conf/cluster-nodes-ips.yaml
    echo "Creation of cluster-nodes-ips.yaml file completed"
fi    


#Function to read from the yaml file

function joval_read_yaml () {
   joval_vm_name=`cat /var/lib/cavirin/conf/clusterdetail.yaml | shyaml get-value JOVAL_NODE.system_specs.0.vm_name`
   joval_vm_cpu=`cat /var/lib/cavirin/conf/clusterdetail.yaml | shyaml get-value JOVAL_NODE.system_specs.1.vm_memory`
   joval_vm_memory=`cat /var/lib/cavirin/conf/clusterdetail.yaml | shyaml get-value JOVAL_NODE.system_specs.2.vm_cpu`
   joval_vm_storage=`cat /var/lib/cavirin/conf/clusterdetail.yaml | shyaml get-value JOVAL_NODE.system_specs.3.vm_storage`
   joval_number_of_vms=`cat /var/lib/cavirin/conf/clusterdetail.yaml | shyaml get-value JOVAL_NODE.system_specs.4.number_of_vms`
   joval_vm_ova_location=`cat /var/lib/cavirin/conf/clusterdetail.yaml | shyaml get-value JOVAL_NODE.system_specs.5.ova_location` 
   joval_vm_datastore=`cat /var/lib/cavirin/conf/clusterdetail.yaml | shyaml get-value JOVAL_NODE.system_specs.6.vm_datastore`
}  


function patch_read_yaml () {
   patch_vm_name=`cat /var/lib/cavirin/conf/clusterdetail.yaml | shyaml get-value PATCHES_NODE.system_specs.0.vm_name`
   patch_vm_cpu=`cat /var/lib/cavirin/conf/clusterdetail.yaml | shyaml get-value PATCHES_NODE.system_specs.1.vm_memory`
   patch_vm_memory=`cat /var/lib/cavirin/conf/clusterdetail.yaml | shyaml get-value PATCHES_NODE.system_specs.2.vm_cpu`
   patch_vm_storage=`cat /var/lib/cavirin/conf/clusterdetail.yaml | shyaml get-value PATCHES_NODE.system_specs.3.vm_storage`
   patch_number_of_vms=`cat /var/lib/cavirin/conf/clusterdetail.yaml | shyaml get-value PATCHES_NODE.system_specs.4.number_of_vms`
   patch_vm_ova_location=`cat /var/lib/cavirin/conf/clusterdetail.yaml | shyaml get-value PATCHES_NODE.system_specs.5.ova_location`
   patch_vm_datastore=`cat /var/lib/cavirin/conf/clusterdetail.yaml | shyaml get-value PATCHES_NODE.system_specs.6.vm_datastore` 
}  


function workflow_read_yaml () {
   workflow_vm_name=`cat /var/lib/cavirin/conf/clusterdetail.yaml | shyaml get-value WORKFLOW_NODE.system_specs.0.vm_name`
   workflow_vm_cpu=`cat /var/lib/cavirin/conf/clusterdetail.yaml | shyaml get-value WORKFLOW_NODE.system_specs.1.vm_memory`
   workflow_vm_memory=`cat /var/lib/cavirin/conf/clusterdetail.yaml | shyaml get-value WORKFLOW_NODE.system_specs.2.vm_cpu`
   workflow_vm_storage=`cat /var/lib/cavirin/conf/clusterdetail.yaml | shyaml get-value WORKFLOW_NODE.system_specs.3.vm_storage`
   workflow_number_of_vms=`cat /var/lib/cavirin/conf/clusterdetail.yaml | shyaml get-value WORKFLOW_NODE.system_specs.4.number_of_vms`
   workflow_vm_ova_location=`cat /var/lib/cavirin/conf/clusterdetail.yaml | shyaml get-value WORKFLOW_NODE.system_specs.5.ova_location` 
   workflow_vm_datastore=`cat /var/lib/cavirin/conf/clusterdetail.yaml | shyaml get-value WORKFLOW_NODE.system_specs.6.vm_datastore`
}  


function cp_read_yaml () {
   cp_vm_name=`cat /var/lib/cavirin/conf/clusterdetail.yaml | shyaml get-value CONTROL_PLANE_NODE.system_specs.0.vm_name`
   cp_vm_cpu=`cat /var/lib/cavirin/conf/clusterdetail.yaml | shyaml get-value CONTROL_PLANE_NODE.system_specs.1.vm_memory`
   cp_vm_memory=`cat /var/lib/cavirin/conf/clusterdetail.yaml | shyaml get-value CONTROL_PLANE_NODE.system_specs.2.vm_cpu`
   cp_vm_storage=`cat /var/lib/cavirin/conf/clusterdetail.yaml | shyaml get-value CONTROL_PLANE_NODE.system_specs.3.vm_storage`
   cp_number_of_vms=`cat /var/lib/cavirin/conf/clusterdetail.yaml | shyaml get-value CONTROL_PLANE_NODE.system_specs.4.number_of_vms`
   cp_vm_ova_location=`cat /var/lib/cavirin/conf/clusterdetail.yaml | shyaml get-value CONTROL_PLANE_NODE.system_specs.5.ova_location` 
   cp_vm_datastore=`cat /var/lib/cavirin/conf/clusterdetail.yaml | shyaml get-value CONTROL_PLANE_NODE.system_specs.6.vm_datastore`
}  


function db_read_yaml () {
   db_vm_name=`cat /var/lib/cavirin/conf/clusterdetail.yaml | shyaml get-value DB_NODE.system_specs.0.vm_name`
   db_vm_cpu=`cat /var/lib/cavirin/conf/clusterdetail.yaml | shyaml get-value DB_NODE.system_specs.1.vm_memory`
   db_vm_memory=`cat /var/lib/cavirin/conf/clusterdetail.yaml | shyaml get-value DB_NODE.system_specs.2.vm_cpu`
   db_vm_storage=`cat /var/lib/cavirin/conf/clusterdetail.yaml | shyaml get-value DB_NODE.system_specs.3.vm_storage`
   db_number_of_vms=`cat /var/lib/cavirin/conf/clusterdetail.yaml | shyaml get-value DB_NODE.system_specs.4.number_of_vms`
   db_vm_ova_location=`cat /var/lib/cavirin/conf/clusterdetail.yaml | shyaml get-value DB_NODE.system_specs.5.ova_location` 
   db_vm_datastore=`cat /var/lib/cavirin/conf/clusterdetail.yaml | shyaml get-value DB_NODE.system_specs.6.vm_datastore`
}  

#Function to create vm using powercli

function create_jovalvm () { 
    echo "Creating joval vm"
    x=1
    if [ -f /var/lib/cavirin/conf/multivmdeployment.ps1 ] ; then
      while [ $x -le $joval_number_of_vms ]
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
      while [ $x -le $patch_number_of_vms ]
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


function create_workflowvm () {
    echo "Creating workflow vm"
    x=1
    if [ -f /var/lib/cavirin/conf/multivmdeployment.ps1 ] ; then
      while [ $x -le $workflow_number_of_vms ]
      do
         str=$workflow_vm_name
         updatestr=$str"-$x"
         if [ -f /var/lib/cavirin/conf/workflowvm_output.log ] ; then
           sudo rm -f /var/lib/cavirin/conf/workflowvm_output.log
         fi
         powershell -executionPolicy bypass -file /var/lib/cavirin/conf/multivmdeployment.ps1 -vm_name $updatestr -ova_location $workflow_vm_ova_location -vm_cpu $workflow_vm_cpu -vm_memory $workflow_vm_memory -vm_storage $workflow_vm_storage -vm_datastore $workflow_vm_datastore >> /var/lib/cavirin/conf/workflowvm_output.log
         grep "IP of the Virtual Machine :" /var/lib/cavirin/conf/workflowvm_output.log | awk '{print $7}' > /var/lib/cavirin/conf/workflowvm_temp.txt
         while read line ;do
         sed -i '/WORKFLOW_NODE:/s/.*/&\n\  - '$line'/' /var/lib/cavirin/conf/cluster-nodes-ips.yaml
         done < /var/lib/cavirin/conf/workflowvm_temp.txt
         grep "Virtual Machine Launched with Name " /var/lib/cavirin/conf/workflowvm_output.log
         x=$(( $x + 1 ))
      done
    fi
    echo "End of create workflow vm" 
}
 

function create_cpvm () {
    echo "Creating control plane vm"
    x=1
    if [ -f /var/lib/cavirin/conf/multivmdeployment.ps1 ] ; then
      while [ $x -le $cp_number_of_vms ]
      do
         str=$cp_vm_name
         updatestr=$str"-$x"
         if [ -f /var/lib/cavirin/conf/cpvm_output.log ] ; then
           sudo rm -f /var/lib/cavirin/conf/cpvm_output.log
         fi
         powershell -executionPolicy bypass -file /var/lib/cavirin/conf/multivmdeployment.ps1 -vm_name $updatestr -ova_location $cp_vm_ova_location -vm_cpu $cp_vm_cpu -vm_memory $cp_vm_memory -vm_storage $cp_vm_storage -vm_datastore $cp_vm_datastore >> /var/lib/cavirin/conf/cpvm_output.log
         grep "IP of the Virtual Machine :" /var/lib/cavirin/conf/cpvm_output.log | awk '{print $7}' > /var/lib/cavirin/conf/cpvm_temp.txt
         while read line ;do
         sed -i '/CONTROL_PLANE_NODE:/s/.*/&\n\  - '$line'/' /var/lib/cavirin/conf/cluster-nodes-ips.yaml
         done < /var/lib/cavirin/conf/cpvm_temp.txt
         grep "Virtual Machine Launched with Name " /var/lib/cavirin/conf/cpvm_output.log
         x=$(( $x + 1 ))
      done
    fi
    echo "End of create control plane vm" 
}

function create_dbvm () {
    echo "Creating DB vm"
    x=1
    if [ -f /var/lib/cavirin/conf/multivmdeployment.ps1 ] ; then
      while [ $x -le $db_number_of_vms ]
      do
         str=$db_vm_name
         updatestr=$str"-$x"
         if [ -f /var/lib/cavirin/conf/dbvm_output.log ] ; then
           sudo rm -f /var/lib/cavirin/conf/dbvm_output.log
         fi
         powershell -executionPolicy bypass -file /var/lib/cavirin/conf/multivmdeployment.ps1 -vm_name $updatestr -ova_location $db_vm_ova_location -vm_cpu $db_vm_cpu -vm_memory $db_vm_memory -vm_storage $db_vm_storage -vm_datastore $db_vm_datastore >> /var/lib/cavirin/conf/dbvm_output.log
         grep "IP of the Virtual Machine :" /var/lib/cavirin/conf/dbvm_output.log | awk '{print $7}' > /var/lib/cavirin/conf/dbvm_temp.txt
         while read line ;do
         sed -i '/DB_NODE:/s/.*/&\n\  - '$line'/' /var/lib/cavirin/conf/cluster-nodes-ips.yaml
         done < /var/lib/cavirin/conf/dbvm_temp.txt
         grep "Virtual Machine Launched with Name " /var/lib/cavirin/conf/dbvm_output.log
         x=$(( $x + 1 ))
      done
    fi
    echo "End of create DB vm" 
}

joval_read_yaml
patch_read_yaml
workflow_read_yaml
cp_read_yaml
db_read_yaml
create_jovalvm
create_patchvm
create_workflowvm
create_cpvm
create_dbvm

# ------ End of Script ------




