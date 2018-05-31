# PowerCLI to remove VMs 

# Usage ./vmremove.ps1 -ip_address XX 
# Ex : ./vmremove.ps1 -ip_address 10.10.10.10
# Author : sathishm

Param
(
    [Parameter(Mandatory = $true)]
    [String]$ip_address
)


Get-Module -ListAvailable PowerCLI* | Import-Module

# ------ vSphere Targeting Variables tracked below ------

$vCenterInstance = "IP"
$vCenterUser = "username"
$vCenterPass = "password"
$vDataStore = "Esxi-1_Local2"
$vmHost = "IP"
$username ="username"
$password ="password"


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
