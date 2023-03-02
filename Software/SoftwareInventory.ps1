$computerName = $env:COMPUTERNAME
$fileName     = $computerName+"_software.html"
Get-WmiObject -Class Win32_Product | Select-Object -Property Name, Version, Vendor | ConvertTo-Html | Out-File $fileName