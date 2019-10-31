# Script designed to interact with Event Viewer #

$ErrorActionPreference = "SilentlyContinue"
function ListEvents($log)
{
    Get-EventLog -LogName $log | ForEach-Object { Write-Host $_.TimeGenerated "|" $_.Message | Format-Table -Wrap; Start-Sleep -Seconds 3; Clear-Host }
}

function RemoveEvents($log)
{
    $computerName = $env:COMPUTERNAME

    Write-Host -ForegroundColor Yellow "[*] Attempting event viewer log removal on: ",$computerName

    Start-Sleep -Seconds 1

    try {
        Remove-EventLog -ComputerName $computerName -LogName $log

        Write-Host -ForegroundColor Green "[*] Event viewer log removal successful [*]"
    }
    catch {
        Write-Host -ForegroundColor Red "[!] Failed to remove event viewer log entry [!]"
    }
}

function RemoveAllEvents()
{
    try {

        Write-Host -ForegroundColor Yellow "[*] Attempting removal of all event viewer logs..."

        Start-Sleep -Seconds 1

        Remove-EventLog -LogName *

        Write-Host -ForegroundColor Green "[*] Success [*]" ; Start-Sleep -Seconds 1

    }
    catch {
        Write-Host -ForegroundColor Red "[!] Failed to Remove Entries [!]"
    }
    
}
function main()
{
    Write-Host -ForegroundColor Blue "[*] Event Viewer Log Entry Management Script [*]" ; Start-Sleep -Seconds 1

    Write-Host -ForegroundColor Blue "[*] Fetching event categories..." ; Start-Sleep -Seconds 1

    Get-EventLog -List

    Write-Host -ForegroundColor Blue "
    [*] Event Viewer Management Options [*]
    ---------------------------------------
    1) List Event Viewer Logs - Specific Category
    2) Remove Event Viewer Logs - Specific Category
    3) Remove All Event Viewer Logs
    4) Exit
    "

    $selection = Read-Host "[+] Selection "

    switch($selection)
    {
        "1" {
                Get-EventLog -List
                $log = Read-Host "[+] Enter the log category "
                ListEvents($log)
            }
        "2" {
                Get-EventLog -List
                $log = Read-Host "[+] Enter the log category "
                RemoveEvents($log)
            }
        "3" {

            }    
        "4" {
                exit
            }
        default { exit }
    }

    #ListEvents("System")

}

main