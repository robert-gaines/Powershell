
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "Start-Process microsoft-edge:https://www.youtube.com/watch?v=dQw4w9WgXcQ"

$user = $env:USERNAME

$trigger = New-ScheduledTaskTrigger -AtLogOn

Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "RickRoll" -User $user -Description "Rick Roll @ Logon" -RunLevel Highest -Force