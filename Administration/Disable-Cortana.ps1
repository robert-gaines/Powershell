$ErrorActionPreference = 'SilentlyContinue'

function AddCortanaKey()
{
    $check_path = Test-Path -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search\'

    if($check_path)
    {
        Write-Host -ForegroundColor Green "[*] Located the Windows Search Registry Path "
    }
    else
    {
        Write-Host -ForegroundColor Red "[!] Failed to locate the Registry Path for Windows Search"

        Start-Sleep -Seconds 1

        exit
    }

    try
    {
        New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search' -Name DisableCortana -PropertyType DWORD -Value 0

        Write-Host -ForegroundColor Green "[*] Added Registry Key - Disabled Status "
    }
    catch
    {
        Write-Host -ForegroundColor Red "[!] Failed to add the registry value "
    }
}

function main()
{
    AddCortanaKey
}

main