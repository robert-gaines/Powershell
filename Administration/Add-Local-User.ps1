# Add a local user account #

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

    Write-Host -ForegroundColor Yellow "[*] Local user account creation [*] `n"

    $description = Read-Host "[+] Enter an account description-> "

    $actualName = Read-Host "[+] Enter the user's name-> "

    $userName = Read-Host "[+] Enter the account username-> "

    $userPass = Read-Host -AsSecureString "[+] Enter the password-> "

    Write-Host -ForegroundColor Yellow "[*] Attempting account creation... "

    $result = New-LocalUser -Name $userName -Description $description -Password $userPass -FullName $actualName -AccountNeverExpires 

    if($result)
    {
        Write-Host -ForegroundColor Green "[*] Local Account Successfully Created [*]"
    }
    else 
    {
        Write-Host -ForegroundColor Red "[!] Failed to create the local account [!]"    
    }
}

main
