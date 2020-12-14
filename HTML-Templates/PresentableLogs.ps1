$fileName = "$env:COMPUTERNAME"+"_EventViewerLogs.html"

Get-EventLog -LogName * |  ConvertTo-HTML -Property MachineName , EventId, TimeGenerated -Title "WIN Event Logs" | Out-File -Append $fileName

#et-EventLog -LogName * | Foreach-Object { Write-Host $_.Log  ; Get-EventLog -LogName $_.Log | ConvertTo-HTML -Property MachineName ,EventId,TimeGenerated -Title "WIN Event Logs" | Out-File -Append $fileName}