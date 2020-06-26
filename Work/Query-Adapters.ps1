
function GatherAdapterData()
{
    $interfaces = @((Get-WMIObject Win32_NetworkAdapterConfiguration | Where-Object { $_.IPAddress }).Description)
    $addresses = @((Get-WMIObject Win32_NetworkAdapterConfiguration | Where-Object { $_.IPAddress }).IPAddress)
    $subnet_masks = @((Get-WMIObject Win32_NetworkAdapterConfiguration | Where-Object { $_.IPAddress }).IPSubnet)

    for($i = 0; $i -lt $interfaces.Length ; $i++)
    {
        $interface = $interfaces[$i] 
        $address   = $addresses[$i]
        $mask      = $subnet_masks[$i]
        Write-Host $interface $address $mask
    }
}

function main()
{
    GatherAdapterData
}

main