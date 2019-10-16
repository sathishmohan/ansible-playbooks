# PowerCLI to create VMs and deploy the ova 
#
# Usage ./multivmdeployment.ps1 -vm_name xxx -ova_location xxxxx -vm_cpu xx -vm_memory xx -vm_storage xx -vm_datastore xxxxx
# Example : ./multivmdeployment.ps1 -vm_name pulsar-workflow -ova_location pulsar-workflow.ova -vm_cpu 2 -vm_memory 2 -vm_storage 20 -vm_datastore Esxi-1_Local2
# Author - sathishm@cavirin.com
#
Param
(
    [Parameter(Mandatory = $true)]
    [String]$vm_name,
    [String]$ova_location,
    [int]$vm_cpu,
    [int]$vm_memory,
    [int]$vm_storage,
    [String]$vm_datastore
)

Get-Module -ListAvailable PowerCLI* | Import-Module | Out-Null

# ------ vSphere Targeting Variables ------

$vCenterInstance = "10.101.70.9"
$vCenterUser = "shriram@enggvcsa.cavirin.local"
$vCenterPass = "NOVAnova55!@"
$vmHost = "10.101.70.10"
$username ="cavirin"
$password ="NOVAnova"


# ----- Script starts from here -----


Write-Host "Connecting to the vcenter" -foreground green

Connect-VIServer $vCenterInstance -User $vCenterUser -Password $vCenterPass -WarningAction SilentlyContinue 

Write-Host "Creating New Virtual Machine $vm_name from the OVA" -foreground green

New-VM -Name $vm_name -VM $ova_location -VMHost $vmHost -Datastore $vm_datastore

Write-Host "Starting the Virtual Machine $vm_name" -foreground green

Start-VM -VM $vm_name 
 
Start-Sleep -s 30

Write-Host "Get IP of the Virtual Machine $vm_name" -foreground green

$VirtualMachineIp = (Get-VM -Name $vm_name).Guest.IPAddress[0]

Write-Host "IP of the Virtual Machine : " $VirtualMachineIp

Write-Host "Virtual Machine Launched with Name $vm_name and IP $VirtualMachineIp"

# ------- End of Script ---------


#------- Resizing --------

Write-Host "Stopping and Resizing the Virtual Machine $vm_name" -foreground green

Stop-VM -VM $vm_name -Confirm:$False

sleep 5

Write-Host "Updating Memory and NumCpu of Virtual Machine $vm_name" -foreground green

Set-VM $vm_name -MemoryGB $vm_memory -NumCPU $vm_cpu -Confirm:$False

Write-Host "Updating the Harddisk of Virtual Machine $vm_name" -foreground green

Get-HardDisk -VM $vm_name | Set-HardDisk -CapacityGB $vm_storage -Confirm:$false

Write-Host "Starting the Virtual Machine $vm_name" -foreground green

Start-VM -VM $vm_name

# ------- End of Script ---------