# From the Windows Powershell Cookbook #

# Add a default value for a parameter in a cmdlet #

$PSDefaultParameterValues["Get-Process:ID"] = $pid 

Get-Process