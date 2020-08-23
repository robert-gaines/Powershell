# Add a New FirewallRule #
function main()
{
    Write-Host -ForegroundColor Green "[*] Firewall Rule Addition Script [*]"

    $name      = Read-Host "[+] Enter the display name-> "
    $direction = Read-Host "[+] Enter the direction-> (Inbound/Outbound)"
    $port      = Read-Host "[+] Enter the local port-> "
    $action    = Read-Host "[+] Enter the rule's action-> (allow/block) "
    $protocol  = Read-Host "[+] Enter the protocol-> (TCP/UDP) "

    try 
    {
        Write-Host -ForegroundColor Yellow "[~] Attempting to add rule"

        New-NetFirewallRule -DisplayName $name      `
                            -Direction   $direction `
                            -LocalPort   $port      `
                            -Action      $action    `
                            -Protocol    $protocol  `

        Write-Host -ForegroundColor Green "[*] Successfully added firewall rule "
    }
    catch 
    {
        Write-Host -ForegroundColor Red "[!] Failed to add host firewall rule"
    }
}

main