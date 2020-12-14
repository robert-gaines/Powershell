$ErrorActionPreference = 'SilentlyContinue'

Write-Host -ForegroundColor Green "[*] User Default Directorry Configuration Script "

Write-Host -ForegroundColor Yellow "[*] Gatheering unique departments"

<# Get Unique Departments #>

$unique_departments = @()

Get-ADUser -Filter * -Properties * | Select-Object DistinguishedName | Foreach-Object {

                                                                                        $entry = $_.DistinguishedName.ToString()

                                                                                        $segments = $entry.split(',')

                                                                                        $subsegment = $segments[1].split('=')
                                                                                        
                                                                                        $department = $subsegment[1]                  

                                                                                        if($department -notin $unique_departments)
                                                                                        {
                                                                                            $unique_departments += $department
                                                                                        }

                                                                                      }

Write-Host -ForegroundColor Green "[*] Identified unique departments: $unique_departments"

$userfiles_share = Read-Host "[+] Enter the UNC to the share-> "

$unc_test = Test-Path -Path $userfiles_share

if($unc_test)
{
    Write-Host -ForegroundColor Green "[*] Share exists "
}
else
{
    Write-Host -ForegroundColor Red "[!] Share does not exist"

    Start-Sleep -Seconds 3

    #exit
}

$unique_departments | Foreach-Object {
                                        $department = $_
                                        $full_dir_path = $userfiles_share+'\'+$department 
                                        Write-Host -ForegroundColor Yellow "[*] Creating: $full_dir_path "

                                        try
                                        {
                                            $null = New-Item -Type Directory -Path $full_dir_path -Verbose:$false
                                        }
                                        catch
                                        {
                                            Write-Host -ForegroundColor Red "[!] Failed to create departmental directory "
                                        }
                                     }

<#

    \\HL-FS\USERFILES\Users
    \\HL-FS\USERFILES\Homelab-Users
    \\HL-FS\USERFILES\IT
    \\HL-FS\USERFILES\SALES
    \\HL-FS\USERFILES\HR
    \\HL-FS\USERFILES\MANAGEMENT

 #>

Get-ADUser -SearchBase "OU=WINLAB-CORP,DC=homelab,DC=winlab,DC=local" -Filter * -Properties * | Select-Object SAMAccountName,DistinguishedName | Foreach-Object {

                                                                                                        $entry = $_.DistinguishedName.ToString()

                                                                                                        $segments = $entry.split(',')

                                                                                                        $subsegment = $segments[1].split('=')
                                                                                        
                                                                                                        $department = $subsegment[1]
                                                                                                        
                                                                                                        $account = $_.SAMAccountName.ToString()

                                                                                                        $user_dir_path = $userfiles_share+'\'+$department+'\'+$account
                                                                                                        
                                                                                                        Write-Host -ForegroundColor Yellow "[*] Creating: $user_dir_path"

                                                                                                        try
                                                                                                        {
                                                                                                            New-Item -ItemType Directory -Path $user_dir_path | Out-Null

                                                                                                            Write-Host -ForegroundColor Green "[*] Created: $user_dir_path "
                                                                                                        }
                                                                                                        catch
                                                                                                        {
                                                                                                            Write-Host -ForegroundColor Red "[!] Failed to create: $user_dir_path"
                                                                                                        }

                                                                                                        try
                                                                                                        {
                                                                                                            Set-ADUser -Identity $account -HomeDirectory $user_dir_path 

                                                                                                            Set-ADUser -Identity $account -Department $department

                                                                                                            Write-Host -ForegroundColor Green "[*] Set user home directory to: $user_dir_path "
                                                                                                        }
                                                                                                        catch
                                                                                                        {
                                                                                                            Write-Host -ForegroundColor Red "[!] Failed to set user home directory to: $user_dir_path "
                                                                                                        }
                                                                                                     } 