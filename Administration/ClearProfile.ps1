# Clear User Profile #

$ErrorActionPreference = "SilentlyContinue"

try {
    Get-CIMInstance -ClassName Win32_UserProfile | Where-Object { $_.LocalPath -eq "C:\Users\Veterans1" } | Remove-CIMInstance
    #
    Write-Host -ForegroundColor Green "[*] Cleared host profile [*]"
}
catch {
    Write-Host "[!] Failed to find user profile [!]"
}

Clear-Host

Start-Sleep -Seconds 1

exit