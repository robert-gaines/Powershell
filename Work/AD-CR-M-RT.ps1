# Create AD Inventory #>

function GenerateFileName()
{
    $timeStamp = Get-Date -Format "dddd_MM_dd_yyyy_HH_mm"

    $title = "FAIS_AD_HOST_INV_"

    $title += $timeStamp

    $title += "_.xlsx"

    return $title
}

function main()
{
    Write-Host -BackgroundColor Black -ForegroundColor Green "[*] Active Directory Computer Inventory Script [*]"

    Start-Sleep -Seconds 1

    $current_user = $env:USERNAME

    Set-Location -Path "C:\Users\$current_user\Desktop\"

    <#
          FAIS OUs
          -------- 
        - Budget Office        -> "OU=Budget Office,OU=Finance and Administration,OU=WSU,DC=ad,DC=wsu,DC=edu"
        - CRCI                 -> "OU=CRCI,OU=Finance and Administration,OU=WSU,DC=ad,DC=wsu,DC=edu"
        - CREO                 -> "OU=CREO,OU=Finance and Administration,OU=WSU,DC=ad,DC=wsu,DC=edu"
        - Environmental Health -> "OU=Environmental Health,OU=Finance and Administration,OU=WSU,DC=ad,DC=wsu,DC=edu"
        - ERP                  -> "OU=ERP,OU=Finance and Administration,OU=WSU,DC=ad,DC=wsu,DC=edu"	
        - Facilities Services  -> "OU=Facilities Services,OU=Finance and Administration,OU=WSU,DC=ad,DC=wsu,DC=edu"
        - Financial Services   -> "OU=Financial Services,OU=Finance and Administration,OU=WSU,DC=ad,DC=wsu,DC=edu"
        - Information Systems  -> "OU=Information Systems,OU=Finance and Administration,OU=WSU,DC=ad,DC=wsu,DC=edu" 
        - Loaners              -> "OU=Loaners,OU=Finance and Administration,OU=WSU,DC=ad,DC=wsu,DC=edu"
        - POS                  -> "OU=POS,OU=Finance and Administration,OU=WSU,DC=ad,DC=wsu,DC=edu"
        - Public Safety        -> "OU=Public Safety,OU=Finance and Administration,OU=WSU,DC=ad,DC=wsu,DC=edu"
        - Resource Planning    -> "OU=Resource Planning,OU=Finance and Administration,OU=WSU,DC=ad,DC=wsu,DC=edu"
        - Servers              -> "OU=Servers,OU=Finance and Administration,OU=WSU,DC=ad,DC=wsu,DC=edu"
        - Servers RDC          -> "OU=Servers RDC,OU=Finance and Administration,OU=WSU,DC=ad,DC=wsu,DC=edu"
        - VP                   -> "OU=VP,OU=Finance and Administration,OU=WSU,DC=ad,DC=wsu,DC=edu"

     #>

    $toplevel_ou_collection = @(
                                "OU=Finance and Administration,OU=WSU,DC=ad,DC=wsu,DC=edu",
                                "OU=Budget Office,OU=Finance and Administration,OU=WSU,DC=ad,DC=wsu,DC=edu",
                                "OU=CRCI,OU=Finance and Administration,OU=WSU,DC=ad,DC=wsu,DC=edu",
                                "OU=CREO,OU=Finance and Administration,OU=WSU,DC=ad,DC=wsu,DC=edu",
                                "OU=Environmental Health,OU=Finance and Administration,OU=WSU,DC=ad,DC=wsu,DC=edu"
                                "OU=ERP,OU=Finance and Administration,OU=WSU,DC=ad,DC=wsu,DC=edu",
                                "OU=Facilities Services,OU=Finance and Administration,OU=WSU,DC=ad,DC=wsu,DC=edu",
                                "OU=Financial Services,OU=Finance and Administration,OU=WSU,DC=ad,DC=wsu,DC=edu",
                                "OU=Information Systems,OU=Finance and Administration,OU=WSU,DC=ad,DC=wsu,DC=edu",
                                "OU=Loaners,OU=Finance and Administration,OU=WSU,DC=ad,DC=wsu,DC=edu",
                                "OU=POS,OU=Finance and Administration,OU=WSU,DC=ad,DC=wsu,DC=edu",
                                "OU=Public Safety,OU=Finance and Administration,OU=WSU,DC=ad,DC=wsu,DC=edu",
                                "OU=Resource Planning,OU=Finance and Administration,OU=WSU,DC=ad,DC=wsu,DC=edu",
                                "OU=Servers,OU=Finance and Administration,OU=WSU,DC=ad,DC=wsu,DC=edu",
                                "OU=Servers RDC,OU=Finance and Administration,OU=WSU,DC=ad,DC=wsu,DC=edu",
                                "OU=VP,OU=Finance and Administration,OU=WSU,DC=ad,DC=wsu,DC=edu"
                               )

    <# Top Level -> $searchBase =  "OU=Finance and Administration,OU=WSU,DC=ad,DC=wsu,DC=edu" #>

    $excel = New-Object -ComObject excel.application

    $excel.visible = $true

    $workbook = $excel.Workbooks.Add() 

    <# Create the Worksheets #>

    $fais_computers = $workbook.Sheets.Add()
    $fais_computers.Name = "FAIS - All Computers"

    $budget_computers = $workbook.Sheets.Add()
    $budget_computers.Name = 'Budget Office'

    $crci_computers = $workbook.Sheets.Add()
    $crci_computers.Name = 'CRCI'

    $creo_computers = $workbook.Sheets.Add()
    $creo_computers.Name = 'CREO'

    $ehs_computers = $workbook.SHeets.Add()
    $ehs_computers.Name = 'EHS'

    $erp_computers = $workbook.Sheets.Add()
    $erp_computers.Name = 'ERP'

    $fs_computers = $workbook.Sheets.Add()
    $fs_computers.Name = 'Facilities'

    $finance_computers = $workbook.Sheets.Add()
    $finance_computers.Name = 'Finance'

    $is_computers = $workbook.Sheets.Add()
    $is_computers.Name = 'FAIS'

    $loaner_computers = $workbook.Sheets.Add()
    $loaner_computers.Name = 'Loaners'

    $pos_computers = $workbook.Sheets.Add()
    $pos_computers.Name = 'POS'

    $ps_computers = $workbook.Sheets.Add()
    $ps_computers.Name = 'Public Safety'

    $resource_planning_computers = $workbook.Sheets.Add()
    $resource_planning_computers.Name = 'Resource Planning'

    $servers = $workbook.Sheets.Add()
    $servers.Name = 'Servers'

    $servers_rdc = $workbook.Sheets.Add()
    $servers_rdc.Name = 'RDC Servers'

    $vp_computers = $workbook.Sheets.Add()
    $vp_computers.Name = 'VP'

    $worksheets_array = @(
                            $fais_computers,
                            $budget_computers,
                            $crci_computers,
                            $creo_computers,
                            $ehs_computers,
                            $erp_computers,
                            $fs_computers,
                            $finance_computers,
                            $is_computers,
                            $loaner_computers,
                            $pos_computers,
                            $ps_computers,
                            $resource_planning_computers,
                            $servers,
                            $servers_rdc,
                            $vp_computers
                         )

    $column_headers = @(
                          'Name',
                          'Date Created',
                          'IP Address',
                          'OS',
                          'OS Version',
                          'Enabled',
                          'Last Logon'
                       )
    $row = 1
    $col = 1

    $worksheets_array | Foreach-Object {
                                               $active_sheet = $_

                                               for($i = 0; $i -le $column_headers.length; $i++)
                                               {
                                                    $active_sheet.Cells.Item($row,$col).Font.Bold = $true
                                                    $active_sheet.Cells.Item($row,$col)=$column_headers[$i]
                                                    $col++
                                               }
                                               $col = 1
                                       }

    $row++
    
    <# Collect Date For Comparison #>

    $date = Get-Date

    $current_day = $date.DayOfYear

    for($i = 0; $i -lt $toplevel_ou_collection.Length; $i++) {
                                                                  $row = 2
                                                                  
                                                                  $ou = $toplevel_ou_collection[$i]

                                                                  Get-ADComputer -SearchBase $ou -Filter * -Properties * | Foreach-Object {

                                                                                                                                        $name       = $_.Name
                                                                                                                                        $created    = $_.Created
                                                                                                                                        $ip_addr    = $_.IPv4Address
                                                                                                                                        $enabled    = $_.Enabled 
                                                                                                                                        $last_logon = $_.LastLogonDate
                                                                                                                                        $os_system  = $_.OperatingSystem
                                                                                                                                        $os_version = $_.OperatingSystemVersion

                                                                                                                                        if($os_version)
                                                                                                                                        {
                                                                                                                                            $version_str= $os_version.ToString()
                                                                                                                                        }

                                                                                                                                        Write-Host -BackgroundColor Black -ForegroundColor Green "[*] Located: $name "

                                                                                                                                        $active_sheet = $worksheets_array[$i]

                                                                                                                                        $active_sheet.cells.item($row,1) = $name
                                                                                                                                        $active_sheet.cells.item($row,2) = $created
                                                                                                                                        $active_sheet.cells.item($row,3) = $ip_addr
                                                                                                                                        $active_sheet.cells.item($row,4) = $os_system
                                                                                                                                        $active_sheet.cells.item($row,5) = $os_version

                                                                                                                                        if($enabled -ne 'TRUE')
                                                                                                                                        {
                                                                                                                                            $active_sheet.cells.item($row,6) = $enabled
                                                                                                                                            $active_sheet.cells.item($row,6).Interior.ColorIndex = 3
                                                                                                                                        }
                                                                                                                                        else
                                                                                                                                        {
                                                                                                                                            $active_sheet.cells.item($row,6) = $enabled
                                                                                                                                        }
                                                                                                                                        if([Math]::Abs(($current_day - $last_logon.DayOfYear)) -ge 180)
                                                                                                                                        {
                                                                                                                                            $active_sheet.cells.item($row,7) = $last_logon
                                                                                                                                            $active_sheet.cells.item($row,7).Interior.ColorIndex = 3
                                                                                                                                        }
                                                                                                                                        else
                                                                                                                                        {
                                                                                                                                            $active_sheet.cells.item($row,7) = $last_logon
                                                                                                                                        }

                                                                                                                                        $row++

                                                                                                                                    }

                                           }

   $worksheets_array | Foreach-Object {

                                        $active_sheet = $_

                                        $used_range = $active_sheet.UsedRange

                                        $used_range.EntireColumn.AutoFit() | Out-Null

                                      }
                             
   ($workbook.sheets | Where-Object { $_.Name -eq 'Sheet1' }).delete()
                                                                                    
   $filename = GenerateFileName
   
   $path = Get-Location ; $outputPath = $path.Path+'\'+$filename

   $workbook.SaveAs($outputPath)
   
   $excel.Quit()   
}

main