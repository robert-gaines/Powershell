# From: Windows Powershell Cookbook #

Get-Process | Where-Object { $_.Handles -ge 500 } | Sort-Object Handles | Format-Table Handles,Name,Description -Auto