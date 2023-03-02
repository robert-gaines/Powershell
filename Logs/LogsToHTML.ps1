$computerName = $env:COMPUTERNAME
$timeStamp    = Get-Date -Format hhmmss_MMddyyyy
$fileName     = $computerName+"_event_viewer_logs_"+$timeStamp+".html"

Get-EventLog -LogName * | Foreach-Object {
                                            Get-EventLog -LogName $_.Log | ConvertTo-Html | Out-File -Append $fileName
                                         }
