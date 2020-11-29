
function main()
{
    $check_config_file = Test-Path -Path ./servers.csv

    if($check_config_file)
    {
        Write-Host -ForegroundColor Green "[*] Located workstation configuration file "
    }
    else
    {
        Write-Host -ForegroundColor Red "[!] Failed to located configuration file "

        return
    }

    Write-Host -ForegroundColor Yellow "[+] Enter the local administrator password-> "

    $credential = Get-Credential 

    $servers = Import-CSV -Path ./servers.csv

    <#

    $servers | Foreach-Object {
                                        $vm      = $_.host 
                                        $ip      = $_.IP 
                                        $prefix  = $_.Prefix
                                        $gateway = $_.Gateway 
                                        $dns_one = $_.DNS1
                                        $dns_two = $_.DNS2

                                        Write-Host -ForegroundColor Yellow "[*] Starting: $vm -> $ip,$prefix,$gateway,$dns_one,$dns_two "
                                        
                                        #Start-VM -VMName $vm                                      
                              }

   Write-Host -ForegroundColor Yellow "[*] Waiting for the VMs to power on... "
   #>

   $servers | Foreach-Object {
                                        $vm      = $_.Server 
                                        $ip      = $_.IP 
                                        $prefix  = $_.Prefix
                                        $gateway = $_.Gateway 
                                        $dns_one = $_.DNS1
                                        $dns_two = $_.DNS2

                                        Write-Host -ForegroundColor Yellow "[*] Configuring: $vm "
                                        
                                        Set-VMMemory -VMName $vm -StartupBytes 8096MB

                                        Start-VM -VMName $vm 

                                        Start-Sleep -Seconds 120

                                        Invoke-Command -Credential $credential -VMName $vm -ArgumentList @($ip,$prefix,$gateway,$dns_one,$dns_two) -ScriptBlock {
                                                                                                                                                                   Remove-NetIPAddress -InterfaceAlias Ethernet -Confirm:$false 
                                            
                                                                                                                                                                   Remove-NetRoute * -Confirm:$false -ErrorAction SilentlyContinue
                                                                                                                                                                
                                                                                                                                                                   New-NetIPAddress -InterfaceAlias 'Ethernet' -IPAddress $args[0] -PrefixLength $args[1] -DefaultGateway $args[2]
                                                                                                                                                                   
                                                                                                                                                                   Set-DnsClientServerAddress -InterfaceAlias 'Ethernet' -ServerAddresses ($args[3],$args[4]) 
                                                                                                                                                                }
                                                                                                                                                                
                                        Stop-VM -VMName $vm ; Start-Sleep -Seconds 120
                                        
                                        Set-VMMemory -VMName $vm -StartupBytes 1024MB                              
                                   }
                                   
}

main