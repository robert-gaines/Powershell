# Adds users from a .csv file #

Write-Host "[*] User addition from .csv script [*]"

$tempPassword = ConvertTo-SecureString -AsPlainText "d3f@ultP@ssw0rd" -Force

$targetPath = Read-Host "[+] Enter the path and the file name-> "

Write-Host "[*] Adding users from: $targetPath "

if($targetPath)
{
    Import-CSV $targetPath | `
    New-ADUser -AccountPassword $tempPassword `
               -Enabled $true `
               -ChangePasswordAtLogon $true

}
else {
    Write-Host "[!] Import Failed ..."
    exit
}