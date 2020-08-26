$attempt = Connect-AZAccount -Credential (Get-Credential)

if($attempt)
{
    Write-Host -ForegroundColor Green "[*] Connected to Azure Tenant"
}
else 
{
    Write-Host -ForegroundColor Red "[!] Failed to connect to tenant "    
}