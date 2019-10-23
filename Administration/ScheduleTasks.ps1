# Schedule a Task #

$action = New-ScheduledTaskAction -Execute "powershell.exe C:\Users\TSSAdmin\Desktop\ClearProfile.ps1"

$user = "NT AUTHORITY\SYSTEM"

$trigger = New-ScheduledTaskTrigger -Daily -At 8am

Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "Clear Profile" -User $user -Description "Clear guest account profile" -RunLevel Highest -Force

