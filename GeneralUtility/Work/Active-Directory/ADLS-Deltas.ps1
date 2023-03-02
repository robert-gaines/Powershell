$ou = "OU=Finance and Administration,OU=WSU,DC=ad,DC=wsu,DC=edu"

$ad_machines = Get-ADComputer -SearchBase $ou -Filter * | Select-Object Name

$ls_objects = Get-Content -Path current_hosts.txt

$ad_computers = @()

$ad_machines | Foreach-Object { $ad_computers += $_.Name }

$ls_objects | Foreach-Object {

                                    Write-Host -ForegroundColor Yellow "Checking: $_ " #; Start-Sleep -Seconds 1
                                
                                    if($ad_computers -NotContains $_)
                                    {
                                        $obj = $_
                                        Write-Host -ForegroundColor Red "[!] Object not found in AD-> $obj"#; Start-Sleep -Seconds 1
                                        "Object not found: $obj " | Out-File "ad_deltas.txt" -Append
                                    }
                                
                             }


