# Add a new user within Active Directory #

Write-Host "[*] New Active Directory User Addition Script [*]"

Write-Host " "

$userFirst   =   Read-Host "[+] Enter the user's first name-> "
$userLast    =   Read-Host "[+] Enter the user's last name-> "
$samAcctName =   Read-Host "[+] Enter the SAM Account name-> "
$givenName   =   $userFirst+" "+$userLast

$userPass = Read-Host -AsSecureString "[+] Enter the new user's password-> "

Write-Host "[*] Adding new user in Active Directory..."

New-ADUser -Name $userFirst -Surname $userLast -GivenName $givenName -SamAccountName $samAcctName -AccountPassword $userPass -Enabled $true -ChangePasswordAtLogon $true

Get-ADUser -Identity $samAcctName


