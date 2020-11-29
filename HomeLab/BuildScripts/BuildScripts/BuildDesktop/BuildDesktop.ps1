<# Homelab Desktop Lab Build Script #>

<#

    Script Requirements
    -------------------
    -> List of virtual PCs to be built with IP addresses
    -> A Hyper-V host server with adequate resources

 #>

 <# Golden Image Path Global Variable Configuration #>

$golden_desktop_path  = "F:\Shares\StorageOne\Golden-Desktop-Host\Virtual Machines\"

$vm_storage_path      = "F:\Shares\StorageOne\" 

function CreateADObjects($workstations)
{
    $credential = Get-Credential HOMELAB\homelab.admin

    Write-Host -ForegroundColor Yellow "[*] Creating Active Directory Objects for each workstation... "

    $workstation_ou = "OU=WORKSTATIONS,OU=WINLAB-CORP,DC=homelab,DC=winlab,DC=local"

    $workstations | Foreach-Object {
                                        $workstation      = $_.Host
                                        $ip               = $_.IP
                                    
                                        Write-Host -ForegroundColor Yellow "[*] Creating AD Object for: $workstation | $ip "

                                        New-ADComputer -Path $workstation_ou -Name $workstation -SAMAccountName $workstation -Enabled:$true -Description "Virtual Workstation | IP: $ip " -Credential $credential
                                   }
}

function ImportVM($workstation_list,$golden_desktop_path,$vm_storage_path)
{
    Write-Host -ForegroundColor Green "[*] Beginning VM import sequence... "

    $credential = Get-Credential

    $workstation_vm_storage_path = "$vm_storage_path\Workstations"

    $check_storage_path = Test-Path -Path $workstation_vm_storage_path

    if($check_storage_path)
    {
        Write-Host -ForegroundColor Yellow "[*] Workstation directory is present "
    }
    else
    {
        Write-Host -ForegroundColor Yellow "[*] Workstation VM storage directory not found "

        Write-Host -ForegroundColor Yellow "[*] Creating the workstation VM storage directory "

        try
        {
            New-Item -Path $vm_storage_path -Name "Workstations" -ItemType Directory | Out-Null

            Write-Host -ForegroundColor Green "[*] Created the storage directory for the workstation VMs"
        }
        catch
        {
            Write-Host -ForegroundColor Red "[!] Failed to create the storage directory for the workstation VMs"

            exit
        }
    }

    $test_workstation_image_path = Test-Path -Path $golden_desktop_path

    if($test_workstation_image_path)
    {
        Write-Host -ForegroundColor Green "[*] Located the directories containing the base images "
    }
    else
    {
        Write-Host -ForegroundColor Red "[!] Failed to locate the directories which contain the base images "

        exit
    }

    $workstation_desktop_image = ""

    $golden_desktop_path | Get-ChildItem | Foreach-Object { $name = $_.Name ; $segments = $name.Split('.') ; $extension = $segments[1] ; if($extension -eq 'vmcx'){ $workstation_desktop_image = $_.FullName } }

    Write-Host -ForegroundColor Green "[*] Workstation Desktop Image Located: $workstation_desktop_image "

    $workstation_list | Foreach-Object {
                                        $workstation = $_.Host

                                        Write-Host -ForegroundColor Yellow "[*] Desktop Import Required for: $workstation "
                                        
                                        New-Item -ItemType Directory -Path $workstation_vm_storage_path -Name $workstation | Out-Null
                                           
                                        $individual_storage_path = "$workstation_vm_storage_path\$workstation"

                                        Import-VM -Path $workstation_desktop_image `
                                        -Copy -GenerateNewId `
                                        -SnapshotFilePath $individual_storage_path `
                                        -VhdDestinationPath $individual_storage_path `
                                        -VirtualMachinePath $individual_storage_path `

                                         Rename-VM "Golden-Desktop-Host" -NewName $workstation
                                        }                                   
}

function SetNetAdapters($workstation_list)
{
    $vm_switch = (Get-VMSwitch | Where-Object { $_.Name -contains 'vExternal-Workstation' }).Name

    $workstation_list | Foreach-Object { $vm = $_.Host ; Connect-VMNetworkAdapter -Name $vm -SwitchName $vm_switch  }
}

function main()
{
    Write-Host -ForegroundColor Green "[*] Hyper-V Workstation Lab Build Script "

    $check_server_list = Test-Path -Path .\workstations.csv

    if($check_server_list)
    {
       $workstation_list = Import-CSV -Path .\workstations.csv 
    }
    else
    {
        Write-Host -ForegroundColor Red "[!] Failed to locate workstation inventory "

        return
    }

    Write-Host -ForegroundColor Yellow "[*] Listing workstation candidate names and IPs `n"

    $workstation_list | Foreach-Object { $workstation = $_.Host ; Write-Host -ForegroundColor Yellow " `t $workstation" }

    Write-Host `n

    #CreateADObjects $workstation_list

    ImportVM $workstation_list $golden_desktop_path $vm_storage_path
}

main