# Delete an AD User Account #

function main()
{
    Write-host -ForegroundColor Blue "[*] User Account Deletion Script [*]`n"
    
    Write-Host -ForegroundColor Blue "[*] Listing user accounts...`n"

    Start-Sleep -Seconds 1

    Write-Host "
User Accounts
-------------`n
    "

    Get-ADUser -Filter * | Foreach-Object { Write-Host -ForegroundColor Blue $_.Name }

    Write-Host "`n"

    $targetUser = Read-Host "[+] Enter the user account name "

    try {
        Write-Host -ForegroundColor Yellow "[*] Attempting to remove the account..."

        Remove-ADUser -Identity $targetUser -Confirm:$false

        Write-Host -ForegroundColor Green "[*] Successfully removed: $targetUser [*]"
    }
    catch {
        Write-Host -ForegroundColor Red "[!] Failed to delete the user account [!]"

        exit
    }
}

main