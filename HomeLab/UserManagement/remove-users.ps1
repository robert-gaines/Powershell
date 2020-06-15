function main()
{

    $user_data = Import-CSV -Path fake.csv

    $user_data | Foreach-Object { 
                                   $given_name         = $_.GivenName
                                   $surname            = $_.Surname 
                                   $sam_name           = "$given_name.$surname"
                                   $sam_name           = $sam_name.ToLower()
                                 
                                   Write-Host -ForegroundColor Red "[!] Removing: $sam_name"

                                   Remove-ADUser -Identity $sam_name -Confirm:$false
                                }

    Get-ChildItem -Path "\\10.10.1.21\USER-SHARE\" | Foreach-Object {Remove-Item -Path $_.FullName -Force -Recurse }
}

main