<# Author:  RWG -> 11/22/2019
   Purpose: Modify registry hive key that governs
            the Sent folder in the Outlook
            desktop application
   Outcome: Shared account sent folder displays
            all sent messages
#> 

$ErrorActionPreference = "SilentlyContinue"

try {
    Write-Host -ForegroundColor Yellow "[*] Attempting execution policy modification..."

    Set-ExecutionPolicy Bypass

    Write-Host -ForegroundColor Green "[*] Execution policy successfully set to bypass [*]"
}
catch {
    Write-Host -ForegroundColor Red "[!] Failed to modify execution policy [!]"
}

function RestartOutlook()
{
    Write-Host -ForegroundColor Yellow "[*] Restarting Outlook ..."

    Start-Sleep -Seconds 1

    $tgtProcess = Get-Process -ProcessName "Outlook"

    Stop-Process $tgtProcess

    Start-Process "Outlook"
}
function main()
{
    Write-Host -ForegroundColor Yellow "[*] Outlook Sent Items Modification Script [*]"

    Start-Sleep -Seconds 1

    Write-Host -ForegroundColor Yellow "[*] Checking for the presence of O365 Hive Entry and Keys..."

    Start-Sleep -Seconds 1

    $key = Test-Path -Path Microsoft.PowerShell.Core\Registry::HKCU\Software\Microsoft\Office\16.0\Outlook\Preferences\

    if($key)
    {
        Write-Host -ForegroundColor Green "[*] Located Target Subordinate Hive [*]"
    }
    else {
        Write-Host -ForegroundColor -Red "[!] Failed to find entry [!]"

        Write-Host -ForegroundColor -Red "[!] Office 365 may be required [!]"

        exit
    }

    Write-Host "[*] Attempting creation of the required key entry..."

    Start-Sleep -Seconds 1

    try {
        New-ItemProperty -Path Microsoft.PowerShell.Core\Registry::HKCU\Software\Microsoft\Office\16.0\Outlook\Preferences\ -Name "DelegateSentItemsStyle" -PropertyType DWORD -Value "1" | Out-Null

        Write-Host -ForegroundColor Green "[*] Hive/Key Entry Created [*]"

        Start-Sleep -Seconds 1
    }
    catch {
        Write-Host -ForegroundColor Red "[!] Failed to create key entry [!]"

        Start-Sleep -Seconds 1

        exit
    }

    RestartOutlook

    Write-Host -ForegroundColor Green "[*] Script complete, departing..."

    Start-Sleep -Seconds 1

}

main