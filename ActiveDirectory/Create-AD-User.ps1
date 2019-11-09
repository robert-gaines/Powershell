# Create a user in AD #

function main()
{
    Write-Host -ForegroundColor Blue "[*] AD User Creation Script [*]"

    Start-SLeep -Seconds 1

    $userName = Read-Host "[+] Enter the user's name-> "
    $samName  = Read-Host "[+] Enter the SAM Account Name-> "
    $prnName  = Read-Host "[+] Enter the principal name-> "
    $passwd   = Read-Host -AsSecureString "[+] Enter the user's password-> "

    $path = "CN=Users,DC=homelab,DC=winlab,DC=local"

    Write-Host -ForegroundColor Yellow "
    
    Attempting User Account Creation for:
    ------------------------------------
    User Name:       $userName
    SAM Name:        $samName
    Principal Name:  $prnName
    Path:            $path
    "

    Start-Sleep -Seconds 1

    try {
        New-ADUser -Name $userName -SamAccountName $samName `
        -UserPrincipalName $prnName -AccountPassword $passwd `
        -Path $path -Enabled:$true

        Write-Host -ForegroundColor Green "[*] Account created successfully [*]"
    }
    catch {
        Write-Host -ForegroundColor Red "[!] Failed to create the account [!]"

        Start-Sleep -Seconds 1

        exit
    }
}

main