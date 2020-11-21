
function PlayTones()
{
    <# Tone | Duration #>

    $toneCombos = @(
                        (900,400),
                        (1000,400),
                        (800,400),
                        (400,400),
                        (600,1600) 
                   )

    $toneCombos | Foreach-Object {
                                    $entry = $_ 
                                    $tone = $entry[0]
                                    $duration = $entry[1]

                                    [console]::beep($tone,$duration)
                                 }
}


function PlayFastTones()
{
    <# Tone | Duration #>

    $toneCombos = @(
                        (900,100),
                        (1000,100),
                        (800,100),
                        (400,100),
                        (600,800) 
                   )

    $toneCombos | Foreach-Object {
                                    $entry = $_ 
                                    $tone = $entry[0]
                                    $duration = $entry[1]

                                    [console]::beep($tone,$duration)
                                 }
}

function main()
{
    PlayTones

    for($i = 0; $i -le 100;$i++)
    {
        PlayFastTones

        Start-Sleep -Seconds 3
    }
}

main