
<#
    Gather Logon Data for the Current User's Session
    Author: RWG - 08/05/2020
 #>

function ConvertTime($zulu)
{
    $local_timezone = (Get-WMIObject win32_timezone).StandardName 

    $conv_timezone = [System.TimeZOneINfo]::FindSystemTImeZoneById($local_timezone)

    $converted_time = [System.TimeZOneInfo]::ConvertTimeFromUTC($zulu,$conv_timezone)

    return $converted_time
}

function ConvertToUniversal($machine_time)
{
    $human_time = [System.Management.ManagementDateTimeConverter]::ToDateTime($machine_time).ToUniversalTime()

    return $human_time
}

function TruncateDateTime($date_time)
{
    $ret_string = ''

    $i = 0;

    while($date_time[$i] -ne ':')
    {
        $i++
    }

    $i += 1

    $string_length = $date_time.Length-$i

    $ret_string = $date_time.substring($i,$string_length)

    return $ret_string
}

function TimeRemaining($current,$expiration)
{
    $time_remaining = ''

    $segments = $current.split(' ')
    $temp = $segments[1]+' '+$segments[2]
    $current_conv = [datetime]::parseexact($temp, 'M/d/yyyy H:mm:ss', $null) 

    $segments_two = $expiration.split(' ')
    $temp_two = $segments_two[1]+' '+$segments_two[2]
    $exp_conv = [datetime]::parseexact($temp_two, 'M/d/yyyy H:mm:ss', $null) 

    try
    {
        $time_remaining = New-TimeSpan -Start $current_conv -End $exp_conv
        
        return $time_remaining.Days
    }
    catch
    {
        return $null
    }
}

function ExamineTickets()
{
    try
    {
        $tgt_data = klist tgt
        $service = $tgt_data[5].split(':')[1]
        $key = $tgt_data[12].split(':')[1]
        $domain = $tgt_data[8].split(':')[1]
        $user = $tgt_data[7]
        $user = $user.Split(':')[1]
        $datetime_start = TruncateDateTime $tgt_data[14]
        $datetime_end   = TruncateDateTime $tgt_data[15]
        $datetime_exp   = TruncateDateTime $tgt_data[16]
        $time_remaining = TimeRemaining $datetime_start $datetime_exp
        Write-Host -ForegroundColor Green "   
Kerberos - Ticket Granting Ticket Data
--------------------------------------
User: $user
Service: $service
Key: $key
Domain: $domain
Ticket - Start Validity Period: $datetime_start
Ticket - End Validity Period:   $datetime_end
--------------------------------------
Ticket Expires: $datetime_exp
Days Till Expiration: $time_remaining
                                          "
    Start-Sleep -Seconds 3
    return $time_remaining

    }
    catch
    {
        Write-Host -ForegroundColor Red "[!] Failed to collect ticket data..."

        return $null
    }  
}

function ProfileLastModified()
{
    try
    {
        $user_properties = whoami /user 

        $user_data = $user_properties[6]

        $sid_value = $user_data.split('')[1] 

        Write-Host -ForegroundColor Yellow "[*] Identified current user SID: $sid_value "

        $profile_query = Get-WmiObject -Class win32_UserProfile | Select-Object SID,LastUseTime | Where-Object { $_.SID -eq $sid_value }

        $profile_last_modified = $profile_query.LastUseTime

        $gmt_time = ConvertToUniversal $profile_last_modified

        $standard_time = ConvertTime $gmt_time 

        Write-Host -ForegroundColor Green "[*] User Profile: $env:USERNAME was last modified at-> $standard_time "

        Start-Sleep -Seconds 1
    }
    catch
    {
        Write-Host -ForegroundColor Red "[!] Failed to run User Profile Queries [!]"

        Start-Sleep -Seconds 1

        #exit
    }
}

function CollectLogonData()
{
    Write-Host -ForegroundColor Yellow "[~] Gathering logon session data..."

    $logon_values = Get-WMIObject -Class win32_logonSession

    $logon_values | Foreach-Object { 
                                       $logon_id     = $_.LogonId
                                       $auth_package = $_.AuthenticationPackage
                                       $machine_time = $_.StartTime
                                       $human_time   = ConvertToUniversal($machine_time)
                                       $local_time   = ConvertTime($human_time)
                                       Write-Host -ForegroundColor Green "[*] Session ID: $logon_id | Method: $auth_package -> Session Start: $local_time "
                                   }
   Start-Sleep -Seconds 1
}

function DisplayWarning($days_remaining)
{
    try
    {
        Add-Type -AssemblyName System.Windows.Forms

        $global:balloon_message = New-Object System.Windows.Forms.NotifyIcon

        $path = (Get-Process -id $pid).Path
        
        $balloon_message.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($path)

        $balloon_message.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Warning

        $balloon_message.BalloonTipText = 
        "         
Please connect to the WSU VPN
Days Till Credential Expiration: $days_remaining 
        
        "

        $balloon_message.BalloonTipTitle = "Attention: $env:USERNAME "

        $balloon_message.Visible = $true

        $balloon_message.ShowBalloonTip(200000)
    }
    catch
    {
        return
    }
}

function MailNotification($days_remaining)
{
    $domain = '@'+$env:USERDNSDOMAIN.split('.')[1]+'.'+$env:USERDNSDOMAIN.split('.')[2]
    $account = $env:USERNAME
    $addr = $account+$domain
    $addr = $addr.ToLower()
    $body = "

<b>

NOTE: This message was generated automatically. Please do not respond to this address.

<br><br><br>

<p style='font-weight: bold;'>

Greetings & Salutations,

<br><br><br>

The purpose of this message is to remind you that the cached authentication data that
supports your ability to sign into your computer will expire in <u>$days_remaining days</u>. Please
connect to the Washington State University VPN by using the Global Protect application
that is installed on your device.

<br><br><br>

Thank you,

<br><br><br>

The Finance & Administration Information Systems Team

<br><br><br>

</p>

NOTE: This message was generated automatically. Please do not respond to this address. 

<br><br><br>

</b>
            "

    try
    {
        Send-MailMessage -From 'fais@wsu.edu' -To $addr -Subject "Expiration of Cached Credentials" -BodyAsHtml $body -SmtpServer smtp.wsu.edu          
    }
    catch
    {
        return
    }
}

function main()
{
    WRite-Host -ForegroundColor Green "[*] User Logon Data Examination Script [*]"

    Write-Host -ForegroundColor Green  "------------------------------------------"

    Write-Host ''

    Write-Host -ForegroundColor Green "[*] Current user is: $env:USERNAME "

    Write-Host ''

    CollectLogonData
    
    ProfileLastModified
    
    $days_remaining = ExamineTickets

    DisplayWarning $days_remaining

    MailNotification $days_remaining
}

main

