# Count Hosts per OU "

# Get-ADOrganizationalUnit -SearchBase "OU=Finance and Administration,OU=WSU,DC=ad,DC=wsu,DC=edu" -Filter "Name -like 'Workstations'" | Format-Table 

Write-Host -ForegroundColor Yellow "

[~] FAIS Server/Workstation Counting Script [~]
-----------------------------------------------

                                   " 

$FAIS_OUS = @(                       
             "OU=Workstations,OU=Budget Office,OU=Finance and Administration,OU=WSU,DC=ad,DC=wsu,DC=edu",                                                                                                                        
             "OU=Workstations,OU=CRCI,OU=Finance and Administration,OU=WSU,DC=ad,DC=wsu,DC=edu",                                                                                                                                 
             "OU=Workstations,OU=CREO,OU=Finance and Administration,OU=WSU,DC=ad,DC=wsu,DC=edu",                                                                                                                                
             "OU=Workstations,OU=Environmental Health,OU=Finance and Administration,OU=WSU,DC=ad,DC=wsu,DC=edu",                                                                                                                
             "OU=Workstations,OU=ERP,OU=Finance and Administration,OU=WSU,DC=ad,DC=wsu,DC=edu",                                                                                                                                 
             "OU=Workstations,OU=Facilities Services,OU=Finance and Administration,OU=WSU,DC=ad,DC=wsu,DC=edu",                                                                                                                  
             "OU=Workstations,OU=Financial Services,OU=Finance and Administration,OU=WSU,DC=ad,DC=wsu,DC=edu",                                                                                                                  
             "OU=Workstations,OU=Information Systems,OU=Finance and Administration,OU=WSU,DC=ad,DC=wsu,DC=edu",                                                                                                                  
             "OU=Workstations,OU=Public Safety,OU=Finance and Administration,OU=WSU,DC=ad,DC=wsu,DC=edu",                                                                                                                      
             "OU=Workstations,OU=Resource Planning,OU=Finance and Administration,OU=WSU,DC=ad,DC=wsu,DC=edu",
             "OU=Servers RDC,OU=Finance and Administration,OU=WSU,DC=ad,DC=wsu,DC=edu",
             "OU=Servers,OU=Finance and Administration,OU=WSU,DC=ad,DC=wsu,DC=edu",                                                                                                                  
             "OU=Workstations,OU=VP,OU=Finance and Administration,OU=WSU,DC=ad,DC=wsu,DC=edu",                                                                                                                              
             "OU=Workstations,OU=Loaners,OU=Finance and Administration,OU=WSU,DC=ad,DC=wsu,DC=edu",                                                                                                                            
             "OU=Workstations,OU=POS,OU=Finance and Administration,OU=WSU,DC=ad,DC=wsu,DC=edu"
             )

$total_hosts = 0
$total_workstations = 0
$total_servers = 0

$FAIS_OUS | Foreach-Object {
                                 $host_count = 0
                                 $segments = $_.Split("[{,}")
                                 $unit = $segments[1] 
                                 Write-Host -ForegroundColor Yellow "[~] Counting hosts in: $unit "
                                 Get-ADComputer -SearchBase $_ -Filter * | Foreach-Object { 
                                                                                             $host_count += 1
                                                                                             if($segments[0] -contains "OU=Workstations")
                                                                                             {
                                                                                                $total_workstations += 1
                                                                                             }
                                                                                             if(($segments[0] -contains "OU=Servers") -or ($segments[0] -contains "OU=Servers RDC"))
                                                                                             {
                                                                                                $total_servers += 1
                                                                                             }
                                                                                          }
                                 Write-Host -ForegroundColor Green "[*] $unit hosts: $host_count "
                                 $total_hosts += $host_count
                           }
Write-Host ''
Write-Host -ForegroundColor Green "[*] Total servers: $total_servers "
Write-Host -ForegroundCOlor Green "[*] Total Workstations: $total_workstations "
Write-Host -ForegroundColor Green "[*] Total FAIS hosts: $total_hosts "

