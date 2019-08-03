# Creates a new Directory #

Write-Host "[*] Directory Creation Script [*]"

$cwd = pwd

Write-Host "[*] Your current working directory-> $cwd "

$targetPath = Read-Host "[+] Enter the directory path-> "

Write-Host "[*] Creating a new director at: $targetPath "

$result = New-Item -ItemType Directory -Path $targetPath

if($result)
{
    Write-Host "[*] Directory successfully created at: $targetPath "
}
else {
    Write-Host "[!] Directory creation failed..."
}
exit