#Enter-PSSession -ComputerName HL-HV -Credential HOMELAB\Administrator

# Invoke-Command -VMName HV-CORE-1 -Credential HOMELAB\Administrator -ScriptBlock { Start-Service msiscsi ; Set-Service -StartupType Automatic}

Invoke-Command -VMName HV-CORE-1,HV-CORE-2,HV-CORE-3,HV-CORE-4 -Credential HOMELAB\Administrator -ScriptBlock { Get-Service msiscsi }

