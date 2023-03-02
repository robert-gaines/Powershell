# Create AD Inventory #>

$ErrorActionPreference = 'SilentlyContinue'

function GenerateFileName()
{
    $timeStamp = Get-Date -Format "dddd_MM_dd_yyyy_HH_mm"

    $title = "FAIS_AD_USER_INV_"

    $title += $timeStamp

    $title += "_.xlsx"

    return $title
}

function main()
{
    Write-Host -BackgroundColor Black -ForegroundColor Green "[*] Active Directory User Inventory Script [*]"

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
                                "OU=Public Safety,OU=Finance and Administration,OU=WSU,DC=ad,DC=wsu,DC=edu",
                                "OU=Resource Planning,OU=Finance and Administration,OU=WSU,DC=ad,DC=wsu,DC=edu",
                                "OU=VP,OU=Finance and Administration,OU=WSU,DC=ad,DC=wsu,DC=edu"
                               )

    <# Top Level -> $searchBase =  "OU=Finance and Administration,OU=WSU,DC=ad,DC=wsu,DC=edu" #>

    $excel = New-Object -ComObject excel.application

    $excel.visible = $true

    $workbook = $excel.Workbooks.Add() 

    <# Create the Worksheets #>

    $fais_users = $workbook.Sheets.Add()
    $fais_users.Name = "FAIS - All Users"

    $budget_users = $workbook.Sheets.Add()
    $budget_users.Name = 'Budget Office'

    $crci_users = $workbook.Sheets.Add()
    $crci_users.Name = 'CRCI'

    $creo_users = $workbook.Sheets.Add()
    $creo_users.Name = 'CREO'

    $ehs_users = $workbook.SHeets.Add()
    $ehs_users.Name = 'EHS'

    $erp_users = $workbook.Sheets.Add()
    $erp_users.Name = 'ERP'

    $fs_users = $workbook.Sheets.Add()
    $fs_users.Name = 'Facilities'

    $finance_users = $workbook.Sheets.Add()
    $finance_users.Name = 'Finance'

    $is_users = $workbook.Sheets.Add()
    $is_users.Name = 'FAIS'

    $ps_users = $workbook.Sheets.Add()
    $ps_users.Name = 'Public Safety'

    $resource_planning_users = $workbook.Sheets.Add()
    $resource_planning_users.Name = 'Resource Planning'

    $vp_users = $workbook.Sheets.Add()
    $vp_users.Name = 'VP'

    $worksheets_array = @(
                            $fais_users,
                            $budget_users,
                            $crci_users,
                            $creo_users,
                            $ehs_users,
                            $erp_users,
                            $fs_users,
                            $finance_users,
                            $is_users,
                            $ps_users,
                            $resource_planning_users,
                            $vp_users
                         )
                         
    $column_headers = @(
                          'DisplayName',
                          'Name',
                          'EmployeeID'
                          'OfficePhone',
                          'Department',
                          'EmailAddress',
                          'Title',
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

                                                                  $user_array = @()

                                                                  Get-ADGroup -SearchBase $ou -FIlter * | Select-Object Name | Foreach-Object { $var = Get-ADGroupMember -Identity $_.Name | Where-Object { $_.ObjectClass -eq 'user' } ; if($var) {$user_array += $var.name} }

                                                                  $user_array | Foreach-Object { 
                                                                  
                                                                                                     $user = $_ ;  Get-ADUser -Identity $user -Properties * | Select-Object DisplayName,Name,EmployeeID,OfficePhone,Department,EmailAddress,Title,Enabled,LastLogonDate | Foreach-Object {

                                                                                                     $display_name       = $_.DisplayName
                                                                                                     $name               = $_.Name
                                                                                                     $employee_id        = $_.EmployeeID
                                                                                                     $office_phone       = $_.OfficePhone 
                                                                                                     $department         = $_.Department
                                                                                                     $email_addr         = $_.EmailAddress

                                                                                                     if($email_addr -eq $null)
                                                                                                     {
                                                                                                        $email_addr = 'Unknown'
                                                                                                     }

                                                                                                     $title              = $_.Title
                                                                                                     $enabled            = $_.Enabled
                                                                                                     $last_logon         = $_.LastLogonDate

                                                                                                     Write-Host -BackgroundColor Black -ForegroundColor Green "[*] Located: $name "

                                                                                                     $active_sheet = $worksheets_array[$i]

                                                                                                     $active_sheet.cells.item($row,1) = $display_name
                                                                                                     $active_sheet.cells.item($row,2) = $name
                                                                                                     $active_sheet.cells.item($row,3) = $employee_id
                                                                                                     $active_sheet.cells.item($row,4) = $office_phone
                                                                                                     $active_sheet.cells.item($row,5) = $department
                                                                                                     $active_sheet.cells.item($row,6) = $email_addr
                                                                                                     $active_sheet.cells.item($row,7) = $title
                                                                                                     $active_sheet.cells.item($row,8) = $enabled

                                                                                                     if($enabled -eq $null)
                                                                                                     {
                                                                                                        $active_sheet.cells.item($row,8) = 'Unknown'
                                                                                                     }
                                                                                                     elseif($enabled -ne 'TRUE')
                                                                                                     {
                                                                                                           $active_sheet.cells.item($row,8) = $enabled
                                                                                                           $active_sheet.cells.item($row,8).Interior.ColorIndex = 3
                                                                                                     }
                                                                                                     elseif($enabled -eq $null)
                                                                                                     {
                                                                                                            $active_sheet.cells.item($row,8) = 'Unknown'
                                                                                                     }
                                                                                                     else
                                                                                                     {
                                                                                                           $active_sheet.cells.item($row,8) = $enabled
                                                                                                     }

                                                                                                     if([Math]::Abs(($current_day - $last_logon.DayOfYear)) -ge 180)
                                                                                                     {
                                                                                                           $active_sheet.cells.item($row,9) = $last_logon
                                                                                                           $active_sheet.cells.item($row,9).Interior.ColorIndex = 3
                                                                                                     }
                                                                                                     else
                                                                                                     {
                                                                                                           $active_sheet.cells.item($row,9) = $last_logon
                                                                                                     }

                                                                                                     $row++                                                                                                                                                                                   }
                                                                  
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