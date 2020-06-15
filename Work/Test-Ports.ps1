
$ErrorActionPreference ="SilentlyContinue"

function TestPort($addr,$port)
{
    $result = Test-NetConnection -ComputerName $addr -Port $port -Verbose:$false -InformationLevel Quiet

    if($result)
    {
        Write-Host -ForegroundColor Green "[*] Open port-> $addr | $port "

        return $true
    }
    else
    {
        return $false
    }
}

function main()
{
    $machine = Read-Host "[+] Enter the target machine's IPV4-> "

    workflow PortScan {
                        param(
                                [Parameter (Mandatory = $true)]
                                [string]$machine
                             )
                        foreach -Parallel -ThrottleLimit 3 ($i in 1..1024) { 
                                                                                $response = TestPort $machine $i
                                                                           }
                      }

    PortScan -Machine $machine
}
main