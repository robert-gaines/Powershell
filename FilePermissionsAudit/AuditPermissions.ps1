# Audit Local Windows File Permissions #

$ErrorActionPreference = "SilentlyContinue"
function main()
{
    $timeStamp = Get-Date -Format o | Foreach-Object{ $_ -replace ":",'.' }

    $hostString = $env:ComputerName 

    $fileName = "Permissions_"+$hostString+"_"+$timeStamp+".txt"

    Write-Host -ForegroundColor Yellow "[*] Gathering file permissions for-> ",$fileName

    Get-ChildItem -Path "C:\" -Force -Recurse | ForEach-Object { Get-ACL -Path $_.FullName | Select-Object Owner,Path,AccessToString | Format-List } | Out-File $fileName

    Write-Host -ForegroundColor Green "[*] Finished. Permissions documented in: ",$fileName

    Start-Sleep -Seconds 1
}

main

