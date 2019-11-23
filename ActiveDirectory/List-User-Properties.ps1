# Lists all available user object properties #

Get-ADUser -Filter * -Properties * | Get-Member -MemberType property