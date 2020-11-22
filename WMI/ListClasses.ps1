<# List all of the Win32 Classes from the root namespace #>

Get-WMIObject -List -Class win32* | Select-Object Name | Out-File -Append "Win32_Classes_List.txt"