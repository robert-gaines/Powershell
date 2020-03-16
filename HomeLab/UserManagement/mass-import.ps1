
function main()
{

    Import-CSV -Path Fake.csv | Foreach-Object {  
                                                   $fullName = $_.GivenName+' '+$_.MiddleInitial+' '+$_.Surname
                                                   $samName = $_.GivenName[0]+'.'+$_.Surname
                                                   $samName = $samName.ToLower()
                                                   $principalName = $samName+"@homelab.winlab.local"
                                                   $password = $_.Password | ConvertTo-SecureString -AsPlainText -Force
                                                   Write-host -ForegroundColor Green "[*] Adding: $fullName "
                                                   New-ADUser -GivenName $($_.GivenName) -Surname $($_.Surname) `
                                                   -SamAccountName $samName -UserPrincipalName $principalName -Enabled:$false `
                                                   -Name $fullName -AccountPassword $password -Path "CN=Users,DC=homelab,DC=winlab,DC=local" `
                                                   -HomePhone $_.TelephoneNumber -StreetAddress $_.StreetAddress -State $_.StateFull -City $_.City 
                                                   Clear-Host
                                                } 

}

main