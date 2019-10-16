# PowerCLI to remove VMs 

# Usage ./RemoveVM.ps1 -vm_name XX 
# Ex : ./RemoveVM.ps1 -ip_address 10.10.10.1
# Author : sathishm@cavirin.com

Param
(
    [Parameter(Mandatory = $true)]
    [String]$ip_address
)


Get-Module -ListAvailable PowerCLI* | Import-Module

# ------ vSphere Targeting Variables tracked below ------

$vCenterInstance = "10.101.70.9"
$vCenterUser = "shriram@enggvcsa.cavirin.local"
$vCenterPass = "NOVAnova55!@"
$vDataStore = "Esxi-1_Local2"
$vmHost = "10.101.70.10"
$username ="cavirin"
$password ="NOVAnova"


# ----- Script starts from here -----


Write-Host "Connecting to the vcenter" -foreground green

Connect-VIServer $vCenterInstance -User $vCenterUser -Password $vCenterPass -WarningAction SilentlyContinue 

$vm_name = (get-vm | where { $_.Guest.IPAddress -eq "$ip_address" }).Name

Write-Host "Name of the Virtual Machine for $ip_address is $vm_name" -foreground green

Write-Host "Stopping the Virtual Machine $vm_name" -foreground green

$powerstate = (get-vm $vm_name).powerstate

if ($powerstate -eq "PoweredOn")
{
	Stop-VM -VM $vm_name -Confirm:$false
}

sleep 5

Write-Host "Removing the Virtual Machine $vm_name" -foreground green

Remove-VM -VM $vm_name -DeletePermanently -Confirm:$false

Write-Host "Removed the Virtual Machine $vm_name" -foreground green


# ------- End of Script ---------
