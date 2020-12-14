
function Display-String
{
    [CmdletBinding()]
    param(
        [string] $displayString
    ) 
    Write-Host $DisplayString
}

Display-String -DisplayString "This is a test"