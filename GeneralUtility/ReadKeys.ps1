# Read Keystrokes #

$buffer = ""

while($True)
{
    $key = [System.Console]::ReadKey()

    if($key.Key -eq "Spacebar")
    {
        $key = " "
        $buffer += $key
    }
    else 
    {
        $buffer+= $key.Key    
    }

    Write-Host $buffer
}