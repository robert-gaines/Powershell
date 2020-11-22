$stopwatch =  [system.diagnostics.stopwatch]::StartNew()

while($true)
{
    $hours = $stopwatch.Elapsed.Hours
    $minutes = $stopwatch.Elapsed.Minutes
    $seconds = $stopwatch.Elapsed.Seconds
    $milliseconds = $stopwatch.Elapsed.Milliseconds

    Write-Host -ForegroundColor Green "[*] Elapsed: $hours : $minutes : $seconds : $milliseconds  " ; Start-Sleep -Seconds 1 ; Clear-Host
}