# Create a managed service account #

function main()
{
    Write-Host -ForegroundColor Blue "[*] Managed Service Account Creation Script [*]`n"

    $msaName = Read-Host "[+] Enter the service account name-> "

    $path = "cn=Managed Service Accounts,DC=homelab,DC=winlab,DC=local"

    Write-Host -ForegroundColor Yellow "[*] Adding the KDS Root Key ..."

    try {
        Add-KDSRootKey -EffectiveImmediately

        $keyObject = Get-KDSRootKey 

        Write-Host -ForegroundColor Green "[*] KDS Root Key: $keyObject "
    }
    catch {
        Write-Host -ForegroundColor Red "[!] Key Addition Error [!]"

        exit
    }

    Write-Host -ForegroundColor Yellow "[*] Attempting service account creation [*]"

    Start-Sleep -Seconds 1

    try {
        New-ADServiceAccount -Name $msaName -Path $path

        Write-Host -ForegroundColor Green "[*] Successfully added: $msaName"
    }
    catch {
        Write-Host -ForegroundColor Red "[!] Failed to add Managed Service Account [!]"

        exit
    }
}

main