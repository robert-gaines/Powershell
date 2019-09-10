# Powershell Port Scanner #

$subjectHost = Read-Host "[+] Enter the host IP-> " 

$sport = 1 ; $eport = 1024

while($sport -lt $eport)
{
    $response = Test-NetConnection -ComputerName $subjectHost -Port $sport -InformationLevel Quiet
    
    if($response -eq 1)
    {
        Write-Host -BackgroundColor Gray -ForegroundColor Green  "[*] Open port-> $subjectHost : $sport "
    }
    else {
        Write-host -BackgroundColor Black -ForegroundColor Red "[!] Port closed/filtered-> $subjectHost : $sport "
    }
    $sport++
}
