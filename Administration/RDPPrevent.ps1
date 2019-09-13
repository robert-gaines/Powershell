# Prevent unwanted remote connections #

# Script designed to prevent remote access in an NT environment #

$ErrorActionPreference = "SilentlyContinue"

Write-Host "[*] RDP Killer [*]"

Write-Host ""

Write-Host "    Author: RWG    "

Start-Sleep 1

while(1)
{
    Write-Host "
           ******************
           *** RDP Killer ***
           ******************
           "
    try
    {
        $subjectSocket = Get-NetTCPConnection -LocalPort 3389

        if($subjectSocket)
        {
            $subjectProcess = $subjectSocket.OwningProcess[0]

            Write-Host -ForegroundColor Green "[*] Current RDP process-> " $subjectProcess

            Write-Host -ForegroundColor Orange "[*] Stopping RDP Process [*]"

            Stop-Process -Id $subjectProcess -Force  
        }
        else
        {
            Write-Host -ForegroundColor Yellow "[~] RDP Doesn't appear to be active..." 
        }
    }
    catch
    {
        Write-Host -ForegroundColor Red [!] Error [!]
    }
    finally
    {
        Pass
    }
    Start-Sleep 3 

    Clear-Host
}

