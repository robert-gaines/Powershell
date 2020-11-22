<# Perform a DNS Lookup via REST request #>

Write-Host -ForegroundColor Yellow "[*] DNS Lookup via REST "

$base = "http://whois.arin.net/rest"

$ip = Read-Host "[+] Enter the IP to be resolved "

$composite_uri = "$base/ip/$ip"

$request = Invoke-RestMethod -Uri $composite_uri -Headers @{"Accept"="application/json"}

$hostname = $request.net.name

