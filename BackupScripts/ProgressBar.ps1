
$file = Get-ChildItem -Path "C:\"

for($i = 0; $i -lt 100; $i++)
{
    Write-Progress -Activity "Testing" -Status "File: $i" -PercentComplete $i
    Write-Host $file | Select name
}