# From: Windows Powershell Cookbook #

$handleCount = 0

foreach($process in Get-Process)
{
    $handleCount += $process.Handles
}

Write-Host -ForegroundColor Blue "[*] Total Handles: ", $handleCount