Set-VMMemory -StartupBytes 8096MB -VMName HL-DNS

Start-VM -VMName HL-DNS

$credential = Get-Credential

Start-Sleep -Seconds 60

Invoke-Command -Credential $credential -VMName HL-DNS -ScriptBlock {
                                                                        Install-WindowsFeature -Name DNS -IncludeAllSubFeature -IncludeManagementTools -Confirm:$false
                                                                   }

Stop-VM -VMName HL-DNS

Set-VMMemory -StartupBytes 1024MB -VMName HL-DNS