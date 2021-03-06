$ErrorActionPreference = 'SilentlyContinue'

function GatherData()
{
    $current_user = $env:USERNAME
    
    $interfaces   =  @((Get-WMIObject Win32_NetworkAdapterConfiguration | Where-Object { $_.IPAddress }).Description)
    $addresses    =  @((Get-WMIObject Win32_NetworkAdapterConfiguration | Where-Object { $_.IPAddress }).IPAddress)
    $subnet_masks = @((Get-WMIObject Win32_NetworkAdapterConfiguration | Where-Object { $_.IPAddress }).IPSubnet)
    $gateways     = @((Get-WMIObject Win32_NetworkAdapterConfiguration | Where-Object { $_.IPAddress }).DefaultIPGateway)

    $base_filename = $current_user+"_" 
    $network_conf  = $base_filename+"network.csv"

    for($i = 0; $i -lt $interfaces.Length; $i++)
    {
        $interface = $interfaces[$i]
        $address   = $addresses[$i]
        $mask      = $subnet_masks[$i]
        $gateway   = $gateways[$i]
        
        Write-Host -ForegroundColor Green "[*] Identified Network Adapter: $interface -> $address -> $mask "
        "$interface,$address,$mask,$gateway" | Out-File -Append -FilePath $network_conf
    }
    
    Write-Host -ForegroundColor Green "[*] Network Configuration written to: $network_conf "
    
    $unc_values = @()
    $drive_letters = @()
    
    Get-WMIObject Win32_NetworkConnection | Foreach-Object {
                                                                 $unc = $_.RemoteName
                                                                 $drive_letter = $_.LocalName
                                                                 
                                                                 $unc_values += $unc
                                                                 $drive_letters += $drive_letter
                                                           } 
                                           
   $drive_configuration = $base_filename+"mapped_drives.csv"
                                                           
   for($k = 0; $k -lt $drive_letters.Length; $k++)
   {
        $current_drive = $drive_letters[$k]
        $current_unc   = $unc_values[$k]
        Write-Host -ForegroundColor Green "[*] Located drive letter: $current_drive -> $current_unc"
        "$current_drive,$current_unc" | Out-File -Append $drive_configuration
   }  
   
   Write-Host -ForegroundColor Green "[*] Drive configuration written to: $drive_configuration "
   
   $printers = @()

   $printer_configuration = $base_filename+"mapped_printers.csv"

   Get-WMIObject Win32_Printer | Where-Object {$_.Name -ne 'Fax' -and $_.Name -ne 'Microsoft XPS Document Writer'} | Foreach-Object { 
                                                                                                                                        $printer = $_.DeviceID
                                                                                                                                        $printer | Out-File -Append -FilePath $printer_configuration
                                                                                                                                        $printers += $printer
                                                                                                                                    }
   
   $printers | Foreach-Object { $entry = $_ ; Write-Host -ForegroundColor Green "[*] Located: $entry " } 
   
   Write-Host -ForegroundColor Green "[*] Printer configuration written to: $printer_configuration "
   
   $test_user_drive = Test-Path -Path "Z:"
   
   if($test_user_drive)
   {
        Write-Host -ForegroundColor Green "[*] Z drive is accessible ..."
   }
   else
   {
        Write-Host -ForegroundColor Red "[!] Z drive is inaccessible..."
        exit
   }
   
   $migrationDirectory     = $base_filename+"backup"
   $configurationDirectory = $base_filename+"configuration"
   
   $existing_migration_dir     = Test-Path  -Path "Z:\$migrationDirectory"
   $existing_configuration_dir = Test-Path  -Path "Z:\$configurationDirectory"
   
   if($existing_migration_dir)
   {
        Write-Host -ForegroundColor Red "[!] Existing migration directory detected [!]"
        Remove-Item -Path "Z:\$migrationDirectory" -Force -Recurse -Confirm:$true
   }
   if($existing_configuration_dir)
   {
        Write-Host -ForegroundColor Red "[!] Existing configuration directory detected [!]"
        Remove-Item -Path "Z:\$configurationDirectory" -Force -Recurse -Confirm:$true
   }
   
   try
   {   
       Write-Host -ForegroundColor Yellow "[+] Attempting creation of the migration directory..."
       New-Item   -ItemType Directory -Path "Z:\$migrationDirectory" -Verbose:$false
       Write-Host -ForegroundColor Green "[*] Created: $migrationDirectory "
       Write-Host -ForegroundColor Yellow "[+] Attempting creation of the configuration data directory..."
       New-Item   -ItemType Directory -Path "Z:\$configurationDirectory" -Verbose:$false 
       Write-Host -ForegroundColor Green "[*] Created: $configurationDirectory "
   }
   catch
   {
       Write-Host -ForegroundColor Red "[!] Failed to create an essential directory..."
       exit
   }
   
   Write-Host -ForegroundColor Yellow "[+] Transferring configuration files to the networked directory..."
   
   try
   {
        Copy-Item -Path $network_conf          -Destination "Z:\$configurationDirectory"
        Copy-Item -Path $drive_configuration   -Destination "Z:\$configurationDirectory" 
        Copy-Item -Path $printer_configuration -Destination "Z:\$configurationDirectory"
        Write-Host -ForegroundColor Green "[*] Configuration files were successfully transferred "
        Write-Host -ForegroundColor Red "[*] Removing local configuration files..."
        Remove-Item -Path $network_conf          -Force
        Remove-Item -Path $drive_configuration   -Force
        Remove-Item -Path $printer_configuration -Force
        Write-Host -ForegroundColor Green "[*] Configuration transfer complete "
   }
   catch
   {
        Write-Host -ForegroundColor Red "[!] Failed to transfer the necessary configuration files..."
        exit
   }
   $destinationDirectory = "Z:\$migrationDirectory"

   return $destinationDirectory
}

function TransferProfile()
{
    $current_user          = $env:USERNAME 
    $migration_dir         = "Z:\"+$current_user+"_backup"
    $current_user_dir_root = "C:\Users\$current_user" 
    $test_user_fs_root     = Test-Path -Path $current_user_dir_root 
    $test_migration_dir    = Test-Path -Path $migration_dir 
    
    if($test_user_fs_root -and $test_migration_dir)
    {
        Write-Host -ForegroundColor Green "[*] Source and destination connectivity established "
    } 
    else
    {
        Write-Host -ForegroundColor Red "[!] Failed to establish connectivity with either the source or destination directory..."
        exit
    }
    
    Write-Host -ForegroundColor Yellow "[~] Copying the user profile to the migration directory..."
    
    Copy-Item -Path $current_user_dir_root -Destination $migration_dir -Force -Recurse -Verbose:$false
    
    Write-Host -ForegroundColor Green "[*] Finished backing up user profile to the network share "
    
    Write-Host -ForegroundColor Green "[*] Departing "
}

function main()
{   
    Write-Host -ForegroundColor Green "[*] Windows 7 Migration - Preparation Script "

    $target_dir = GatherData 
    
    $migration_dir = $target_dir.ToString()
    
    TransferProfile $migration_dir
}

main