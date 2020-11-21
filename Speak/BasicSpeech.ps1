Add-Type -AssemblyName System.Speech

$speakObject = New-Object System.Speech.Synthesis.SpeechSynthesizer

# $speakObject.GetInstalledVoices() | Foreach-Object{ $_.VoiceInfo }

$speakObject.SelectVoice('Microsoft Zira Desktop')

$speakObject.Volume = 100

$speakObject.Rate = -3

#$speakObject.Speak("This is a test")

