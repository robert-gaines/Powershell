$ErrorActionPreference = 'SilentlyContinue'

<# 

    Endpoint Assessment Script
    --------------------------
    -> The purpose of this 
       script is to automate
       some of the tasks 
       associated with
       discovery in the
       aftermath of 
       a suspected or
       actual compromise
    
    -> Author: RWG - 10/26/2020
       
#> 

function GenerateMainDirectoryName($computerName)
{
    $timeStamp = Get-Date -Format "dddd_MM_dd_yyyy_HH_mm_ss"

    $title = "IR_"+$computerName+"_"

    $title += $timeStamp

    return $title
}

function CreateMainDirectory()
{
    $directoryPath = (Get-Location).Path

    $computerName = $env:COMPUTERNAME

    $dirName = GenerateMainDirectoryName $computerName

    try
    {
        New-Item -ItemType Directory -Path $directoryPath -Name $dirName | Out-Null

        Write-Host -ForegroundColor Green "[*] Incident response data will be exported to: $dirName "
    }
    catch
    {
        Write-Host -ForegroundColor Red "[!] Failed to create main directory "

        exit
    }
 
    Set-Location -Path $dirName

    return $dirName
}

function GenerateReportDirectoryName($computerName)
{
    $timeStamp = Get-Date -Format "dddd_MM_dd_yyyy_HH_mm_ss"

    $title = "REPORTS_"+$computerName+"_"

    $title += $timeStamp

    return $title
}

function CreateReportDirectory()
{
    $directoryPath = (Get-Location).Path

    $computerName = $env:COMPUTERNAME

    $dirName = GenerateReportDirectoryName $computerName

    try
    {
        New-Item -ItemType Directory -Path $directoryPath -Name $dirName | Out-Null

        Write-Host -ForegroundColor Green "[*] Reports will be exported to subordinate directories within: $dirName "
    }
    catch
    {
        Write-Host -ForegroundColor Red "[!] Failed to create main directory "

        exit
    }
 
    Set-Location -Path $dirName

    return $dirName
}

function GenerateWinEventLogsDirectoryName($computerName)
{
    $timeStamp = Get-Date -Format "dddd_MM_dd_yyyy_HH_mm_ss"

    $title = "EVT_"+$computerName+"_"

    $title += $timeStamp

    return $title
}

function CollectLogs($ExportDirName)
{
    $logs = Get-EventLog -LogName * | Select-Object Log

    $categories = @()

    $logs | Foreach-Object { $category = $_.Log ; $categories += $category }

    $ExportDirName = $ExportDirName.ToString() 

    $categories | Foreach-Object {
                                    $category = $_

                                    New-Item -ItemType Directory -Path (Get-Location) -Name $category | Out-Null
                                 }
    
    $logs | Foreach-Object { 
                                $directory = $_.Log.ToString()

                                $curDir    = Get-Location ; $curDir = $curDir.Path+'\'+$directory

                                $events    = $directory+'.csv'

                                New-Item -ItemType File -Path $curDir -Name $events | Out-Null

                                $filePath = $curDir+'\'+$events

                                Write-Host -ForegroundColor Yellow "[*] Exporting: $directory "

                                try 
                                {
                                    Get-EventLog -LogName $_.Log -ErrorAction SilentlyContinue | Export-CSV -Path $filePath

                                    Write-Host -ForegroundColor Green "[*] Export complete: $directory "
                                }
                                catch 
                                {
                                    Write-Host -ForegroundColor Red "[!] Failed to export: $directory "
                                }
                           }

    Write-Host -ForegroundColor Green "[*] Windows Event Viewer Log Export Complete! " ; Start-Sleep -Seconds 3

}

function CreateReports()
{
    $computerName = $env:COMPUTERNAME

    Write-Host -ForegroundColor Green "[*] Creating reports..."

    $timeStamp = Get-Date -Format "dddd_MM_dd_yyyy_HH_mm_ss"

    $baseFileName = $computerName+'_'+$timeStamp+'.txt'  

    New-Item -ItemType Directory -Path . -Name "Tasklist" | Out-Null

    Set-Location -Path "TaskList"

    $fileName = "tasklist_"+$baseFileName

    tasklist | Out-File -FilePath $fileName

    $fileName = "tasklist_svc_"+$baseFileName

    tasklist /svc | Out-File -FilePath $fileName

    Set-Location -Path ..

    $fileName = "WMI_Startup_"+$baseFileName

    New-Item -ItemType Directory -Path . -Name "WMI" | Out-Null

    Set-Location -Path "WMI"

    wmic startup list full | Out-File -FilePath $fileName

    $fileName = "WMI_Process_"+$baseFileName

    wmic process list full | Out-File -FilePath $fileName 

    Set-Location -Path ..

    $fileName = "Registry_Run_"+$baseFileName

    New-Item -ItemType Directory -Path . -Name "Registry" | Out-Null

    Set-Location -Path "Registry"

    <# Registry Queries go here #>

    Get-ItemProperty -Path Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run | Out-File -FilePath $fileName

    $fileName = "Registry_RunOnce_"+$baseFileName

    Get-ItemProperty -Path Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce | Out-File -FilePath $fileName

    Set-Location -Path ..

    $fileName = "Net_View_"+$baseFileName

    New-Item -ItemType Directory -Path . -Name "Net" | Out-Null 

    Set-Location -Path "Net"

    <# Net Queries Go Here #>

    net view localhost | Out-File -FilePath $fileName

    $fileName = "Net_Session_"+$baseFileName

    net session | Out-File -FilePath $fileName

    $fileName = "Net_User_"+$baseFileName

    net user | Out-File -FilePath $fileName 

    $fileName = "Net_Admins_"+$baseFileName

    net localgroup administrators | Out-File -FilePath $fileName

    Set-Location -Path ..

    $fileName = "Netstat_TCP_"+$baseFileName

    New-Item -ItemType Directory -Path . -Name "Netstat" | Out-Null

    Set-Location -Path "Netstat"

    <# Netstat queries go here #>

    netstat -p tcp | Out-File -FilePath $fileName 

    $fileName = "Netstat_UDP_"+$baseFileName 

    netstat -p udp | Out-File -FilePath $fileName 

    $fileName = "Netstat_Programs_"+$baseFileName

    try
    {
        netstat -b | Out-File -FilePath $fileName 
    }
    catch
    {
        continue
    }

    $fileName = "Netstat_Routing_"+$baseFileName

    netstat -r | Out-File -FilePath $fileName 

    $fileName = "Netstat_Active_Connections_"+$baseFileName

    Set-Location -Path ..

    $fileName = "Nbtstat_"+$baseFileName

    New-Item -ItemType Directory -Path . -Name "Nbtstat" | Out-Null

    Set-Location -Path "Nbtstat"

    nbtstat -S | Out-File -FilePath $fileName

    Set-Location -Path ..

    $fileName = "SchedTasks_"+$baseFileName

    New-Item -ItemType Directory -Path . -Name "SchedTasks" | Out-Null 

    Set-Location -Path "SchedTasks"

    <# scheduled task query goes here #>

    schtasks | Out-File -FilePath $fileName

    <# Return to the main directory #>

    Set-Location -Path ..\..\
}

function CreateEventLogExportDirectory()
{
    $exportPath = (Get-Location).Path

    $computerName = $env:COMPUTERNAME

    $dirName = GenerateWinEventLogsDirectoryName $computerName

    try
    {
        New-Item -ItemType Directory -Path $exportPath -Name $dirName

        Write-Host -ForegroundColor Green "[*] Logs will be exported to: $dirName "
    }
    catch
    {
        Write-Host -ForegroundColor Red "[!] Failed to create export directory "

        exit
    }
 
    Set-Location -Path $dirName

    return $dirName
}

function GatherWinEventLogs()
{
    $origin = (Get-Location).Path

    Write-Host -ForegroundColor Green "[*] Exporting Windows Event Logs... "

    $ExportDirName = CreateEventLogExportDirectory

    CollectLogs $ExportDirName

    Write-Host -ForegroundColor Yellow "[*] Compressing the export directory " 

    try
    {
        Compress-Archive -Path $ExportDirName[0] -DestinationPath $ExportDirName[0] -CompressionLevel Optimal
    }
    catch
    {
        Write-Host -ForegroundColor Red "[!] Compression Failed - Consider manual compression " ; Start-Sleep -Seconds 1
    }

    Set-Location -Path $origin

    try
    {
        Write-Host -ForegroundColor Yellow "[*] Removing original export directory... " ; Start-Sleep -Seconds 1

        Remove-Item -Force -Recurse -Path $ExportDirName[0] -Confirm:$false | Out-Null

        Write-Host -ForegroundColor Green "[*] Original export directory removed "
    }
    catch
    {
        Write-Host -ForegroundColor Red "[!] Failed to remove the export directory " ; Start-Sleep -Seconds 1
    }

    Write-Host -ForegroundColor Green "[*] Event Log export complete " ; Start-Sleep -Seconds 1
}

function CheckFileSizes()
{
    <# Walk the file system and check for files larger than 10MB #>

    $computerName = $env:COMPUTERNAME

    Write-Host -ForegroundColor Green "[*] Searching for large files..."

    $timeStamp = Get-Date -Format "dddd_MM_dd_yyyy_HH_mm_ss"

    $FileName = "LF_"+$computerName+'_'+$timeStamp+'.txt'  

    $largeFiles = @()

    New-Item -ItemType Directory -Path . -Name 'LargeFiles' | Out-Null

    Set-Location -Path 'LargeFiles'

    Write-Host -ForegroundColor Green "[*] Walking the file system in search of large files (> 10MB) "

    Get-ChildItem -Path "C:\" -Force -Recurse  | Foreach-Object { 
                                                                   
                                                                   if($_ -isnot [System.IO.DirectoryInfo])
                                                                   {
                                                                
                                                                        $file = $_.FullName
                                                                        $fileSize = $_.length/1MB

                                                                        # Write-Host -ForegroundColor Yellow "$file : $fileSize" 

                                                                        if($fileSize -ge 10)
                                                                        {
                                                                              #Write-Host -ForegroundColor Red "[*] File: $file is size: $fileSize "
                                                                              $largeFiles += $file
                                                                        }
                                                                                                          
                                                                    }  

                                                                  }

    $largeFiles | Foreach-Object {
                                    $file = $_
                                    $file | Out-File -Append -FilePath $fileName
                                 }

    Write-Host -ForegroundColor Green "[*] Finished exporting non-standard or 3rd Party logs "

    Set-Location -Path ..

}

function CollectNonStandardLogs()
{
    Write-Host -ForegroundColor Green "[*] Collectin non-standard or 3rd Party logs..."

    New-Item -ItemType Directory -Path . -Name "OtherLogs" | Out-Null

    Set-Location -Path "OtherLogs"

    $computerName = $env:COMPUTERNAME

    $timeStamp = Get-Date -Format "dddd_MM_dd_yyyy_HH_mm_ss"

    $FileName = "NS_Logs_"+$computerName+'_'+$timeStamp+'.txt' 

    Get-ChildItem -Path C:\ -Recurse -Force -ErrorAction SilentlyContinue -Include *.log | Foreach-Object { Copy-Item -Path $_.FullName -Destination . } 

    Set-Location -Path ..

}
function main()
{
   Write-Host -ForegroundColor Green "[*] Incident Response Endpoint Assessment Script "

   $mainDirectory = CreateMainDirectory 

   GatherWinEventLogs

   $reportDirectory = CreateReportDirectory

   CreateReports

   CheckFileSizes

   CollectNonStandardLogs

   Set-Location -Path ..

    try 
    {
        Write-Host -ForegroundColor Green "[*] Compressing the archive..."

        Compress-Archive -Path .\$mainDirectory -DestinationPath .\$mainDirectory -CompressionLevel Optimal

        Write-Host -ForegroundColor Green "[*] Removing the original directory... "

        Remove-Item -Path $mainDirectory -Force -Recurse | Out-Null
    }
    catch 
    {
        Write-Host -ForegroundColor Red "[!] Failed to compress archive "
    }
    
    $compressedDirectory = $mainDirectory+'.zip'

    $checkCompressedDir = Test-Path $compressedDirectory

    if($checkCompressedDir)
    {
        Write-Host -ForegroundColor Green "[*] Located the compressed directory "

        try 
        {
            Write-Host -ForegroundColor Green "[*] Mailing Archive "

            Send-MailMessage -To "robert.gaines@wsu.edu" `
                             -From "endpoint.assessment@wsu.edu" `
                             -Subject "Endpoint Report - $env:COMPUTERNAME " `
                             -Body "See attached directory for $env:COMPUTERNAME's incident report data." `
                             -SmtpServer "smtp.wsu.edu" `
                             -UseSsl:$false `
                             -Attachments $compressedDirectory

            Write-Host -ForegroundColor Green "[*] Archive successfully transmitted "
        }
        catch 
        {
            Write-Host -ForegroundColor Red "[!] Failed to transmit the archive "    
        }
    }
    else 
    {
        Write-Host -ForegroundColor Red "[!] Failed to locate the compressed directory "    
    }

    Start-Sleep -Seconds 3

    Clear-Host
}

main