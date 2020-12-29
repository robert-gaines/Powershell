<# Send a Login Notification with Geographic data #>

function DecryptString()
{
    $ciphertext_test = Test-Path -Path 'ciphertext.txt'

    if($ciphertext_test)
    {
        try
        {
            $secure_string = Get-Content -Path "ciphertext.txt" | ConvertTo-SecureString

            $temp = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure_string)

            $password = [Runtime.InteropServices.Marshal]::PtrToStringAuto($temp) 
        
            return $password
        }
        catch
        {
            Write-Host -ForegroundColor Red "[!] Decryption sequence failed "
        }
    }
    else
    {
        Write-Host -ForegroundColor Red "[!] Failed to locate the file: ciphertext.txt"
    }
}

function main()
{
    Write-Host -ForegroundColor Green "[*] Geo-IP Login Notification Script "

    <# Identify the WAN IP #>

    try
    {
        $wan_ip = (Invoke-WebRequest -uri "http://ifconfig.me/ip").Content

        Write-Host -ForegroundColor Green "[*] WAN IP: $wan_ip "
    }
    catch
    {
        Write-Host -ForegroundColor Red "[!] Failed to identify WAN IP"

        exit
    }

    <# Geo-locate the WAN IP #>

    try
    {
        $api_token = "7bc9875b10996bd5beeb917c1c5bb970"

        $uri       = "http://api.ipstack.com/{0}?access_key={1}" -f $wan_ip,$api_token

        $geo_data  = Invoke-RestMethod -Method GET -Uri $uri 

        $ip      = $geo_data.ip
        $city    = $geo_data.city
        $zip     = $geo_data.zip
        $state   = $geo_data.region_name
        $country = $geo_data.country_name
        $lat     = $geo_data.latitude
        $long    = $geo_data.longitude

    Write-Host -ForegroundColor Green " `
    IP:        $ip `
    City:      $city `
    Zip:       $zip `
    State:     $state `
    Country:   $country `
    Latitutde: $lat `
    Longitude: $long "

    <# Send report via e-mail #>

        try
        {
            $computerName = $env:COMPUTERNAME

            $dateTime     = Get-Date

            $username     = "robert.winston.gaines@outlook.com"

            $password     = DecryptString

            $password     = $password | ConvertTo-SecureString -AsPlainText -Force

            [pscredential]$credentials = New-Object System.Management.Automation.PSCredential ($username, $password)

$body = "
New Login: $computerName `
Date/Time: $dateTime `
IP:        $ip `
City:      $city `
Zip:       $zip `
State:     $state `
Country:   $country `
Latitutde: $lat `
Longitude: $long "

            Send-MailMessage -To "15093199075@tmomail.net" `
                             -From "robert.winston.gaines@outlook.com" `
                             -Subject "Login: $computerName " `
                             -Body $body `
                             -UseSsl:$true `
                             -SmtpServer "smtp-mail.outlook.com" `
                             -Port 587 `
                             -Credential $credentials 
        }
        catch
        {
            Write-Host -ForegroundColor Red "[!] Failed to transmit report "
        }

    }
    catch
    {
        Write-Host -ForegroundColor Red "[!] Geo-location sequence failed "

        exit
    }
}

main