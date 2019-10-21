# Back Up User's Files to External Media #

$ErrorActionPreference = "SilentlyContinue"
function MakeBackupDirectory($target,$origin)
{
    Write-Host -ForegroundColor Yellow "[*] Transitioning to backup target $target [*]"
    try{
        Set-Location $target

        $timeStamp = Get-Date -Format o | Foreach-Object{ $_ -replace ":",'.' }

        $backupDirectoryName = "Backup_"+$timeStamp

        $backupPath = $target+$backupDirectory

        New-Item -ItemType "Directory" -Path $backupPath

        Set-Location $origin
    }
    catch
    {
        Write-Host -ForegroundColor Red "[!] Failed to switch directories [!]"

        return
    }
}

Write-Host -ForegroundColor Yellow "[*] Gathering volumes..." ; Start-Sleep(1)

Get-Volume | Format-Table DriveLetter,FileSystem,SizeRemaining

$targetVolume = Read-Host "[+] Enter the volume drive letter" ; $backupTarget = ""

try {
    $backupTarget = Get-Volume -DriveLetter $targetVolume

    Write-Host -ForegroundColor Green "[*] Located Volume: ", $backupTarget.DriveLetter 

    $backupTarget = $backupTarget + ":\"
}
catch {
    Write-Host -ForegroundColor Red "[!] Failed to locate volume [!]"  
}

Write-Host -ForegroundColor yellow "[*] Gathering user and directory data [*]" ; Start-Sleep -Seconds 1

try {
    $currentUser = $env:USERNAME

    Write-Host -ForegroundColor Green "[*] Located user: ", $currentUser
}
catch {
    Write-Host -ForegroundColor Red "[!] Failed to identify user [!]"
}

$fileSystemRoot = "C:\Users\$currentUser"

Write-Host -ForegroundColor Blue "[*] Starting at-> ", $fileSystemRoot ; Start-Sleep -Seconds 1

MakeBackupDirectory($backupTarget,$fileSystemRoot)

#Set-Location $fileSystemRoot 

#Get-ChildItem -Force -Recurse | Foreach-Object{Write-Host $_.FullName ; Start-Sleep -Seconds 1}




