<# Homelab Server Lab Build Script #>

<#

    Script Requirements
    -------------------
    -> List of servers to be built with IP addresses
    -> A HYper-V host server with adequate resources

 #>

 <# Golden Image Path Global Variable Configuration #>

$golden_server_path  = "G:\Shares\StorageTwo\Golden-Server-Host\Virtual Machines\"

$golden_core_path    = "G:\Shares\StorageTwo\Golden-Server-Core\Virtual Machines\" 

$vm_storage_path     = "G:\Shares\StorageTwo\" 

function CreateADObjects($servers)
{
    $credential = Get-Credential HOMELAB\homelab.admin

    Write-Host -ForegroundColor Yellow "[*] Creating Active Directory Objects for each server... "

    $server_ou = "OU=SERVERS,OU=WINLAB-CORP,DC=homelab,DC=winlab,DC=local"

    $servers | Foreach-Object {
                                    $server      = $_.SERVER
                                    $ip          = $_.IP
                                    $description = $_.Description 
                                    
                                    Write-Host -ForegroundColor Yellow "[*] Creating AD Object for: $server | $ip | $description "

                                    New-ADComputer -Path $server_ou -Name $server -SAMAccountName $server -Enabled:$true -Description "$description | IP: $ip " -Credential $credential
                              }
}

function ImportVM($server_list,$golden_server_path,$golden_core_path,$vm_storage_path)
{
    Write-Host -ForegroundColor Green "[*] Beginning VM import sequence... "

    $credential = Get-Credential

    $server_vm_storage_path = "$vm_storage_path\Servers"

    $check_storage_path = Test-Path -Path $server_vm_storage_path

    if($check_storage_path)
    {
        Write-Host -ForegroundColor Yellow "[*] Server directory is present "
    }
    else
    {
        Write-Host -ForegroundColor Yellow "[*] Server VM storage directory not found "

        Write-Host -ForegroundColor Yellow "[*] Creating the server VM storage directory "

        try
        {
            New-Item -Path $vm_storage_path -Name "Servers" -ItemType Directory | Out-Null

            Write-Host -ForegroundColor Green "[*] Created the storage directory for the server VMs"
        }
        catch
        {
            Write-Host -ForegroundColor Red "[!] Failed to create the storage directory for the server VMs"

            exit
        }
    }

    $test_server_image_path = Test-Path -Path $golden_server_path

    $test_server_core_path  = Test-Path -Path $golden_core_path

    if($test_server_image_path -and $test_server_core_path)
    {
        Write-Host -ForegroundColor Green "[*] Located the directories containing the base images "
    }
    else
    {
        Write-Host -ForegroundColor Red "[!] Failed to locate the directories which contain the base images "

        exit
    }

    $server_desktop_image = ""
    $server_core_image    = ""

    $golden_server_path | Get-ChildItem | Foreach-Object { $name = $_.Name ; $segments = $name.Split('.') ; $extension = $segments[1] ; if($extension -eq 'vmcx'){ $server_desktop_image = $_.FullName } }

    $golden_core_path   | Get-ChildItem | Foreach-Object { $name = $_.Name ; $segments = $name.Split('.') ; $extension = $segments[1] ; if($extension -eq 'vmcx'){ $server_core_image = $_.FullName } }

    Write-Host -ForegroundColor Green "[*] Server Desktop Image Located: $server_desktop_image "

    Write-Host -ForegroundColor Green "[*] Server Core Image Located: $server_core_image "

    $server_list | Foreach-Object {
                                        $server = $_.Server ; $segments = $server.Split('-')

                                        if($segments[1] -contains 'CORE')
                                        {
                                           Write-Host -ForegroundColor Yellow "[*] Core Server Import Required for: $server "

                                           Write-Host -ForegroundColor Green "[*] Importing VM for: $server "

                                           New-Item -ItemType Directory -Path $server_vm_storage_path -Name $server | Out-Null

                                           $individual_storage_path = "$server_vm_storage_path\$server"
                                           
                                           Import-VM -Path $server_core_image `
                                           -Copy -GenerateNewId `
                                           -SnapshotFilePath $individual_storage_path `
                                           -VhdDestinationPath $individual_storage_path `
                                           -VirtualMachinePath $individual_storage_path `

                                           Rename-VM "Golden-Server-Core" -NewName $server
                                         }
                                         else
                                         {
                                           Write-Host -ForegroundColor Yellow "[*] Desktop Server Import Required for: $server "
                                           <#
                                           Write-Host -ForegroundColor Green "[*] Importing VM for: $server "

                                           New-Item -ItemType Directory -Path $server_vm_storage_path -Name $server | Out-Null
                                           
                                           $individual_storage_path = "$server_vm_storage_path\$server"

                                           Import-VM -Path $server_desktop_image `
                                           -Copy -GenerateNewId `
                                           -SnapshotFilePath $individual_storage_path `
                                           -VhdDestinationPath $individual_storage_path `
                                           -VirtualMachinePath $individual_storage_path `

                                           Rename-VM "Golden-Server-Host" -NewName $server
                                           #>
                                         }
                                  }                                   
}

function SetNetAdapters($server_list)
{
    $vm_switch = (Get-VMSwitch | Where-Object { $_.Name -contains 'vExternal-Server' }).Name

    $server_list | Foreach-Object { $vm = $_.Server ; Connect-VMNetworkAdapter -VMName $vm -SwitchName $vm_switch  }
}

function main()
{
    Write-Host -ForegroundColor Green "[*] Hyper-V Server Lab Build Script "

    $check_server_list = Test-Path -Path .\servers.csv

    if($check_server_list)
    {
       $server_list = Import-CSV -Path .\servers.csv 
    }
    else
    {
        Write-Host -ForegroundColor Red "[!] Failed to locate server inventory "

        return
    }

    #$remote_server = Read-Host "[+] Enter the name of the host server "

    #Write-Host -ForegroundColor Yellow "[*] Host serve identified as-> $remote_server"

    Write-Host -ForegroundColor Yellow "[*] Listing server candidate names and IPs `n"

    $server_list | Foreach-Object { $server = $_.Server; Write-Host -ForegroundColor Yellow " `t $server" }

    Write-Host `n

    #CreateADObjects $server_list

    ImportVM $server_list $golden_server_path $golden_core_path $vm_storage_path

    #SetNetAdapters $server_list
}

main