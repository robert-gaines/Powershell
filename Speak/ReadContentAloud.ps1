Add-Type -AssemblyName System.Speech

$speakObject = New-Object System.Speech.Synthesis.SpeechSynthesizer

$speakObject.SelectVoice('Microsoft Zira Desktop')

$speakObject.Volume = 100

$speakObject.Rate = -3

try
{
    $text = Get-Content .\jabberwocky.txt

    $text | Foreach-Object {
                                $segment = $_ 
                                $speakObject.Speak($segment)
                           }
}
catch
{
    exit
}

#$speakObject.Speak("This is a test")