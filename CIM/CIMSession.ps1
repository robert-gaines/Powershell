<# CIM Session #>

Write-Host -ForegroundColor Yellow "[*] Create a CIM Session "

$remote_host = Read-Host "[+] Identify the remote machine name "

$credential = Get-Credential 

try 
{
    Write-Host -ForegroundColor Green "[*] Creating a CIM session "

    New-CIMSession -ComputerName $remote_host -Credential $credential
}
catch 
{
    Write-Host -ForegroundColor Red "[!] Failed to establish a CIM session on $remote_host"
}

Write-Host -ForegroundColor Green "[*] Listing CIM Sessions "

Get-CIMSession