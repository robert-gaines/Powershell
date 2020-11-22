<# Query Processes #>

Write-Host -ForegroundColor Yellow "[*] WMI Process Query "

$query = Read-Host "[+] Enter the process name "

$send_query = Get-WmiObject -Class Win32_Process | Where-Object {$_.Name -eq $query}

if($send_query)
{
    Write-Host -ForegroundColor Green "[*] Process is present "

    $name = $send_query.ProcessName
    $id   = $send_query.ProcessId

    Write-Host -ForegroundColor Green "ProcessName: $name "
    Write-Host -ForegroundColor Green "Process ID:  $id "
}
else
{
    Write-Host -ForegroundColor Red "[!] The process does not appear to be present "    
}