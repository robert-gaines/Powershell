
function main()
{
    Import-CSV -Path Fake.csv | Foreach-Object {  
                                                 $fullName = $_.GivenName+' '+$_.MiddleInitial+' '+$_.Surname
                                                 $samName = $_.GivenName[0]+'.'+$_.Surname
                                                 $samName = $samName.ToLower()
                                                 $principalName = $samName+"@homelab.winlab.local"
                                                 Write-host -ForegroundColor Red "[*] Removing: $fullName "
                                                 Remove-ADUser -Identity $samName -Confirm:$false
                                                 Clear-Host
                                               } 

}

main