
New-AZVM `
    -ResourceGroupName "PS-WIN-VM" `
    -Name "PS-WIN-TEST-VM" `
    -Location "westus" `
    -SubnetName "PS-Test-Subnet" `
    -Image "Win2016Datacenter" `
    -OpenPorts 3389 `
    -PublicIpAddressName "PS-Test-IP-Addr" 
