# Change local account password #

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

    Write-Host -ForegroundColor Yellow "[*] Local Account - Password Modification [*]`n"

    Write-Host -ForegroundColor Yellow "[*] Gathering local user accounts...`n"

    Start-Sleep -Seconds 1

    $accounts = Get-LocalUser | Select-Object -Property Name,Enabled

    $accounts | Foreach-Object { Write-Host -ForegroundColor Green $_.Name }
    
    Write-Host ""

    $subjectAccount = Read-Host "[+] Enter the subject account name-> "

    $newPassword = Read-Host -AsSecureString "[+] Enter the new password-> "

    Write-Host "[*] Attempting to change the local user account password..."

    Start-Sleep -Seconds 1

    try 
    {
       Set-LocalUser -Name $subjectAccount -Password $newPassword
       
       Write-Host -ForegroundColor Green "[*] Local Account Password Changed [*]"
    }
    catch 
    {
        Write-Host -ForegroundColor Red "[!] Failed to change password [!]"
    }
}

main