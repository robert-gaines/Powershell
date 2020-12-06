Set-VMMemory -StartupBytes 8096MB -VMName HL-DHCP

Start-VM -VMName HL-DHCP

$credential = Get-Credential

Start-Sleep -Seconds 60

Invoke-Command -Credential $credential -VMName HL-DHCP -ScriptBlock {
                                                                        Install-WindowsFeature -Name DHCP -IncludeManagementTools -IncludeAllSubFeature -Confirm:$false
                                                                    }

Stop-VM -VMName HL-DHCP

Set-VMMemory -StartupBytes 1024MB -VMName HL-DHCP
