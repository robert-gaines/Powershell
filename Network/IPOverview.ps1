# The purpose of this script is to collect standard IP data #

$ipAddr = Get-NetIPAddress

Write-Host -ForegroundColor Black "[*] All current IP Addresses: "
Write-Host -ForegroundColor Black "----------------------------- "

foreach ($i in $ipAddr)
{
    Write-Host -ForegroundColor Green $i  
}

Write-Host " "

