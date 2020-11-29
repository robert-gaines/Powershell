function main()
{
    $check_config_file = Test-Path -Path ./workstations.csv

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

    Write-Host -ForegroundColor Yellow "[+] Enter the domain administrator's credentials-> "

    $domain_creds = Get-Credential

    $workstations = Import-CSV -Path .\workstations.csv
    <#
    $workstations | Foreach-Object {
                                        $vm      = $_.host 

                                        Write-Host -ForegroundColor Yellow "[*] Renaming: $vm "
                                        
                                        Set-VMMemory -VMName $vm -StartupBytes 8096MB

                                        Start-VM -VMName $vm 

                                        Start-Sleep -Seconds 60

                                        Invoke-Command -Credential $credential -VMName $vm -ArgumentList @($vm) -ScriptBlock {
                                                                                                                                 Rename-Computer -NewName $args[0]
                                                                                                                             }
                                                                                                                                                                
                                        Stop-VM -VMName $vm ; Start-Sleep -Seconds 60
                                        
                                        Set-VMMemory -VMName $vm -StartupBytes 1024MB                              
                                   } #>

    $workstations | Foreach-Object {
                                        $vm      = $_.host 

                                        Write-Host -ForegroundColor Yellow "[*] Domain Joining: $vm "
                                        
                                        Set-VMMemory -VMName $vm -StartupBytes 8096MB

                                        Start-VM -VMName $vm 

                                        Start-Sleep -Seconds 60

                                        Invoke-Command -Credential $credential -VMName $vm -ArgumentList @($domain_creds) -ScriptBlock {
                                                                                                                                            Add-Computer -DomainName homelab.winlab.local -Credential $args[0]
                                                                                                                                       }
                                                                                                                                                                
                                        Stop-VM -VMName $vm ; Start-Sleep -Seconds 60
                                        
                                        Set-VMMemory -VMName $vm -StartupBytes 1024MB                              
                                   }
}

main