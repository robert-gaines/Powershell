
function PadString($str_var,$max_len)
{
    $new_var = ''

    if($str_var.Length -lt $max_len)
    {
        while($str_var.Length -ile $max_len)
        {
            $str_var += ' '
        }
        return $str_var  
    }
    else
    {
        $new_var = $str_var
        return $new_var
    }
}

function FindMaxLen($arr)
{
    $max_strelen = 0

    $temp_array | Foreach-Object {
                                    $entry = $_

                                    if($entry.Length -gt $max_strlen)
                                    {
                                          $max_strlen = $entry.Length
                                    }
                                                                                     
                                  }

    return $max_strlen
}

while($true)
{
    $established_connections = Get-NetTCPConnection | Where-Object { $_.State -contains 'Established' }

    Write-Host -ForegroundColor Yellow "[*] Established network connections "

    Write-Host -ForegroundColor Yellow "----------------------------------- "

    $established_connections | Foreach-Object {
                                                $laddr = $_.LocalAddress
                                                $lport = $_.LocalPort
                                                $raddr = $_.RemoteAddress
                                                $rport = $_.RemotePort
                                                try
                                                {
                                                       $lhost = ([System.Net.Dns]::GetHostEntry($laddr).HostName)
                                                       $rhost = ([System.Net.Dns]::GetHostEntry($raddr).HostName)
                                                }
                                                catch
                                                {
                                                       $lhost = $laddr 
                                                       $rhost = $raddr    
                                                }

                                                $temp_array = @($laddr,$lport,$raddr,$rport,$lhost,$rhost)

                                                <# $max_length = FindMaxLen $temp_array #>
                                                <#
                                                $format_laddr = PadString $laddr $max_length
                                                $format_lport = PadString $lport $max_length
                                                $format_raddr = PadString $raddr $max_length
                                                $format_rport = PadString $rport $max_length
                                                $format_lhost = PadString $lhost $max_length
                                                $format_rhost = PadString $rhost $max_length
                                                #>

                                                Write-Host -ForegroundColor Yellow "$laddr | $lport | $lhost <-> $raddr | $rport | $rhost"
                                              }

    Start-Sleep -Seconds 1

    Clear-Host

}
