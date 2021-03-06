# Add existing local user to Administrator Group #

$ErrorActionPreference = "SilentlyContinue"
function AdminTest()
{
    $test = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")

    if($test)
    {
        Write-Host -ForegroundColor Green "[*] User is an Administrator [*]`n"
    }
    else
    {
        Write-Host -ForegroundColor Red "[!] User is not an Administrator [!]`n"  
        
        exit
    }
}
function main()
{
    AdminTest

    Write-Host -ForegroundColor Yellow "[*] Add Local Administrator [*]`n"

    Write-Host -ForegroundColor Yellow "[*] Gathering local user accounts...`n"

    Start-Sleep -Seconds 1

    $accounts = Get-LocalUser | Select-Object -Property Name

    $accounts | Foreach-Object { Write-Host -ForegroundColor Green $_.Name }
    
    Write-Host ""

    $subjectAccount = Read-Host "[+] Enter the account to be promoted to a local Administrator-> "

    Write-Host "[*] Attempting to add the local account to the Administrators group..."

    Start-Sleep -Seconds 1

    try 
    {
       Add-LocalGroupMember -Group Administrators -Member $subjectAccount
       
       Write-Host -ForegroundColor Green "[*] User added to Administrators Group [*]"
    }
    catch 
    {
        Write-Host -ForegroundColor Red "[!] Failed to add user to Administrators Group [!]"
    }
}

main