Set-VMMemory -StartupBytes 8096MB -VMName HL-WEB

Start-VM -VMName HL-WEB

$credential = Get-Credential

Start-Sleep -Seconds 60

Invoke-Command -Credential $credential -VMName HL-WEB -ScriptBlock {
                                                                        Install-WindowsFeature -Name Web-Server -IncludeManagementTools -Confirm:$false
                                                                   }

Stop-VM -VMName HL-WEB

Set-VMMemory -StartupBytes 1024MB -VMName HL-WEB
