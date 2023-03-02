$timeStamp = Get-Date -Format "dddd_MM_dd_yyyy_HH_mm"

$fileName = $timeStamp+"_fais_computers.csv"

Get-ADComputer -SearchBase "OU=Finance and Administration,OU=WSU,DC=ad,DC=wsu,DC=edu" -Filter * -Properties * | Select-Object Name,LastLogonDate | Out-File -FilePath $fileName