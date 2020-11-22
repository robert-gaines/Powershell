<# Invoke Web Request Overview #>

Write-Host -ForegroundColor Green "[*] Collecting IP Address via Invoke-WebRequest cmdlet"

$response = Invoke-WebRequest -Uri 'http://icanhazip.com/' -UseBasicParsing

Write-Host $response