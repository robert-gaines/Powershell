$new_object_path = (Get-ADOrganizationalUnit -SearchBase "OU=Environmental Health,OU=Finance and Administration,OU=WSU,DC=ad,DC=wsu,DC=edu" -Filter * | Where-Object { $_.Name -eq 'Workstations' }).DistinguishedName

$ad_group_ehoh = (Get-ADGroup -Identity "FAIS EHOH Computers").Name 

$ad_group_ehes = (Get-ADGroup -Identity "FAIS EHES Computers").Name 

$new_ehs_hosts = @(
                  <# "FAIS-EHOH-TJELT", #>
                     "FAIS-EHOH-MRMLT",
                     "FAIS-EHOH-SLGLT",
                     "FAIS-EHOH-DASLT",
                     "FAIS-EHES-ASWLT",
                     "FAIS-EHOH-JPBLT",
                     "FAIS-EHOH-SAGLT"
                  )

$admin_creds = Get-Credential

$new_ehs_hosts | Foreach-Object {
                                   Write-Host "[*] Adding: $_ "

                                   $machine_name = $_

                                   New-ADComputer -Name $machine_name -SAMAccountName $machine_name -Path $new_object_path -Enabled:$true -Description "IP: TBD | EHS Laptop" -Credential $admin_creds
                                }

<#
$new_ehs_hosts | Foreach-Object {
                                    $machine_name = $_
                                    $segments = $machine_name.Split('-')
                                    $unit = $segments[1]

                                    $applicant = (Get-ADComputer -Identity $machine_name).Name 

                                    if($unit -eq 'EHOH')
                                    {
                                        Add-ADGroupMember -Identity $ad_group_ehoh -Members $applicant -Credential $admin_creds
                                    }
                                    if($unit -eq 'EHES')
                                    {
                                        Add-ADGroupMember -Identity $ad_group_ehes -Members $applicant -Credential $admin_creds
                                    }
                                }
#>