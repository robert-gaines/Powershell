# Host Discovery #

function ParseMask($snm)
{
    $index = 0

  
        $segments = $snm.Split(".")

        Foreach($s in $segments)
        {
            if($s -ne "255")
            {
                $octet = [int]::Parse($s)
                $octetDifference = (256-$octet)
                $logValue = [Math]::Log($octetDifference,2)
                $totalBase += $logValue
            }
            else {
                $index += 1
            }
        }

        $interestingOctet = $segments[$index]

        $blockSize = 256-$interestingOctet ; $index += 1

        $totalHosts = [Math]::Pow(2,$totalBase)
        
        Write-Host -ForegroundColor Green "[*] Total potential hosts: `t`t", $totalHosts

        return $totalHosts,$blockSize,$index
}
function main()
{
    # Identify Default Gateway #
    try {
        $defaultGateway = Get-NetRoute -DestinationPrefix "0.0.0.0/0" | Select-Object -ExpandProperty "NextHop"

        if($defaultGateway.length -gt 1)
        {
            $defaultGateway = $defaultGateway[1]
        }

        Write-Host -ForegroundColor Green "[*] Default Gateway Identified as: `t", $defaultGateway
    }
    catch {
        Write-Host -ForegroundColor Red "[!] Failed to identify the default gateway [!]"

        exit
    }
    try {
        $subnetMaskRaw = Get-WMIObject -Computer localhost -Class "win32_networkadapterconfiguration" | Where-Object {$_.defaultIPGateway -ne $null}

        $subnetMask = $subnetMaskRaw.IPSubnet[0]

        Write-Host -ForegroundColor Green "[*] Subnet Mask Identified as: `t`t", $subnetMask
    }
    catch {
        Write-Host -ForegroundColor Red "[!] Failed to identify the Subnet Mask [!]"

        exit
    }
    $networkData = ParseMask($subnetMask)

    $blockSize = $networkData[1]*-1 ; $octetIndex = $networkData[2] - 1

    $gatewaySegments = $defaultGateway.Split('.'); $iterOctet = $gatewaySegments[$octetIndex]

    $upperLimit = [int]::Parse($iterOctet) + ($blockSize*-1) ; $iterSegments = $gatewaySegments.length - $octetIndex - 1

    $baseAddr = ""

    for($i = 0; $i -lt $octetIndex; $i++)
    {
       $baseAddr += $gatewaySegments[$i]
       $baseAddr += '.'
    }

    for($i = [int]::Parse($iterOctet); $i -lt $upperLimit-1; $i++)
    {
        $iterOctet = [int]::Parse($iterOctet)

        $addr = [System.String]::Concat($baseAddr,$iterOctet) ; $addr += '.'

        for($j = 0; $j -lt 256; $j++)
        {
            $fullAddr = [System.String]::Concat($addr,$j)

            $res = Test-Connection -ComputerName $fullAddr -Count 1 -Quiet
            
            if($res)
            {
                Write-Host -ForegroundColor Green "[*] Host alive at-> `t`t",$fullAddr
            }
            else
            {
                Write-Host -ForegroundColor Red "[!] Host unresponsive at-> `t"$fullAddr
            }
        }
        $iterOctet++
    }
}

main

