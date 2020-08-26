Connect-AZAccount -Credential (Get-Credential)

$resource_group_name = Read-Host "[+] Resource Group Name "

$location = Read-Host "[+] Enter the location "

New-AZResourceGroup -Name $resource_group_name -Location $location 
