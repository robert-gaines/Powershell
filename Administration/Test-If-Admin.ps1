# Check to see if the current user is an administrator #

function AdminTest()
{
    $test = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")

    if($test)
    {
        Write-Host -ForegroundColor Green "[*] User is an Administrator [*]`n"

        return 1
    }
    else
    {
        Write-Host -ForegroundColor Red "[!] User is not an Administrator [!]`n"  
        
        return 0
    }
}

$result = AdminTest