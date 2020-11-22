<# Query Remote System for Free Space #>

Write-Host -ForegroundColor Yellow "[*] Query Disk Space "

$remote_host = Read-Host "Enter the machine name "

$credential = Get-Credential

$result = Get-WMIObject -Class Win32_Logicaldisk -Filter "DeviceId='C:'" -ComputerName $remote_host -Credential $credential 

if($result)
{
    $freespace    = $result.FreeSpace/1GB
    $total_size   = $result.Size/1GB
    $percent_used = ($freespace/$total_size)*100 
    Write-Host -ForegroundColor Green "[*] Percent used: $percent_used "
    Write-Host -ForegroundColor Green "[*] Remaining space on the C drive for $remote_host in GB-> $freespace "
}
else 
{
    Write-Host -ForegroundColor Red "[!] Failed to execute query"    
}