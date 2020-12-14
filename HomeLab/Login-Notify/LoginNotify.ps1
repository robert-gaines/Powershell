<# Notify the administrator that a user has logged into a domain device #>

function LoginNotify()
{
   $hostname = $env:COMPUTERNAME

   $user = $env:USERNAME

   $timestamp = Get-Date

   $message = "ALERT `n ---- TIMESTAMP: $timestamp `n HOST: $hostname `n USER LOGIN: $user" 
   
   Send-MailMessage -SmtpServer <SMTP RELAY> -Subject "Host: $hostname | User Login: $user" -To robert.gaines@homelab.local -From "winlab.mailer@homelab.local" -Body $message  
}

LoginNotify