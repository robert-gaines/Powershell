$timeStamp = Get-Date -Format "dddd_MM_dd_yyyy_HH_mm"

$dirName = $timeStamp+"_fais_computers_gpo"

mkdir $dirName 

#Get-GPResultantSetofPolicy -Computer $_.Name -ReportType XML -Path $fileName#

Get-ADComputer -SearchBase "OU=Finance and Administration,OU=WSU,DC=ad,DC=wsu,DC=edu" -Filter * | Foreach-Object { Get-GPResultantSetofPolicy -Computer $_.DistinguishedName -ReportType Html -Path $dirName+"\"+$_.DistinguishedName+".xml"  } 