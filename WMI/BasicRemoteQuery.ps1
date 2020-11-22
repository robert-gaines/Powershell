Write-Host -ForegroundColor Yellow "[*] Query a remote system for OS properties..."

$remote_host = Read-Host "[+] Enter the remote machine name "

Get-WMIObject -Class Win32_OperatingSystem -ComputerName $remote_host | Select-Object PSComputerName,Caption,OSArchitecture,ServicePackMajorVersion,InstallDate 