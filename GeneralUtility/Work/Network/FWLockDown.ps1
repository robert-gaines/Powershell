
$allow_rules = Get-NetFirewallRule | Where-Object {$_.Action -eq 'Allow'} | Select-Object Name

$allow_rules | Foreach-Object { $rule = $_.Name ; Set-NetFirewallRule -Name $rule -Action Block }