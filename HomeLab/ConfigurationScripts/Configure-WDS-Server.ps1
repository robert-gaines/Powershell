Set-VMMemory -StartupBytes 8096MB -VMName HL-WDS

Start-VM -VMName HL-WDS

$credential = Get-Credential

Start-Sleep -Seconds 60

Invoke-Command -Credential $credential -VMName HL-WDS -ScriptBlock {
                                                                        Install-WindowsFeature -Name WDS -IncludeAllSubFeature -IncludeManagementTools -Confirm:$false
                                                                   }

Stop-VM -VMName HL-WDS

Set-VMMemory -StartupBytes 1024MB -VMName HL-WDS