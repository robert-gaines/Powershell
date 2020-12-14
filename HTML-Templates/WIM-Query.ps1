
$os_query = Get-WMIObject -Class Win32_OperatingSystem | ConvertTo-HTML -Fragment
$bios_query = Get-WMIObject -Class Win32_BIOS | ConvertTo-HTML -Fragment
$service_query = Get-WMIObject -Class Win32_Service | ConvertTo-HTML -Fragment

ConvertTo-HTML -Body "$os_query $bios_query $service_query" -Title "WMI Report" | OUt-File WMI_Report.html