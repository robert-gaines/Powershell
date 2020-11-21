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

    $searchBase =  "OU=Finance and Administration,OU=WSU,DC=ad,DC=wsu,DC=edu"

    $excel = New-Object -ComObject excel.application

    $excel.visible = $true

    $workbook = $excel.Workbooks.Add()

    $fais_computers = $workbook.Worksheets.Item(1)

    $fais_computers.Name = "FAIS_AD_Computers"

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

    for($i = 0; $i -le $column_headers.length; $i++)
    {
        Write-Host $column_headers[$i]
        $fais_computers.Cells.Item($row,$col).Font.Bold = $true
        $fais_computers.Cells.Item($row,$col)=$column_headers[$i]
        $col++
    }

    $row++
    
    Get-ADComputer -SearchBase $searchBase -Filter * -Properties * | Foreach-Object {

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

                                                                                       $excel.cells.item($row,1) = $name
                                                                                       $excel.cells.item($row,2) = $created
                                                                                       $excel.cells.item($row,3) = $ip_addr
                                                                                       $excel.cells.item($row,4) = $os_system
                                                                                       $excel.cells.item($row,5) = $os_version
                                                                                       $excel.cells.item($row,6) = $enabled
                                                                                       $excel.cells.item($row,7) = $last_logon

                                                                                       $row++

                                                                                    }
   $usedRange = $fais_computers.UsedRange

   $usedRange.EntireColumn.AutoFit() | Out-Null
                                                                                    
   $filename = GenerateFileName
   
   $path = Get-Location ; $outputPath = $path.Path+'\'+$filename

   $workbook.SaveAs($outputPath)
   
   $excel.Quit()   
}

main