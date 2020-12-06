Set-VMMemory -StartupBytes 8096MB -VMName HL-WSUS

Start-VM -VMName HL-WSUS

$credential = Get-Credential

Start-Sleep -Seconds 60

Invoke-Command -Credential $credential -VMName HL-WSUS -ScriptBlock {
                                                                        Install-WindowsFeature -Name UpdateServices-Services -IncludeManagementTools -Confirm:$false
                                                                    }

Stop-VM -VMName HL-WSUS

Set-VMMemory -StartupBytes 1024MB -VMName HL-WSUS