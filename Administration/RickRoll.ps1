
function RickRoll()
{
    try
    {
        start microsoft-edge:https://www.youtube.com/watch?v=dQw4w9WgXcQ
    }
    catch
    {
        Write-Host -ForegroundColor Red "[!] Failed to open web browser "

        Start-Sleep -Seconds 1

        exit
    }
}

RickRoll