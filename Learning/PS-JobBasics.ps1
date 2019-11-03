# PS Job Basics #

Start-Job { while($True){$var = Get-Random; Write-Host $var ; Start-Sleep -Seconds 1}} -Name FirstJob

Get-Job -Name FirstJob

$intake = Receive-Job -Name FirstJob

Write-Host $intake

Stop-Job -Name FirstJob