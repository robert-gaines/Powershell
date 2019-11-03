# Script iterates through the file system, generating hashes of accessible files #

$ErrorActionPreference = "SilentlyContinue"
function GenerateHashes()
{
    Write-Host -ForegroundColor Yellow "[*] Hashing file system contents..."

    $timeStamp = Get-Date -Format o | Foreach-Object{ $_ -replace ":",'.' } 

    $currentPath = Get-Location ; $fileName = [System.String]::Concat("\FS-Hashes",$timeStamp+"_.csv")

    $filePath = [System.String]::Concat($currentPath,$fileName) 

    Get-ChildItem -Path "C:\" -Recurse -Force | Get-FileHash | Export-CSV $filePath

    return
}
function CompareHashes()
{
    Write-Host -ForegroundColor Yellow "[*] Hash file comparison function invoked [*]"

    $timeStamp = Get-Date -Format o | Foreach-Object{ $_ -replace ":",'.' }

    $currentPath = Get-Location 
    
    $fileName = [System.String]::Concat("\FS-Check-Results-",$timeStamp+"_.csv")

    $filePath = [System.String]::Concat($currentPath,$fileName)

    Write-Host -ForegroundColor Yellow "[*] Listing computed hash files..."

    Start-Sleep -Seconds 1 

    Get-ChildItem | Foreach-Object { Write-Host -ForegroundColor Yellow $_.Name }

    $baseLineFile = Read-Host "[+] Enter the baseline file name "

    $comparisonFile = Read-Host "[+] Enter the name of the file to be compared "

    Write-Host -ForegroundColor Yellow "[*] Checking baseline and current hash record..."

    Compare-Object (Get-Content $baseLineFile)(Get-Content $comparisonFile) | Format-Table -Wrap | Out-File $filePath

    if((Get-Content $filePath) -eq $Null)
    {
        Write-Host -ForegroundColor Blue "[*] No file integrity anomalies detected [*]"
    }
    else
    {
        Write-Host -ForegroundColor Red "[!] Anomalies detected [!]"

        Start-Sleep -Seconds 1

        Write-Host -ForegroundColor Red "[*] Listing modified entries..."

        Get-Content $filePath
    }
}

function main()
{
    Write-Host -ForegroundColor Blue "

[*] File System Integrity Checker [*]
-------------------------------------
Options:
-------
1) Generate Hashes
2) Compare Against Baseline
3) Exit

    "
    $option = Read-Host "[+] Selection-> "

    Switch($option)
    {
        1{GenerateHashes}
        2{CompareHashes}
        3{exit}
        default{exit}
    }
}

main