
while($true)
{
    $processes = @()

    $processes = Get-Process | Where-Object { $_.CPU -gt 5.0 } 

    Write-Host -ForegroundColor Yellow "[*] High CPU Utilization Processes "

    Write-Host -ForegroundColor Yellow "__________________________________ "

    $processes | Foreach-Object { Write-Host -ForegroundColor Yellow "$_.ProcessName `t", $_.CPU ; Start-Sleep -Seconds 1 }

    Clear-Host
}