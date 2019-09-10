# Add a user to the local administrator group #

$UserName = Read-Host "[+] Enter the username-> "

$UserPass = Read-Host -AsSecureString "[+] Enter the password-> "

New-LocalUser $UserName -Password $UserPass -FullName $UserName -Confirm

Add-LocalGroupMember -Group "Administrators" -Member $UserName -Confirm