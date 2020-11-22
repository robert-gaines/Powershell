$ErrorActionPreference = 'SilentlyContinue'

<# Author: RWG #>

function GenerateDirectoryName($computerName)
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
                                    Get-EventLog -LogName $_.Log | Export-CSV -Path $filePath

                                    Write-Host -ForegroundColor Green "[*] Export complete: $directory "
                                }
                                catch 
                                {
                                    Write-Host -ForegroundColor Red "[!] Failed to export: $directory "
                                }
                           }

    Write-Host -ForegroundColor Green "[*] Windows Event Viewer Log Export Complete! " ; Start-Sleep -Seconds 3
}

function CreateExportDirectory()
{
    $exportPath = (Get-Location).Path

    $computerName = $env:COMPUTERNAME

    $dirName = GenerateDirectoryName $computerName

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

function main()
{
    $origin = (Get-Location).Path

    Write-Host -ForegroundColor Green "[*] Windows Event Log Exporter "

    $ExportDirName = CreateExportDirectory

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

    Write-Host -ForegroundColor Green "[*] Script complete - departing " ; Start-Sleep -Seconds 1 ; exit
}

main