# Check File Permissions #

$ErrorActionPreference = "SilentlyContinue"
function main()
{
    Get-ChildItem -Path "C:\" -Force -Recurse | Foreach-Object{ $res = Get-ACL $_.FullName ; Write-Host -ForegroundColor blue $res.Owner,"|",$res.Access.FileSystemRights ; Start-Sleep -Seconds 1; Write-Host "`n" }
}

main