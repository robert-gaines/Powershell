# Script iterates through the file system, generating hashes of accessible files #

$ErrorActionPreference = "SilentlyContinue"
function GenerateHashes()
{
    $hashArray = New-Object System.Collections.ArrayList

    $timeStamp = Get-Date -Format o | Foreach-Object{ $_ -replace ":",'.' } 

    $currentPath = Get-Location ; $fileName = [System.String]::Concat("\FS-Hashes",$timeStamp+"_.csv")

    $filePath = [System.String]::Concat($currentPath,$fileName) 

    Get-ChildItem -Path "C:\Users\rgaines\Desktop" -Recurse -Force | Get-FileHash | Export-CSV $filePath

    return
}
function CompareHashes()
{
    $timeStamp = Get-Date -Format o | Foreach-Object{ $_ -replace ":",'.' }

    $currentPath = Get-Location 
    
    $fileName = [System.String]::Concat("\FS-Check-Results-",$timeStamp+"_.csv")

    $filePath = [System.String]::Concat($currentPath,$fileName)

    Write-Host "[*] Listing computed hash files..."

    Start-Sleep -Seconds 1 

    Get-ChildItem | Foreach-Object { Write-Host -ForegroundColor Yellow $_.Name }

    $baseLineFile = Read-Host "[+] Enter the baseline file name "

    $comparisonFile = Read-Host "[+] Enter the complete file name "

    Write-Host -ForegroundColor Yellow "[*] Checking baseline and current hash record..."

    Compare-Object (Get-Content $baseLineFile)(Get-Content $comparisonFile) | Format-Table -Wrap | Out-File $filePath

    if((Get-Content $filePath) -eq $Null)
    {
        Write-Host -ForegroundColor Blue "[*] No file integrity anomalies detected [*]"
    }
    else
    {
        Write-Host -ForegroundColor Red "[!] Anomalies detected [!]"

        Get-Content $filePath
    }
}

function main()
{
    #GenerateHashes

    CompareHashes
}

main