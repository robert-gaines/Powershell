<# Create User Accounts and Associate with Proper OU's #>

<#
    Departmental OU's
    -----------------
    OU=WINLAB-CORP,DC=homelab,DC=winlab,DC=local
    OU=IT,OU=WINLAB-CORP,DC=homelab,DC=winlab,DC=local
    OU=FINANCE,OU=WINLAB-CORP,DC=homelab,DC=winlab,DC=local
    OU=HR,OU=WINLAB-CORP,DC=homelab,DC=winlab,DC=local
    OU=MANAGEMENT,OU=WINLAB-CORP,DC=homelab,DC=winlab,DC=local
    OU=SALES,OU=WINLAB-CORP,DC=homelab,DC=winlab,DC=local
 #>

function ConfigurePermissions($directory,$user_id)
{
    Write-Host -ForegroundColor Yellow "[~] Attempting to modify permissions on: $directory "

    try
    {
        $current_acl = Get-ACL -Path $directory

        $custom_permission = "HOMELAB\$user_id",'Modify','ContainerInherit,ObjectInherit','None','Allow'

        $custom_rule = New-Object System.Security.AccessControl.FileSystemAccessRule -ArgumentList $custom_permission

        $current_acl.SetAccessRule($custom_rule)

        Set-ACL -Path $directory -ACLObject $current_acl

        $active_acl = Get-ACL -Path $directory

        $admin_permission = "HOMELAB\Domain Admins",'FullControl','ContainerInherit,ObjectInherit','None','Allow'

        $admin_rule = New-Object System.Security.AccessControl.FileSystemAccessRule -ArgumentList $admin_permission

        $active_acl.SetAccessRule($admin_rule)

        Set-ACL -Path $directory -ACLObject $active_acl

        icacls $directory /inheritance:d

        Write-Host -ForegroundColor Green "[*] Permissions successfully modified on user: $user_id's -> $directory "
    }
    catch
    {
        Write-Host -ForegroundColor Red "[!] Failed to modify NTFS permissions on: $directory "
    }
}

function GetPath($department)
{
    <#
            OU=IT,OU=WINLAB-CORP,DC=homelab,DC=winlab,DC=local
            OU=FINANCE,OU=WINLAB-CORP,DC=homelab,DC=winlab,DC=local
            OU=HR,OU=WINLAB-CORP,DC=homelab,DC=winlab,DC=local
            OU=MANAGEMENT,OU=WINLAB-CORP,DC=homelab,DC=winlab,DC=local
            OU=SALES,OU=WINLAB-CORP,DC=homelab,DC=winlab,DC=local
     #>

    $path = ''

    if($department -eq 'IT')
    {
        $path = "OU=IT,OU=WINLAB-CORP,DC=homelab,DC=winlab,DC=local"
        return $path
    }
    elseif($department -eq 'FINANCE')
    {
        $path = "OU=IT,OU=WINLAB-CORP,DC=homelab,DC=winlab,DC=local"
        return $path
    }
    elseif($department -eq 'HR')
    {
        $path = "OU=HR,OU=WINLAB-CORP,DC=homelab,DC=winlab,DC=local"
        return $path
    }
    elseif($department -eq 'SALES')
    {
        $path = "OU=SALES,OU=WINLAB-CORP,DC=homelab,DC=winlab,DC=local"
        return $path
    }
    elseif($department -eq 'MANAGEMENT')
    {
        $path = "OU=MANAGEMENT,OU=WINLAB-CORP,DC=homelab,DC=winlab,DC=local"
        return $path
    }
    else
    {
        $path = "OU=WINLAB-CORP,DC=homelab,DC=winlab,DC=local"
        return $path
    }

}

function AssignGroup($department,$user)
{

    if($department -eq 'IT')
    {
        Add-ADGroupMember -Identity "CN=IT All Users,OU=IT,OU=WINLAB-CORP,DC=homelab,DC=winlab,DC=local" -Members $user 
    }
    elseif($department -eq 'FINANCE')
    {
        Add-ADGroupMember -Identity "CN=FINANCE All Users,OU=FINANCE,OU=WINLAB-CORP,DC=homelab,DC=winlab,DC=local" -Members $user 
    }
    elseif($department -eq 'HR')
    {
        Add-ADGroupMember -Identity "CN=HR All Users,OU=HR,OU=WINLAB-CORP,DC=homelab,DC=winlab,DC=local" -Members $user 
    }
    elseif($department -eq 'SALES')
    {
        Add-ADGroupMember -Identity "CN=SALES All Users,OU=SALES,OU=WINLAB-CORP,DC=homelab,DC=winlab,DC=local" -Members $user 
    }
    elseif($department -eq 'MANAGEMENT')
    {
        Add-ADGroupMember -Identity "CN=MANAGEMENT All Users,OU=MANAGEMENT,OU=WINLAB-CORP,DC=homelab,DC=winlab,DC=local" -Members $user 
    }
    else
    {
        return
    }

}

function main()
{

    $user_data = Import-CSV -Path fake.csv

    $user_data | Foreach-Object { 
                                   $given_name         = $_.GivenName
                                   $middle_initial     = $_.MiddleInitial
                                   $surname            = $_.Surname 
                                   $sam_name           = "$given_name.$surname"
                                   $sam_name           = $sam_name.ToLower()
                                   $street_addr        = $_.StreetAddress
                                   $city               = $_.city
                                   $state              = $_.StateFull
                                   $passwd             = $_.Password 
                                   $password           = ConvertTo-SecureString -String $passwd -AsPlainText -Force
                                   $office_phone       = $_.TelephoneNumber 
                                   $department         = $_.Department
                                   $emp_id             = $_.EmployeeID 

                                   Write-Host -ForegroundColor Green "[*] Creating: $given_name $surname | $emp_id : $sam_name "

                                   $sharePath = "\\10.10.1.21\USER-SHARE\"
                                   $shareTest = Test-Path -Path $sharePath

                                   if(-not $sharePath)
                                   {
                                    Write-Host -ForegroundColor Red "[!] Could not contact the share, departing..."
                                   }

                                   $dirname = $sam_name
                                   $dirPath = "\\10.10.1.21\USER-SHARE\$dirname"

                                   $check_directory = Test-Path -Path $dirPath -Verbose:$false

                                   if(-not $check_directory)
                                   {
                                    Write-Host -ForegroundColor Green "[*] Creating directory for-> $dirname "
                                    New-Item -ItemType Directory -Path $dirPath
                                   }
                                   else
                                   {
                                    Write-Host -ForegroundColor Yellow "[*] Directory is already in place for-> $dirname "
                                   }

                                   $path = GetPath $department

                                   New-ADUser -GivenName $given_name `
                                              -Name "$given_name $surname" `
                                              -DisplayName "$given_name $middle_initial $surname" `
                                              -Surname $surname `
                                              -SamAccountName $sam_name `
                                              -StreetAddress $street_addr `
                                              -City $city `
                                              -State $state `
                                              -AccountPassword $password `
                                              -ChangePasswordAtLogon:$false `
                                              -PasswordNeverExpires:$true `
                                              -Enabled:$true `
                                              -OfficePhone $office_phone `
                                              -Department $deparmtnet `
                                              -EmployeeID $emp_id `
                                              -Path $path `
                                              -HomeDirectory $dirPath

                                  AssignGroup $department $sam_name

                                  ConfigurePermissions $dirPath $sam_name
                                }

}

main