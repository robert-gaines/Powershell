# Modify the Accidental Deletion Prevention property #

function main()
{
    Write-host -ForegroundColor Blue "[*] User Account - ADP Toggle Script [*]`n"
    
    Write-Host -ForegroundColor Blue "[*] Listing user accounts...`n"

    Start-Sleep -Seconds 1

    Write-Host "
User Accounts
-------------`n
    "

    Get-ADUser -Filter * | Foreach-Object { Write-Host -ForegroundColor Blue $_.Name }

    $targetUser = Read-Host "[+] Enter the user name "

    try {
        Write-Host -ForegroundColor Yellow "[*] Attempting to toggle accidental deletion prevention to off..."

        Get-ADObject -LDAPFilter "(Name=$targetUser)" | Set-ADObject -ProtectedFromAccidentalDeletion:$false

        Write-Host -ForegroundColor Green "[*] Successfully toggled ADP off [*]"
    }
    catch {
        Write-Host -ForegroundColor Red "[!] Failed to toggle ADP off [!]"

        exit
    }
}

main