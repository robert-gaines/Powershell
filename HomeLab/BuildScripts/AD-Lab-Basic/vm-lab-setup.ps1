<# VM Lab Setup Script #>

<# Install DC and Subordinate Hosts #>

function CreateSwitches
{
    $adapter = Get-NetAdapter | Where-Object Name -Like "Ethernet"
    
    $extAdapter = $adapter.Name

    try
    {
        Write-Host -ForegroundColor Yellow "[*] Setting up the external switch ..."

        New-VMSwitch -Name "EXT-MAIN" -NetAdapterName $extAdapter 

        Write-Host -ForegroundColor Green "[*] External Switch Created "
        
        Write-Host -ForegroundColor Yellow "[*] Setting up the main internal switch ..."
        
        New-VMSwitch -Name "INT-MAIN" -SwitchType Internal
        
        Write-Host -ForegroundColor Green "[*] Main Internal Switch Created " 

        Write-Host -ForegroundColor Yellow "[*] Setting up the alternate internal switch ..."
        
        New-VMSwitch -Name "INT-ALT" -SwitchType Internal

        Write-Host -ForegroundColor Green "[*] Alternate Internal Switch Created "
        
        Write-Host -ForegroundColor Yellow "[*] Setting up the cluster internal switch ..."
        
        New-VMSwitch -Name "INT-CLUSTER" -SwitchType Internal

        Write-Host -ForegroundColor Green "[*] Cluster Switch Created "
        
        Write-Host -ForegroundColor Yellow "[*] Setting up the private switch ..."  

        New-VMSwitch -Name "PRI-MAIN" -SwitchType Private

        Write-Host -ForegroundColor Green "[*] Private Switch Created "
    }
    catch
    {
        WRite-Host -ForegroundColor Red "[!] Failed to set up a virtual switch [!]"
    }
}

function CreateVM
{
    $currentUser = $env:USERNAME

    New-Item -ItemType Directory -Path C:\Users\$currentUser\Desktop\Lab\Storage-VHD
    New-Item -ItemType Directory -Path C:\Users\$currentUser\Desktop\Lab\VHD

    try
    {
        Write-Host -ForegroundColor Yellow "[*] Creating VM: WIN-M-DC "

        New-Item -ItemType Directory -Path "C:\Users\$currentUser\Desktop\Lab\VHD\WIN-M-DC" | Out-Null

        Import-VM -Path "C:\Users\$currentuser\Desktop\Lab\Source-VHD\DC-Disk\Virtual Machines\44F18249-B76C-4AC3-88D0-297B5F247B1D.vmcx" `
                  -Copy -GenerateNewId -SmartPagingFilePath "C:\Users\$currentUser\Desktop\Lab\VHD\WIN-M-DC\" `
                  -SnapshotFilePath   "C:\Users\$currentUser\Desktop\Lab\VHD\WIN-M-DC\" `
                  -VhdDestinationPath "C:\Users\$currentUser\Desktop\Lab\VHD\WIN-M-DC\" `
                  -VirtualMachinePath "C:\Users\$currentUser\Desktop\Lab\VHD\WIN-M-DC\"

        Rename-VM "DC-Disk" -NewName "WIN-M-DC"

        Remove-VMDVDDrive -VMName "WIN-M-DC" -ControllerNumber 0 -ControllerLocation 1

        $coreList = @('WIN-M-CE-1','WIN-M-CE-2','WIN-M-CE-3','WIN-M-CE-4')

        $desktopList = @('WIN-M-DTP-1','WIN-M-DTP-2')

        $coreList | Foreach-Object { 
                                        Write-Host -ForegroundColor Yellow "[*] Creating VM: $_ "

                                        New-Item -ItemType directory -Path "C:\Users\$currentUser\Desktop\Lab\VHD\$_" | Out-Null

                                        Import-VM -Path "C:\Users\$currentUser\Desktop\Lab\Source-VHD\Core-Disk\Virtual Machines\8232ED6A-DB9C-40E9-BB55-5856F38EB862.vmcx" `
                                                  -Copy -GenerateNewId -SmartPagingFilePath "C:\Users\$currentUser\Desktop\Lab\VHD\$_" `
                                                  -SnapshotFilePath   "C:\Users\$currentUser\Desktop\Lab\VHD\$_\" `
                                                  -VhdDestinationPath "C:\Users\$currentUser\Desktop\Lab\VHD\$_\" `
                                                  -VirtualMachinePath "C:\Users\$currentUser\Desktop\Lab\VHD\$_\"

                                        Rename-VM "Core-Disk" -NewName $_

                                        Remove-VMDVDDrive -VMName $_ -ControllerNumber 0 -ControllerLocation 1
                                    }

        $desktopList | Foreach-Object { 
                                        New-Item -ItemType directory -Path "C:\Users\$currentUser\Desktop\Lab\VHD\$_" | Out-Null

                                        Import-VM -Path "C:\Users\$currentuser\Desktop\Lab\Source-VHD\Desktop-Disk\Virtual Machines\692D5807-E61C-48A9-95DB-303966419803.vmcx" `
                                                  -Copy -GenerateNewId -SmartPagingFilePath "C:\Users\$currentUser\Desktop\Lab\VHD\$_" `
                                                  -SnapshotFilePath   "C:\Users\$currentUser\Desktop\Lab\VHD\$_\" `
                                                  -VhdDestinationPath "C:\Users\$currentUser\Desktop\Lab\VHD\$_\" `
                                                  -VirtualMachinePath "C:\Users\$currentUser\Desktop\Lab\VHD\$_\"

                                        Rename-VM "Desktop-Disk" -NewName $_

                                        Remove-VMDVDDrive -VMName $_ -ControllerNumber 0 -ControllerLocation 1
                           }
            <#

            New-VM -Name "WIN-M-DC"    -MemoryStartupBytes 2GB   -Generation 2 -NoVHD
            New-VM -Name "WIN-M-CE-1"  -MemoryStartupBytes 512MB -Generation 2 -NoVHD
            New-VM -Name "WIN-M-CE-2"  -MemoryStartupBytes 512MB -Generation 2 -NoVHD
            New-VM -Name "WIN-M-CE-3"  -MemoryStartupBytes 512MB -Generation 2 -NoVHD
            New-VM -Name "WIN-M-CE-4"  -MemoryStartupBytes 512MB -Generation 2 -NoVHD
            New-VM -Name "WIN-M-DTP-1" -MemoryStartupBytes 2GB   -Generation 2 -NoVHD
            New-VM -Name "WIN-M-DTP-2" -MemoryStartupBytes 2GB   -Generation 2 -NoVHD

            Copy-Item -Path C:\Users\$currentUser\Desktop\Lab\Source-VHD\Desktop-Machine.vhdx -Destination C:\Users\$currentUser\Desktop\Lab\VHD\WIN-M-DC.vhdx
            Copy-Item -Path C:\Users\$currentUser\Desktop\Lab\Source-VHD\Desktop-Machine.vhdx -Destination C:\Users\$currentUser\Desktop\Lab\VHD\WIN-M-DTP-1.vhdx
            Copy-Item -Path C:\Users\$currentUser\Desktop\Lab\Source-VHD\Desktop-Machine.vhdx -Destination C:\Users\$currentUser\Desktop\Lab\VHD\WIN-M-DTP-2.vhdx
            Copy-Item -Path C:\Users\$currentUser\Desktop\Lab\Source-VHD\Core-Machine.vhdx -Destination C:\Users\$currentUser\Desktop\Lab\VHD\WIN-M-CE-1.vhdx
            Copy-Item -Path C:\Users\$currentUser\Desktop\Lab\Source-VHD\Core-Machine.vhdx -Destination C:\Users\$currentUser\Desktop\Lab\VHD\WIN-M-CE-2.vhdx
            Copy-Item -Path C:\Users\$currentUser\Desktop\Lab\Source-VHD\Core-Machine.vhdx -Destination C:\Users\$currentUser\Desktop\Lab\VHD\WIN-M-CE-3.vhdx
            Copy-Item -Path C:\Users\$currentUser\Desktop\Lab\Source-VHD\Core-Machine.vhdx -Destination C:\Users\$currentUser\Desktop\Lab\VHD\WIN-M-CE-4.vhdx

            Add-VMHardDiskDrive -ControllerType SCSI -ControllerNumber 0 -VMName "WIN-M-DC"    -Path C:\Users\robert.gaines\Desktop\Lab\VHD\WIN-M-DC.vhdx
            Add-VMHardDiskDrive -ControllerType SCSI -ControllerNumber 0 -VMName "WIN-M-CE-1"  -Path C:\Users\robert.gaines\Desktop\Lab\VHD\WIN-M-CE-1.vhdx
            Add-VMHardDiskDrive -ControllerType SCSI -ControllerNumber 0 -VMName "WIN-M-CE-2"  -Path C:\Users\robert.gaines\Desktop\Lab\VHD\WIN-M-CE-2.vhdx
            Add-VMHardDiskDrive -ControllerType SCSI -ControllerNumber 0 -VMName "WIN-M-CE-3"  -Path C:\Users\robert.gaines\Desktop\Lab\VHD\WIN-M-CE-3.vhdx
            Add-VMHardDiskDrive -ControllerType SCSI -ControllerNumber 0 -VMName "WIN-M-CE-4"  -Path C:\Users\robert.gaines\Desktop\Lab\VHD\WIN-M-CE-4.vhdx
            Add-VMHardDiskDrive -ControllerType SCSI -ControllerNumber 0 -VMName "WIN-M-DTP-1" -Path C:\Users\robert.gaines\Desktop\Lab\VHD\WIN-M-DTP-1.vhdx
            Add-VMHardDiskDrive -ControllerType SCSI -ControllerNumber 0 -VMName "WIN-M-DTP-2" -Path C:\Users\robert.gaines\Desktop\Lab\VHD\WIN-M-DTP-2.vhdx

            #>

            Write-Host -ForegroundColor Green "[+] Modifying startup memory ..."

            $coreList | Foreach-Object { 
                                            Set-VMMemory -StartupBytes 512MB -VMName $_ 
                                       }

            $desktopList | Foreach-Object { 
                                            Set-VMMemory -StartupBytes 2GB -VMName $_ 
                                       }
            <#
            Write-Host -ForegroundColor Yellow "[+] Setting boot devices ..."

            $hardDriveDC   =   (Get-VMFirmware -VMName WIN-M-DC).BootOrder[1]
            $hardDriveCE1  =   (Get-VMFirmware -VMName WIN-M-CE-1).BootOrder[1]
            $hardDriveCE2  =   (Get-VMFirmware -VMName WIN-M-CE-2).BootOrder[1]
            $hardDriveCE3  =   (Get-VMFirmware -VMName WIN-M-CE-3).BootOrder[1]
            $hardDriveCE4  =   (Get-VMFirmware -VMName WIN-M-CE-4).BootOrder[1]
            $hardDriveDTP1 =   (Get-VMFirmware -VMName WIN-M-DTP-1).BootOrder[1]
            $hardDriveDTP2 =   (Get-VMFirmware -VMName WIN-M-DTP-2).BootOrder[1]

            Set-VMFirmware -VMName "WIN-M-DC"    -FirstBootDevice $hardDriveDC
            Set-VMFirmware -VMName "WIN-M-CE-1"  -FirstBootDevice $hardDriveCE1
            Set-VMFirmware -VMName "WIN-M-CE-2"  -FirstBootDevice $hardDriveCE2
            Set-VMFirmware -VMName "WIN-M-CE-3"  -FirstBootDevice $hardDriveCE3
            Set-VMFirmware -VMName "WIN-M-CE-4"  -FirstBootDevice $hardDriveCE4
            Set-VMFirmware -VMName "WIN-M-DTP-1" -FirstBootDevice $hardDriveDTP1
            Set-VMFirmware -VMName "WIN-M-DTP-2" -FirstBootDevice $hardDriveDTP2 #>

    }
    catch
    {
            Write-Host -ForegroundColor Red "[!] Failed to create VM [!]" 
    }

    Write-Host -ForegroundColor Green "[*] VM's Created "

    Write-Host -ForegroundColor Yellow "[+] Creating Supplementary Storage ..."

    try
    {
        New-VHD -Path C:\Users\$currentUser\Desktop\Lab\Storage-VHD\storage-one.vhdx   -SizeBytes 10GB -Dynamic -LogicalSectorSizeBytes 4096 | Out-Null
        New-VHD -Path C:\Users\$currentUser\Desktop\Lab\Storage-VHD\storage-two.vhdx   -SizeBytes 10GB -Dynamic -LogicalSectorSizeBytes 4096 | Out-Null
        New-VHD -Path C:\Users\$currentUser\Desktop\Lab\Storage-VHD\storage-three.vhdx -SizeBytes 10GB -Dynamic -LogicalSectorSizeBytes 4096 | Out-Null
        New-VHD -Path C:\Users\$currentUser\Desktop\Lab\Storage-VHD\storage-four.vhdx  -SizeBytes 10GB -Dynamic -LogicalSectorSizeBytes 4096 | Out-Null
        New-VHD -Path C:\Users\$currentUser\Desktop\Lab\Storage-VHD\storage-five.vhdx  -SizeBytes 10GB -Dynamic -LogicalSectorSizeBytes 4096 | Out-Null
        New-VHD -Path C:\Users\$currentUser\Desktop\Lab\Storage-VHD\storage-six.vhdx   -SizeBytes 10GB -Dynamic -LogicalSectorSizeBytes 4096 | Out-Null
        New-VHD -Path C:\Users\$currentUser\Desktop\Lab\Storage-VHD\storage-seven.vhdx -SizeBytes 10GB -Dynamic -LogicalSectorSizeBytes 4096 | Out-Null
        New-VHD -Path C:\Users\$currentUser\Desktop\Lab\Storage-VHD\storage-eight.vhdx -SizeBytes 10GB -Dynamic -LogicalSectorSizeBytes 4096 | Out-Null

        New-VHD -Path C:\Users\$currentUser\Desktop\Lab\Storage-VHD\witness-one.vhdx -SizeBytes 1GB -Dynamic -LogicalSectorSizeBytes 4096 | Out-Null
        New-VHD -Path C:\Users\$currentUser\Desktop\Lab\Storage-VHD\witness-two.vhdx -SizeBytes 1GB -Dynamic -LogicalSectorSizeBytes 4096 | Out-Null

        Write-Host -ForegroundColor Yellow "[+] Adding storage to relevant servers "

        Add-VMHardDiskDrive -VMName "WIN-M-DTP-1" -ControllerType SCSI -ControllerNumber 0 -Path C:\Users\$currentUser\Desktop\Lab\Storage-VHD\storage-one.vhdx   
        Add-VMHardDiskDrive -VMName "WIN-M-DTP-1" -ControllerType SCSI -ControllerNumber 0 -Path C:\Users\$currentUser\Desktop\Lab\Storage-VHD\storage-two.vhdx   
        Add-VMHardDiskDrive -VMName "WIN-M-DTP-1" -ControllerType SCSI -ControllerNumber 0 -Path C:\Users\$currentUser\Desktop\Lab\Storage-VHD\storage-three.vhdx 
        Add-VMHardDiskDrive -VMName "WIN-M-DTP-1" -ControllerType SCSI -ControllerNumber 0 -Path C:\Users\$currentUser\Desktop\Lab\Storage-VHD\storage-four.vhdx  
        Add-VMHardDiskDrive -VMName "WIN-M-DTP-1" -ControllerType SCSI -ControllerNumber 0 -Path C:\Users\$currentUser\Desktop\Lab\Storage-VHD\witness-one.vhdx   

        Add-VMHardDiskDrive -VMName "WIN-M-DTP-2" -ControllerType SCSI -ControllerNumber 0 -Path C:\Users\$currentUser\Desktop\Lab\Storage-VHD\storage-five.vhdx  
        Add-VMHardDiskDrive -VMName "WIN-M-DTP-2" -ControllerType SCSI -ControllerNumber 0 -Path C:\Users\$currentUser\Desktop\Lab\Storage-VHD\storage-six.vhdx   
        Add-VMHardDiskDrive -VMName "WIN-M-DTP-2" -ControllerType SCSI -ControllerNumber 0 -Path C:\Users\$currentUser\Desktop\Lab\Storage-VHD\storage-seven.vhdx 
        Add-VMHardDiskDrive -VMName "WIN-M-DTP-2" -ControllerType SCSI -ControllerNumber 0 -Path C:\Users\$currentUser\Desktop\Lab\Storage-VHD\storage-eight.vhdx 
        Add-VMHardDiskDrive -VMName "WIN-M-DTP-2" -ControllerType SCSI -ControllerNumber 0 -Path C:\Users\$currentUser\Desktop\Lab\Storage-VHD\witness-two.vhdx   

        Write-Host -ForegroundColor Green "[*] Finished adding additional storage "
    }
    catch
    {
        Write-Host -ForegroundColor Red "[!] Error with storage addition [!]"
    }
}

function ConfigureNetAdapters
{
    try
    {
        Write-Host -ForegroundColor Yellow "[*] Configuring network adapters ... "

        Write-host -ForegroundColor Yellow "[*] Adding network adapters to the domain controller ..."

        Add-VMNetworkAdapter -VmName WIN-M-DC -Name "Ethernet 2"
        Add-VMNetworkAdapter -VMName WIN-M-DC -Name "Ethernet 3" 
        Add-VMNetworkAdapter -VMName WIN-M-DC -Name "Ethernet 4"
        Add-VMNetworkAdapter -VMName WIN-M-DC -Name "Ethernet 5"
        Connect-VMNetworkAdapter -VMName WIN-M-DC -Name "Network Adapter" -SwitchName "EXT-MAIN"
        Connect-VMNetworkAdapter -VMName WIN-M-DC -Name "Ethernet 2" -SwitchName "INT-MAIN"
        Connect-VMNetworkAdapter -VMName WIN-M-DC -Name "Ethernet 3" -SwitchName "PRI-MAIN"
        Connect-VMNetworkAdapter -VMName WIN-M-DC -Name "Ethernet 4" -SwitchName "INT-CLUSTER"
        Connect-VMNetworkAdapter -VMName WIN-M-DC -Name "Ethernet 5" -SwitchName "INT-ALT"

        <# Configure core machines with the appropriate network adpaters #>

        Write-Host -Foregroundcolor Yellow "[+] Configuring network adpaters on the four core servers ..."

        Add-VMNetworkAdapter -VMName WIN-M-CE-1 -Name "Ethernet 2" 
        Add-VMNetworkAdapter -VMName WIN-M-CE-1 -Name "Ethernet 3"
        Add-VMNetworkAdapter -VMName WIN-M-CE-1 -Name "Ethernet 4"
        Connect-VMNetworkAdapter -VMName WIN-M-CE-1 -Name "Network Adapter" -SwitchName "INT-MAIN"
        Connect-VMNetworkAdapter -VMName WIN-M-CE-1 -Name "Ethernet 2" -SwitchName "INT-ALT"
        Connect-VmNetworkAdapter -VMName WIN-M-CE-1 -Name "Ethernet 3" -SwitchName "INT-CLUSTER"
        Connect-VMNetworkAdapter -VMName WIN-M-CE-1 -Name "Ethernet 4" -SwitchName "PRI-MAIN"

        Add-VMNetworkAdapter -VMName WIN-M-CE-2 -Name "Ethernet 2" 
        Add-VMNetworkAdapter -VMName WIN-M-CE-2 -Name "Ethernet 3"
        Add-VMNetworkAdapter -VMName WIN-M-CE-2 -Name "Ethernet 4"
        Connect-VMNetworkAdapter -VMName WIN-M-CE-2 -Name "Network Adapter" -SwitchName "INT-MAIN"
        Connect-VMNetworkAdapter -VMName WIN-M-CE-2 -Name "Ethernet 2" -SwitchName "INT-ALT"
        Connect-VmNetworkAdapter -VMName WIN-M-CE-2 -Name "Ethernet 3" -SwitchName "INT-CLUSTER"
        Connect-VMNetworkAdapter -VMName WIN-M-CE-2 -Name "Ethernet 4" -SwitchName "PRI-MAIN"

        Add-VMNetworkAdapter -VMName WIN-M-CE-3 -Name "Ethernet 2" 
        Add-VMNetworkAdapter -VMName WIN-M-CE-3 -Name "Ethernet 3"
        Add-VMNetworkAdapter -VMName WIN-M-CE-3 -Name "Ethernet 4"
        Connect-VMNetworkAdapter -VMName WIN-M-CE-3 -Name "Network Adapter" -SwitchName "INT-MAIN"
        Connect-VMNetworkAdapter -VMName WIN-M-CE-3 -Name "Ethernet 2" -SwitchName "INT-ALT"
        Connect-VmNetworkAdapter -VMName WIN-M-CE-3 -Name "Ethernet 3" -SwitchName "INT-CLUSTER"
        Connect-VMNetworkAdapter -VMName WIN-M-CE-3 -Name "Ethernet 4" -SwitchName "PRI-MAIN"

        Add-VMNetworkAdapter -VMName WIN-M-CE-4 -Name "Ethernet 2" 
        Add-VMNetworkAdapter -VMName WIN-M-CE-4 -Name "Ethernet 3"
        Add-VMNetworkAdapter -VMName WIN-M-CE-4 -Name "Ethernet 4"
        Connect-VMNetworkAdapter -VMName WIN-M-CE-4 -Name "Network Adapter" -SwitchName "INT-MAIN"
        Connect-VMNetworkAdapter -VMName WIN-M-CE-4 -Name "Ethernet 2" -SwitchName "INT-ALT"
        Connect-VmNetworkAdapter -VMName WIN-M-CE-4 -Name "Ethernet 3" -SwitchName "INT-CLUSTER"
        Connect-VMNetworkAdapter -VMName WIN-M-CE-4 -Name "Ethernet 4" -SwitchName "PRI-MAIN"

        Write-Host -ForegroundColor Green "[*] Core Server Network Adapters Configured ..."

        Write-Host -ForegroundColor Yellow "[+] Configuring Desktop Servers ..."

        Add-VMNetworkAdapter -VMName WIN-M-DTP-1 -Name "Ethernet 2"
        Add-VMNetworkAdapter -VMName WIN-M-DTP-1 -Name "Ethernet 3"
        Add-VMNetworkAdapter -VMName WIN-M-DTP-1 -Name "Ethernet 4"
        Connect-VMNetworkAdapter -VMName WIN-M-DTP-1 -Name "Network Adapter" -SwitchName "INT-MAIN"
        Connect-VMNetworkAdapter -VMName WIN-M-DTP-1 -Name "Ethernet 2" -SwitchName "INT-ALT"
        Connect-VMNetworkAdapter -VMName WIN-M-DTP-1 -Name "Ethernet 3" -SwitchName "INT-CLUSTER"
        Connect-VMNetworkAdapter -VMName WIN-M-DTP-1 -Name "Ethernet 4" -SwitchName "PRI-MAIN" 

        Add-VMNetworkAdapter -VMName WIN-M-DTP-2 -Name "Ethernet 2"
        Add-VMNetworkAdapter -VMName WIN-M-DTP-2 -Name "Ethernet 3"
        Add-VMNetworkAdapter -VMName WIN-M-DTP-2 -Name "Ethernet 4"
        Connect-VMNetworkAdapter -VMName WIN-M-DTP-2 -Name "Network Adapter" -SwitchName "INT-MAIN"
        Connect-VMNetworkAdapter -VMName WIN-M-DTP-2 -Name "Ethernet 2" -SwitchName "INT-ALT"
        Connect-VMNetworkAdapter -VMName WIN-M-DTP-2 -Name "Ethernet 3" -SwitchName "INT-CLUSTER"
        Connect-VMNetworkAdapter -VMName WIN-M-DTP-2 -Name "Ethernet 4" -SwitchName "PRI-MAIN"
        
        Write-Host -ForegroundColor Green "[*] Desktop Server Network Adpaters Configured ..." 

    }
    catch
    {
        Write-Host -ForegroundColor Red "[!] Failed to configure network adapter [!]" ; Start-Sleep -Seconds 1
    }

    Write-Host -ForegroundColor Green "[*] Network Adapter Creation/Inclusion sequence complete "
    
}

function ConfigureDC
{
   Write-Host -ForegroundColor Yellow "[*] Configuring the domain controller ..."

   Write-Host -ForegroundColor DarkMagenta "[*] Be prepared to enter the safe mode password! "

   Start-VM -ComputerName localhost -Name WIN-M-DC ; Start-Sleep -Seconds 30

   Write-Host -ForegroundColor Yellow "[*] Renaming the DC ... "

   Invoke-Command -VMName WIN-M-DC -Credential $credential -ScriptBlock { Rename-Computer -NewName "WIN-M-DC" ; Restart-Computer -Force }

   Start-Sleep -Seconds 180

   Invoke-Command -VMName WIN-M-DC -Credential $credential -ScriptBlock { 
                                                                            
                                                                            New-NetIPAddress -InterfaceAlias "Ethernet 2" -IPAddress "172.16.1.2" -PrefixLength 24 | Out-Null
                                                                            New-NetIPAddress -InterfaceAlias "Ethernet 3" -IPAddress "10.10.10.2" -PrefixLength 24 | Out-Null 
                                                                            New-NetIPAddress -InterfaceAlias "Ethernet 4" -IPAddress "172.16.3.2" -PrefixLength 24 | Out-Null 
                                                                            New-NetIPAddress -InterfaceAlias "Ethernet 5" -IPAddress "172.16.2.2" -PrefixLength 24 | Out-Null 
                                                                            
                                                                            Set-DNSClientServerAddress -InterfaceAlias "Ethernet 2" -ServerAddresses ("127.0.0.1","8.8.8.8") | Out-Null
                                                                            
                                                                            Set-NetFirewallProfile -Name * -Enabled False

                                                                            Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools 
                                                                            
                                                                            Install-ADDSDomainController -DomainName "homelab.winlab.mobile" -InstallDNS:$True
                                                                            
                                                                            Install-ADDSForest -DomainName "homelab.winlab.mobile" -InstallDNS 
                                                                             
                                                                        }
   Clear-Host 

   Write-Host "[*] DC Promotion Sequence Complete "

   Clear-Host
}

function ConfigureHosts
{
    Write-Host -ForegroundColor Yellow "[*] Host configuration subroutine ..." 

    Write-Host -ForegroundColor Yellow "[+] Enter the workgroup administrator credentials: "

    $workgroupCredential = Get-Credential 

    Start-VM -Name WIN-M-CE-1
    
    Start-Sleep -Seconds 30

    Write-Host -ForegroundColor Yellow "[*] Configuring Core Server Number 1 ..."

    Invoke-Command -VMName WIN-M-CE-1 -Credential $workgroupCredential -ScriptBlock {
                                                                             Set-NetFirewallProfile -Name * -Enabled False

                                                                             New-NetIPAddress -InterfaceAlias "Ethernet" -IPAddress "172.16.1.11" -PrefixLength 24 | Out-Null 
                                                                             Set-DNSClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses ("172.16.1.2") | Out-Null
                                                                             }

    Invoke-Command -VMName WIN-M-CE-1 -Credential $workgroupCredential -ScriptBlock {

         Add-Computer -NewName WIN-M-CE-1 -DomainName "homelab.winlab.mobile" -Credential HOMELAB\Administrator

         New-NetIPAddress -InterfaceAlias "Ethernet 2" -IPAddress "10.10.10.11" -PrefixLength 24 | Out-Null 
         New-NetIPAddress -InterfaceAlias "Ethernet 3" -IPAddress "172.16.3.11" -PrefixLength 24 | Out-Null
         New-NetIPAddress -InterfaceAlias "Ethernet 4" -IPAddress "172.16.2.11" -PrefixLength 24 | Out-Null 

         Set-DNSClientServerAddress -InterfaceAlias "Ethernet 2" -ServerAddresses ("172.16.1.2") | Out-Null
         Set-DNSClientServerAddress -InterfaceAlias "Ethernet 3" -ServerAddresses ("172.16.1.2") | Out-Null
         Set-DNSClientServerAddress -InterfaceAlias "Ethernet 4" -ServerAddresses ("172.16.1.2") | Out-Null
         }
                                                                                                                             
    Stop-VM -Name WIN-M-CE-1

    Start-VM -Name WIN-M-CE-2
    
    Start-Sleep -Seconds 30

    Write-Host -ForegroundColor Yellow "[*] Configuring Core Server Number 2 ..."

     Invoke-Command -VMName WIN-M-CE-2 -Credential $workgroupCredential -ScriptBlock {
                                                                             Set-NetFirewallProfile -Name * -Enabled False

                                                                             New-NetIPAddress -InterfaceAlias "Ethernet" -IPAddress "172.16.1.12" -PrefixLength 24 | Out-Null 
                                                                             Set-DNSClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses ("172.16.1.2") | Out-Null
                                                                             }

    Invoke-Command -VMName WIN-M-CE-2 -Credential $workgroupCredential -ScriptBlock {

         Add-Computer -NewName WIN-M-CE-2 -DomainName "homelab.winlab.mobile" -Credential HOMELAB\Administrator

         New-NetIPAddress -InterfaceAlias "Ethernet 2" -IPAddress "10.10.10.12" -PrefixLength 24 | Out-Null 
         New-NetIPAddress -InterfaceAlias "Ethernet 3" -IPAddress "172.16.3.12" -PrefixLength 24 | Out-Null
         New-NetIPAddress -InterfaceAlias "Ethernet 4" -IPAddress "172.16.2.12" -PrefixLength 24 | Out-Null 

         Set-DNSClientServerAddress -InterfaceAlias "Ethernet 2" -ServerAddresses ("172.16.1.2") | Out-Null
         Set-DNSClientServerAddress -InterfaceAlias "Ethernet 3" -ServerAddresses ("172.16.1.2") | Out-Null
         Set-DNSClientServerAddress -InterfaceAlias "Ethernet 4" -ServerAddresses ("172.16.1.2") | Out-Null
         }
                         
           
    Stop-VM -Name WIN-M-CE-2

    Start-VM -Name WIN-M-CE-3
    
    Start-Sleep -Seconds 30

    Write-Host -ForegroundColor Yellow "[*] Configuring Core Server Number 3 ..."

     Invoke-Command -VMName WIN-M-CE-3 -Credential $workgroupCredential -ScriptBlock {
                                                                             Set-NetFirewallProfile -Name * -Enabled False

                                                                             New-NetIPAddress -InterfaceAlias "Ethernet" -IPAddress "172.16.1.13" -PrefixLength 24 | Out-Null 
                                                                             Set-DNSClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses ("172.16.1.2") | Out-Null
                                                                             }

    Invoke-Command -VMName WIN-M-CE-3 -Credential $workgroupCredential -ScriptBlock {

         Add-Computer -NewName WIN-M-CE-3 -DomainName "homelab.winlab.mobile" -Credential HOMELAB\Administrator

         New-NetIPAddress -InterfaceAlias "Ethernet 2" -IPAddress "10.10.10.13" -PrefixLength 24 | Out-Null 
         New-NetIPAddress -InterfaceAlias "Ethernet 3" -IPAddress "172.16.3.13" -PrefixLength 24 | Out-Null
         New-NetIPAddress -InterfaceAlias "Ethernet 4" -IPAddress "172.16.2.13" -PrefixLength 24 | Out-Null 

         Set-DNSClientServerAddress -InterfaceAlias "Ethernet 2" -ServerAddresses ("172.16.1.2") | Out-Null
         Set-DNSClientServerAddress -InterfaceAlias "Ethernet 3" -ServerAddresses ("172.16.1.2") | Out-Null
         Set-DNSClientServerAddress -InterfaceAlias "Ethernet 4" -ServerAddresses ("172.16.1.2") | Out-Null
         }
                         
    Stop-VM -Name WIN-M-CE-3

    Start-VM -Name WIN-M-CE-4
    
    Start-Sleep -Seconds 30

    Write-Host -ForegroundColor Yellow "[*] Configuring Core Server Number 4 ..."

   Invoke-Command -VMName WIN-M-CE-4 -Credential $workgroupCredential -ScriptBlock {
                                                                             Set-NetFirewallProfile -Name * -Enabled False

                                                                             New-NetIPAddress -InterfaceAlias "Ethernet" -IPAddress "172.16.1.14" -PrefixLength 24 | Out-Null 
                                                                             Set-DNSClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses ("172.16.1.2") | Out-Null
                                                                             }

    Invoke-Command -VMName WIN-M-CE-4 -Credential $workgroupCredential -ScriptBlock {

         Add-Computer -NewName WIN-M-CE-4 -DomainName "homelab.winlab.mobile" -Credential HOMELAB\Administrator

         New-NetIPAddress -InterfaceAlias "Ethernet 2" -IPAddress "10.10.10.14" -PrefixLength 24 | Out-Null 
         New-NetIPAddress -InterfaceAlias "Ethernet 3" -IPAddress "172.16.3.14" -PrefixLength 24 | Out-Null
         New-NetIPAddress -InterfaceAlias "Ethernet 4" -IPAddress "172.16.2.14" -PrefixLength 24 | Out-Null 

         Set-DNSClientServerAddress -InterfaceAlias "Ethernet 2" -ServerAddresses ("172.16.1.2") | Out-Null
         Set-DNSClientServerAddress -InterfaceAlias "Ethernet 3" -ServerAddresses ("172.16.1.2") | Out-Null
         Set-DNSClientServerAddress -InterfaceAlias "Ethernet 4" -ServerAddresses ("172.16.1.2") | Out-Null
         }
                         
    Stop-VM -Name WIN-M-CE-4

    Start-VM -Name WIN-M-DTP-1
    
    Start-Sleep -Seconds 30

    Write-Host -ForegroundColor Yellow "[*] Configuring Desktop Server 1 ..."

     Invoke-Command -VMName WIN-M-DTP-1 -Credential $workgroupCredential -ScriptBlock {
                                                                             Set-NetFirewallProfile -Name * -Enabled False

                                                                             New-NetIPAddress -InterfaceAlias "Ethernet" -IPAddress "172.16.1.4" -PrefixLength 24 | Out-Null 
                                                                             Set-DNSClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses ("172.16.1.2") | Out-Null
                                                                             }

    Invoke-Command -VMName WIN-M-DTP-1 -Credential $workgroupCredential -ScriptBlock {

         Add-Computer -NewName WIN-M-DTP-1 -DomainName "homelab.winlab.mobile" -Credential HOMELAB\Administrator

         New-NetIPAddress -InterfaceAlias "Ethernet 2" -IPAddress "10.10.10.4" -PrefixLength 24 | Out-Null 
         New-NetIPAddress -InterfaceAlias "Ethernet 3" -IPAddress "172.16.3.4" -PrefixLength 24 | Out-Null
         New-NetIPAddress -InterfaceAlias "Ethernet 4" -IPAddress "172.16.2.4" -PrefixLength 24 | Out-Null 

         Set-DNSClientServerAddress -InterfaceAlias "Ethernet 2" -ServerAddresses ("172.16.1.2") | Out-Null
         Set-DNSClientServerAddress -InterfaceAlias "Ethernet 3" -ServerAddresses ("172.16.1.2") | Out-Null
         Set-DNSClientServerAddress -InterfaceAlias "Ethernet 4" -ServerAddresses ("172.16.1.2") | Out-Null
         }
                          
    Stop-VM -Name WIN-M-DTP-1

    Start-VM -Name WIN-M-DTP-2
    
    Start-Sleep -Seconds 30

    Write-Host -ForegroundColor Yellow "[*] Configuring Desktop Server Number 2 ..."

     Invoke-Command -VMName WIN-M-DTP-2 -Credential $workgroupCredential -ScriptBlock {
                                                                             Set-NetFirewallProfile -Name * -Enabled False

                                                                             New-NetIPAddress -InterfaceAlias "Ethernet" -IPAddress "172.16.1.5" -PrefixLength 24 | Out-Null 
                                                                             Set-DNSClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses ("172.16.1.2") | Out-Null
                                                                             }

    Invoke-Command -VMName WIN-M-DTP-2 -Credential $workgroupCredential -ScriptBlock {

         Add-Computer -NewName WIN-M-DTP-2 -DomainName "homelab.winlab.mobile" -Credential HOMELAB\Administrator

         New-NetIPAddress -InterfaceAlias "Ethernet 2" -IPAddress "10.10.10.5" -PrefixLength 24 | Out-Null 
         New-NetIPAddress -InterfaceAlias "Ethernet 3" -IPAddress "172.16.3.5" -PrefixLength 24 | Out-Null
         New-NetIPAddress -InterfaceAlias "Ethernet 4" -IPAddress "172.16.2.5" -PrefixLength 24 | Out-Null 

         Set-DNSClientServerAddress -InterfaceAlias "Ethernet 2" -ServerAddresses ("172.16.1.2") | Out-Null
         Set-DNSClientServerAddress -InterfaceAlias "Ethernet 3" -ServerAddresses ("172.16.1.2") | Out-Null
         Set-DNSClientServerAddress -InterfaceAlias "Ethernet 4" -ServerAddresses ("172.16.1.2") | Out-Null
         }
                          
    Stop-VM -Name WIN-M-DTP-2
}

function CreateCheckpoints
{
    Write-Host -ForegroundColor Yellow "[+] Creating VM Checkpoints ..."

    Get-VM | Foreach-Object {  Checkpoint-VM $_.Name -SnapshotName "Post-Creation-DC-Joined"}

    Write-Host -ForegroundColor Green "[*] VM Checkpoints Created "
}

function main()
{
    Write-Host -ForegroundColor Green "[*] Hyper-V VM Lab Creation Script [*]"

    $currentUser = $env:USERNAME

    CreateSwitches

    CreateVM

    ConfigureNetAdapters

    ConfigureDC

    ConfigureHosts

    CreateCheckpoints

}

Write-Host -ForegroundColor Yellow "[+] Enter the workgroup administrator credentials: "

$credential = Get-Credential 

main
