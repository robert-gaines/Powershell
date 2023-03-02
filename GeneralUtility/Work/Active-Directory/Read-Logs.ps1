# Windows Event Viewer - Log Parser #

$timeStamp = Get-Date -Format "dddd_MM_dd_yyyy_HH_mm"

$fileName = $timeStamp+"_parsed_logs.txt"

Get-ChildItem -Path C:\Users\robert.gaines\Desktop\Main\Powershell\Budget-Logs\ | ForEach-Object {

    try
    {
        Get-WinEvent -Path $_.FullName | Select-Object TimeCreated,Message | Out-File -FilePath $fileName -Append
    }
    catch
    {
        Write-Host -ForegroundColor Red "[!] Parsing Error "
    }

}