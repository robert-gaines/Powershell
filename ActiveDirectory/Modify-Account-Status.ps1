# Script to disable a user account #

function DisableAccount()
{
    Write-Host -ForegroundColor Blue "[*] Disable Account Subroutine [*]"

    Write-Host -ForegroundColor Blue "[*] Listing AD Accounts "

    Start-SLeep -Seconds 1

    Write-Host -ForegroundColor Blue "
    
User Objects `t Enabled
------------ `t -------
"

    Get-ADUser -Filter * | ForEach-Object { Write-Host -ForegroundColor Blue $_.Name ,"`t", $_.Enabled }

    $targetUser = Read-Host "[+] Enter the user account to be disabled "

    try {
        Write-Host -ForegroundColor Yellow  "[*] Attempting to disable: $targetUser "

        Disable-ADAccount -Identity $targetUser

        Write-Host -ForegroundColor Green "[*] Disabled: $targetUser "
    }
    catch {
        Write-Host -ForegroundColor Red "[!] Failed to disable: $targetUser [!]"

        exit
    }
}
function EnableAccount()
{
    Write-Host -ForegroundColor Blue "[*] Enable Account Subroutine [*]"

    Write-Host -ForegroundColor Blue "[*] Listing AD Accounts "

    Start-SLeep -Seconds 1

    Write-Host -ForegroundColor Blue "
    
User Objects `t Enabled
------------ `t -------
"

    Get-ADUser -Filter * | ForEach-Object { Write-Host -ForegroundColor Blue $_.Name ,"`t", $_.Enabled }

    $targetUser = Read-Host "[+] Enter the user account to be enabled "

    try {
        Write-Host -ForegroundColor Yellow  "[*] Attempting to enable: $targetUser "

        Enable-ADAccount -Identity $targetUser

        Write-Host -ForegroundColor Green "[*] Enabled: $targetUser "
    }
    catch {
        Write-Host -ForegroundColor Red "[!] Failed to enable: $targetUser [!]"

        exit
    }
}
function main()
{
    Write-Host -ForegroundColor Blue "[*] Account Status Modification Script [*]"

    Write-Host "`n"

    Write-Host -ForegroundColor Blue "
    Options
    -------
    1) Disable an Account
    2) Enable an Account
    3) Exit
    " 
    $selection = Read-Host "[+] Selection "

    switch ($selection) {
        "1" { DisableAccount }
        "2" { EnableAccount  }
        "3" { exit }
        Default {exit}
    }
}

main