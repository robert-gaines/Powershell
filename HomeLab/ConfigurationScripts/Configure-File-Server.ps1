Set-VMMemory -StartupBytes 8096MB -VMName HL-FS

Start-VM -VMName HL-FS

$credential = Get-Credential

Start-Sleep -Seconds 60

Invoke-Command -Credential $credential -VMName HL-FS -ScriptBlock {
                                                                        Install-WindowsFeature -Name FileAndStorage-Services -IncludeManagementTools -Confirm:$false
                                                                   }

Stop-VM -VMName HL-FS

Set-VMMemory -StartupBytes 1024MB -VMName HL-FS
