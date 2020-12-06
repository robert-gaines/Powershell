Set-VMMemory -StartupBytes 8096MB -VMName HL-DC-ALT

Start-VM -VMName HL-DC-ALT

$credential = Get-Credential

Start-Sleep -Seconds 60

Invoke-Command -Credential $credential -VMName HL-DC-ALT -ArgumentList @($credential) -ScriptBlock {
                                                                                                        Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools -Confirm:$false

                                                                                                        Install-ADDSDomainController -DomainName homelab.winlab.local -InstallDNS:$true -Credential $args[0]
                                                                                                   }

Stop-VM -VMName HL-DC-ALT

Set-VMMemory -StartupBytes 1024MB -VMName HL-DC-ALT