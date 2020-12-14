<# Powershell Windows Update Script #>

$ErrorActionPreference = 'SilentlyContinue'

function main()
{
    try
    {
        $moduleCheck = Get-Module -Name PSWindowsUpdate

        if($moduleCheck -ne $null)
        {
            Write-Host -ForegroundColor Green "[*] PS Windows Update module is present "
        }
        else
        {
            Write-Host -ForegroundColor Yellow "[*] Installing the PS Module "

            Install-Module -Name PSWindowsUpdate -Force -Confirm:$false

            Write-Host -ForegroundColor Green "[*] Successfully installed PS Module "
        }
    }
    catch
    {
        Write-Host -ForegroundColor Red "[!] Failed to install the PS Module "

        return
    }

    try
    {
        Write-Host -ForegroundColor Yellow "[*] Importing the PS Module "

        Import-Module -Name PSWindowsUpdate

        Write-Host -ForegroundColor Green "[*] Successfully imported the PS Module "
    }
    catch
    {
        Write-Host -ForegroundColor Red "[!] Failed to import the PS Module "

        return
    }

    try
    {
        Write-Host -ForegroundColor Yellow "[*] Attempting to download and install updates... "

        Install-WindowsUpdate -MicrosoftUpdate -AccpetAll -AutoReboot

        $time_stamp = Get-Date

        $computername = $env:COMPUTERNAME

        $installed_patches = Get-Hotfix | Select-Object HotFixID,InstalledOn

        $patches = @()

        $installed_patches | Foreach-Object { $patch = $_.HotFixID ; $date = $_.InstalledOn ; $patches += ($patch,$date) }

        Send-MailMessage -SmtpServer 10.10.1.194 -To "robert.gaines@homelab.local" -From "winlab.update@homelab.local" -Subject "Patch Report: $computername" -Body " Patching Completed on: $computername `n Timestamp: $time_stamp `n Current Patches: `n $patches "

        Write-Host -ForegroundColor Green "[*] Updates installed, report transmitted "
    }
    catch
    {
        Write-Host -ForegroundColor Red "[!] Failed to download/install updates "
    }

}

main