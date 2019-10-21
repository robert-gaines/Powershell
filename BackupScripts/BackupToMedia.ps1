# Back Up User's Files to External Media #

$ErrorActionPreference = "SilentlyContinue"

Write-Host -ForegroundColor Yellow "
------------------------------------
|    Backup To External Media      |
|    Author: RWG                   |
------------------------------------ 
           "

function MakeBackupDirectory($backupDirectory)
{
    Write-Host -ForegroundColor Yellow "[*] Creating the backup directory [*]"

    try{
        # Get the date and time and then format for use as a timestamp #

        $timeStamp = Get-Date -Format o | Foreach-Object{ $_ -replace ":",'.' }

        # Assign time stamped identifier to the backup directory

        $backupDirectoryName = "Backup_"+$timeStamp

        $backupTargetName =  $backupDirectory.DriveLetter+":\"+$backupDirectoryName

        # Create the backup directory on the external media device #

        Write-host -ForegroundColor Yellow "[~] Attempting creation of: ", $backupTargetName

        $bd = New-Item -ItemType "Directory" -Path $backupTargetName

        if($bd)
        {
            Write-Host -ForeGroundColor Green "[*] Backup directory created at: ", $backupTargetName
            #
            return $backupTargetName
        }
    }
    catch
    {
        Write-Host -ForegroundColor Red "[!] Failed to create directory [!]"

        exit
    }
}

function main()
{
    # Identify all active volumes #

    Write-Host -ForegroundColor Yellow "[*] Gathering volumes..." ; Start-Sleep -Seconds 1

    # List the Driv Letter, File System Type, and the total size remaining

    Get-Volume | Format-Table DriveLetter,FileSystem,SizeRemaining

    $targetVolume = Read-Host "[+] Enter the volume drive letter" 

    try {
        $backupTarget = Get-Volume -DriveLetter $targetVolume

        Write-Host -ForegroundColor Green "[*] Located Volume: ", $backupTarget.DriveLetter 
    }
    catch {
        Write-Host -ForegroundColor Red "[!] Failed to locate volume [!]"  

        exit
    }

    $backupTarget = $backupTarget.DriverLetter.ToString()

    Write-Host -ForegroundColor yellow "[*] Gathering user and directory data [*]" ; Start-Sleep -Seconds 1

    try {
        $currentUser = $env:USERNAME

        Write-Host -ForegroundColor Green "[*] Located user: ", $currentUser
    }
    catch {
        Write-Host -ForegroundColor Red "[!] Failed to identify user [!]"

        exit
    }

    $userFileSystemRoot = "C:\Users\$currentUser"

    Write-Host -ForegroundColor Blue "[*] Starting at-> ", $userFileSystemRoot ; Start-Sleep -Seconds 1

    $backupDirectory = MakeBackupDirectory($backupTarget)

    Write-Host -ForegroundColor Yellow "[*] Relocating to the root of the user file system [*]"

    Set-Location $userFileSystemRoot 

    $userDirectories = @(Get-ChildItem $userFileSystemRoot) ; $dirCount = $userDirectories.Length

    for($i = 0; $i -lt $dirCount; $i++)
    {
        $absPath = $userFileSystemRoot+'\'+$userDirectories[$i]
    
        Write-Progress -Activity "[*] Backing up user files..." -CurrentOperation -Completed -Status "$i% Complete" -PercentComplete $i

        Write-Host -ForegroundColor Blue "[*] Backing up: `t`t", $absPath, "`t`t ==>> `t`t", $backupDirectory

        Copy-Item -Path $absPath -Destination $backupDirectory -Recurse
    }
    Write-Host -ForegroundColor "[*] Backup Complete [*]"
}

main