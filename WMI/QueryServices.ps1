<# Query System Services #>

Write-Host -ForegroundColor Yellow "[*] Query System Services "

Get-WMIObject -Class Win32_Service | Format-Table | Out-File -Append "SystemServices.txt"