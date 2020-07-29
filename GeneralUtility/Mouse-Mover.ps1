
try
{
    Copy-Item -Path MouseMover.exe -Destination C:\Temp -Force
}
catch
{
    exi
}



$action = New-ScheduledTaskAction -Execute "C:\Temp\MouseMover.exe" 

$user = $env:USERNAME

$trigger = New-ScheduledTaskTrigger -AtLogOn

Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "MoveMouse" -User $user -Description "Move the mouse!" -RunLevel Highest -Force