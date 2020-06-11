<# Parse User Data & Create Shares #>

<#
    Overview
    --------
    -> Read XLSX File 
    -> Extract User Data
    -> Create appropriately named shares
 #>

function CheckAdminRights()
{
    Write-Host -ForegroundColor Yellow "[~] Checking for admin status..."

    $result = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')

    if($result)
    {
        Write-Host -ForegroundColor Green "[*] User is an administrator "

        Start-Sleep -Seconds 3

        return
    }
    else
    {
        Write-Host -ForegroundColor Red "[!] Please run this script as an administrator [!]"

        Start-Sleep -Seconds 3

        exit
    }
}

function ConfigurePermissions($directory,$user_id)
{
    Write-Host -ForegroundColor Yellow "[~] Attempting to modify permissions on: $directory "

    try
    {
        $current_acl = Get-ACL -Path $directory
    
        $current_acl.SetAccessRuleProtection($true,$true)

        $custom_permission = "AD\$user_id",'Modify','ContainerInherit,ObjectInherit','None','Allow'

        $custom_rule = New-Object System.Security.AccessControl.FileSystemAccessRule -ArgumentList $custom_permission

        $current_acl.SetAccessRule($custom_rule)

        Set-ACL -Path $directory -ACLObject $current_acl

        $active_acl = Get-ACL -Path $directory

        $admin_permission = "AD\FAIS Share USERFILESFS Full Control",'FullControl','ContainerInherit,ObjectInherit','None','Allow'

        $admin_rule = New-Object System.Security.AccessControl.FileSystemAccessRule -ArgumentList $admin_permission

        $active_acl.SetAccessRule($admin_rule)

        Set-ACL -Path $directory -ACLObject $active_acl

        $subject_acl = Get-ACL -Path $directory

        $subject_group = ".\Users" ; $subject_rights = "Modify"

        $subject_rule = New-Object System.Security.AccessControl.FileSystemAccessRule($subject_group,$subject_rights,"DENY")

        $subject_acl.SetAccessRule($subject_rule)

        Set-ACL -Path $directory -ACLObject $subject_acl

        Write-Host -ForegroundColor Green "[*] Permissions successfully modified on user: $user_id's -> $directory "
    }
    catch
    {
        Write-Host -ForegroundColor Red "[!] Failed to modify NTFS permissions on: $directory "
    }
}

function ImportUserData()
{
    Write-Host -ForegroundColor Yellow "[~] Searching for the user listing file..."

    Get-ChildItem | Foreach-Object { $candidate = $_.Name 
                                    
                                     $ext = [IO.Path]::GetExtension($candidate)

                                     if($ext -eq '.csv') 
                                     { 
                                         $user_data_file = $candidate 
                                     } 
                                   }
    if($candidate)
    {
        Write-Host -ForegroundColor Green "[*] Located user data file: $candidate "
    }
    else 
    {
        Write-Host -ForegroundColor Red "[!] Failed to locate the user data file..."
        
        Write-Host -ForegroundColor Red "[!] Departing... " 
        
        exit
    }

    $user_array = @()

    Write-Host -ForegroundColor Yellow "[~] Attempting to import the user data file"

    try 
    {
        Write-Host -ForegroundColor Yellow "[+] Gathering usernames..."
     
        $raw_data = Get-Content -Path $user_data_file

        $raw_data | Foreach-Object {
                                        $record = $_
                                        $segments = $record.Split(',')
                                        if($segments.Count -eq 14)
                                        {
                                           $nid = $segments[10] 
                                        }
                                        if($segments.Count -eq 15)
                                        {
                                            $nid = $segments[11]
                                        }
            
                                        if($nid -ne 'Username')
                                        {
                                            Write-Host -ForegroundColor Green "[+] Adding: $nid "
                                            $user_array += $nid
                                        } 
                                   }
    }
    catch 
    {
        Write-Host -ForegroundColor Red "[!] Failed to import the user data file..."
        
        exit
    }

    Write-Host -ForegroundColor Green "[*] User data import subroutine complete "

    return $user_array
} 

function CreateUserDirectories($users)
{
    <# $test_directory = New-Item -ItemType Directory -Path TestDirectory -Verbose:$false #>

    <# Set-Location -Path $test_directory.Name #>

    $base_directory = 'I:\USERFILESFS\'

    $result = Test-Path -Path $base_directory 
    
    if($result)
    {
        Write-Host -ForegroundColor Green "[*] Verified presence of: $base_directory "
    }
    else 
    {
        Write-Host -ForegroundColor Red "[!] Failed to communicate with the target share..."
        
        Write-Host -ForegroundColor Red "[!] Departing..."

        exit
    }

    Write-Host -ForegroundColor Yellow "[~] Creating user directories on the share..."

    $users | Foreach-Object {
                                <# Indvidual NID/Username from the array #>

                                $nid = $_

                                <# Concatenated Path for the Target Share #>

                                $path = $nid   
                                
                                $composite_path = $base_directory+$nid                      

                                try 
                                {
                                    Write-Host -ForegroundColor Yellow "[*] Creating: $composite_path "

                                    New-Item -ItemType Directory -Path $composite_path -Verbose:$false

                                    ConfigurePermissions $composite_path $nid
                                }
                                catch 
                                {
                                    Write-Host -ForegroundColor Red "[!] Failed to create: $path "
                                }
                            }
    Write-Host -ForegroundColor Green "[*] Finished creating user directories on: $base_directory "
}
function main()
{
    Write-Host -ForegroundColor Green "[*] User Shares Creation Script [*]"
    
    $users = ImportUserData

    CreateUserDirectories $users

    #Set-Location -Path ..\

    Start-Sleep -Seconds 3

    Clear-Host
}

main