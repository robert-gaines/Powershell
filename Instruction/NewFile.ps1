# File Creation Script #

Write-Host "[*] File Creation Script [*]"

$cwd = pwd

Write-Host "[*] Your current directory-> $cwd "

$subjectFile = Read-Host "[+] Enter the path and filename-> "

Write-Host "[*] Creating a new file at: $subjectFile "

$result = New-Item -ItemType File -Path $subjectFile 

if($result)
{
    Write-Host "[*] File created at: $subjectFile "
}
else {
    Write-Host "[!] File creation failed..."
}

