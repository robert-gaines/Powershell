
function main()
{
    Write-Host -ForegroundColor Green "[*] Network Backup Script "

    Start-Sleep -Seconds 1

    Write-Host -ForegroundColor Yellow "[~] Remote Workers: Please ensure that you are connected to the campus VPN "

    try
    {
            Write-Host -ForegroundColor Yellow "[~] Checking for Z drive connectivity..." ; Start-Sleep -Seconds 1

            $drive = Get-WMIObject -Class Win32_LogicalDisk | Where-Object { $_.DeviceID -eq 'Z:'  }

            if($drive)
            {
                Write-Host -ForegroundColor Green "[*] Z drive is present on the system "
            }
            else 
            {
                Write-Host -ForegroundColor Red "[!] Failed to identify the Z drive "
                
                Start-Sleep -Seconds 3

                exit
            }
    }
    catch 
    {
            Write-Host -ForegroundColor Red "[!] Failed to identify the network drive "

            Start-Sleep -Seconds 3

            exit
    }

    <# Backup Parameters #>

    $timestamp = Get-Date -Format "MM_dd_yyyy_hh_mm_ss"

    $timestamp = $timestamp.ToString()

    $backup_directory = $drive.DeviceID+"\"+$env:USERNAME+"_backup_"+$timestamp

    Write-Host -ForegroundColor Yellow "[*] Backup directory: $backup_directory "

    try 
    {
        $create_backup_dir = New-Item -Type Directory -Path $backup_directory -Verbose:$true
    }
    catch 
    {
        Write-Host -ForegroundColor Red "[!] Failed to create backup directory "
        
        Start-Sleep -Seconds 3

        exit
    }
    
    if($create_backup_dir)
    {
        Write-Host -ForegroundColor Green "[*] Created Backup Directory on the Z Drive"
    }
    else 
    {
        Write-Host -ForegroundColor Red "[!] Failed to create backup directory..."
        
        Start-Sleep -Seconds 1

        exit
    }

    try 
    {
        Write-Host -ForegroundColor Yellow "[*] Attempting backup of: C:\Users\$env:USERNAME "
        
        Copy-Item -Path C:\Users\$env:USERNAME -Destination $backup_directory -Force -Recurse -Verbose:$true

        Clear-Host

        Write-Host -ForegroundColor Green "[*] Backup Operation Complete "

        Start-Sleep -Seconds 3

        exit
    }
    catch 
    {
        Write-Host -ForegroundColor Red "[!] Failed to perform backup operation "
        
        Start-Sleep -Seconds 3

        exit
    }
}

main