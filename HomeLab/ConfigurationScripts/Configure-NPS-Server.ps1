Set-VMMemory -StartupBytes 8096MB -VMName HL-NPS

Start-VM -VMName HL-NPS

$credential = Get-Credential

Start-Sleep -Seconds 60

Invoke-Command -Credential $credential -VMName HL-NPS -ScriptBlock {
                                                                        Install-WindowsFeature -Name NPAS -IncludeManagementTools -Confirm:$false
                                                                   }

Stop-VM -VMName HL-NPS

Set-VMMemory -StartupBytes 1024MB -VMName HL-NPS