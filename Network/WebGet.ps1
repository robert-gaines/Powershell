# Script to Mimic WGET #
function main()
{
    Write-Host -ForegroundColor Blue "[*] Powershell Web Get [*]"

    $target = Read-Host "[+] Enter the URL "
    $output = Read-Host "[+] Enter the output filename "

    Write-Host -ForegroundColor Yellow "[*] Attempting download..."

    try {
        Invoke-WebRequest -OutFile $output $target

        Write-Host -ForegroundColor Green "[*] Download successful "
    }
    catch {
        Write-Host -ForegroundColor Red "[!] Failed to download file [!]"
    }
}

main