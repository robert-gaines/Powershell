Write-Host "[*] Resolution Modification Script [*}"

$X_VALUE = Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\UnitedVideo\CONTROL\VIDEO\{9CD679A5-A360-11E9-B85A-FA0C305DEF69}\0000' -Name "DefaultSettings.XResolution"
$Y_VALUE = Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\UnitedVideo\CONTROL\VIDEO\{9CD679A5-A360-11E9-B85A-FA0C305DEF69}\0000' -Name "DefaultSettings.YResolution"

Write-Host "Resolution: X Value->  "  $X_VALUE.'DefaultSettings.XResolution'
Write-Host "Resolution: Y Value->  "  $Y_VALUE.'DefaultSettings.YResolution'

$NEW_X_VALUE = Read-Host "[+] Enter the new X-Value-> "
$NEW_Y_VALUE = Read-Host "[+] Enter the new Y-Value-> "

Write-Host "[***] Setting New Resolution [****]"

Start-Sleep 1

Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\UnitedVideo\CONTROL\VIDEO\{9CD679A5-A360-11E9-B85A-FA0C305DEF69}\0000' -Name "DefaultSettings.XResolution" -Value $NEW_X_VALUE
Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\UnitedVideo\CONTROL\VIDEO\{9CD679A5-A360-11E9-B85A-FA0C305DEF69}\0000' -Name "DefaultSettings.YResolution" -Value $NEW_Y_VALUE

Write-Host "[*] Restarting Computer..."

Start-Sleep 1

Restart-Computer