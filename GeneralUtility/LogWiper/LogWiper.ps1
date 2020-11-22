# Script designed to traverse the file system and remove log files #

$ErrorActionPreference = "SilentlyContinue"

Get-ChildItem -Path C:\ -Recurse -Force -Include *.log | ForEach{ Write-Host -ForegroundColor Blue "[*] Removing: ",$_.FullName ; del $_.FullName }

