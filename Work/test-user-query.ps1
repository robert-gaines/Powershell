$test_users = @()

Get-ADGroup -SearchBase "OU=Budget Office,OU=Finance and Administration,OU=WSU,DC=ad,DC=wsu,DC=edu" -FIlter * | Select-Object Name | Foreach-Object { $var = Get-ADGroupMember -Identity $_.Name | Where-Object { $_.ObjectClass -eq 'user' } ; if($var) {$test_users += $var.name} }

$test_users | Foreach-Object { $user = $_ ;  Get-ADUser -Identity $user -Properties * | Select-Object DisplayName,Name,EmployeeID,OfficePhone,Department,EmailAddress,Title,LastLogonDate,Enabled }