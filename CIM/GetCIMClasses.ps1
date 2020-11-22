<# List all of the Classes to a text file #>

Write-Host -ForegroundColor Yellow "[*] Gathering CIM classes ..."

Get-CIMClass Win32* | Select-Object CIMClassName | Out-File -Append   "CIM_Classes.txt"