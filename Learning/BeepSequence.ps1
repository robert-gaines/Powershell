# Console Beep Sequence #

<# for($i = 100; $i -le 1000; $i+=100)
{
    for($j = 100; $j -le 1000; $j+=100)
    {
        Write-Host $i"|"$j

        [Console]::Beep($i,$j)
    }
} #>

$leftArgument = 1000 ; $rightArgument = 200

while($leftArgument -gt 0)
{
    [Console]::Beep($leftArgument,$rightArgument)
    $leftArgument -= 100
}

$leftArgument = 100

while($leftArgument -lt 1000)
{
    [Console]::Beep($leftArgument,$rightArgument)
    $leftArgument += 100
}