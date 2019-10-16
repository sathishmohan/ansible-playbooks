#http://vcdx56.com/2014/02/create-multiple-vms-from-existing-vsphere-vm-using-powercli/
# PowerCLI to create VMs and deploy the ova 
#
# Usage ./multivmdeployment.ps1 -vm_count XX  -vm_cpu XX -vm_memory XX -vm_storage XX -vm_prefix XX -vm_datastore XX
# Ex : ./multivmdeployment.ps1 -vm_count 2  -vm_cpu 2 -vm_memory 20 -vm_storage 150 -vm_prefix pulsar-workflow -vm_datastore Esxi-1_Local2
# Ex : ./multivmdeployment.ps1 -vm_count 2  -vm_cpu 2 -vm_memory 20 -vm_storage 150 -vm_prefix pulsar-joval -vm_datastore Esxi-1_Local2

Param
(
    [Parameter(Mandatory = $true)]
    [int]$vm_count,
    [int]$vm_cpu,
    [int]$vm_memory,
    [int]$vm_storage,
    [String]$vm_prefix,
    [String]$vm_datastore
)

#Specify vCenter Server, vCenter Server username and vCenter Server user password
$vCenter = "10.101.70.9"
$vCenterUser = ""
$vCenterUserPassword = ""
$vmHost = "10.101.70.10"

#$vmCluster = Get-Cluster -Name “CLUSTER_NAME”

#$vmHost = ($vmCluster | Get-VMHost)[0]

#Specify the OVA path
$vmWorkflowSource = ""
$vmJovalSource = ""
$vmPatchesSource = ""
$vmDBSource = ""


#New-VM -Name $VM_Name -VMHost $ESXi -numcpu $vm_cpu -MemoryGB $vm_memory -DiskGB $vm_storage -DiskStorageFormat $Typeguestdisk -Datastore $vm_datastore -GuestId $guestOS -Location $Folder
#$ESXi=Get-Cluster $Cluster | Get-VMHost -state connected | which host

write-host "Connecting to vCenter Server $vCenter" -foreground green

Connect-viserver $vCenter -user $vCenterUser -password $vCenterUserPassword -WarningAction 0
1..$vm_count | foreach {
$y="{0:D2}" -f $_
$VM_name= $vm_prefix + "-" + $y

write-host "Creation of VM $VM_name initiated"  -foreground green

New-VM -Name $VM_name -VMHost $vmHost -NumCpu $vm_cpu -MemoryGB $vm_memory -DiskGB $vm_storage -Datastore $vm_datastore

write-host "Power On of the  VM $VM_name initiated"  -foreground green

Start-VM -VM $VM_name -confirm:$false -RunAsync

Start-Sleep -s 30

if ($vm_prefix -eq "pulsar-workflow")
{
	vmHost | Import-vApp -Source $vmWorkflowSource -Location $vmCluster -Datastore $vmDatastore -Name $VM_name -Force
}
Elseif $vm_prefix -eq "pulsar-joval")
{
	vmHost | Import-vApp -Source $vmJovalSource -Location $vmCluster -Datastore $vmDatastore -Name $VM_name -Force
}
Elseif $vm_prefix -eq "pulsar-patches")
{
	vmHost | Import-vApp -Source $vmPatchesSource -Location $vmCluster -Datastore $vmDatastore -Name $VM_name -Force
}
Elseif $vm_prefix -eq "pulsar-DB")
{
	vmHost | Import-vApp -Source $vmDBSource -Location $vmCluster -Datastore $vmDatastore -Name $VM_name -Force
}
Else
{
	write-host "$vm_prefix does not match keyword, deployment failed"  -foreground red
}

#vmHost | Import-vApp -Source $vmSource -Location $vmCluster -Datastore $vmDatastore -Name $vmName -Force

Write-Host "Get IP of $VM_name"  -foreground green

$VM_nameIp = (Get-VM -Name $VM_name).Guest.IPAddress[0]

Write-Host "IP of the Workflow VM " $VM_nameIp  -foreground green
}