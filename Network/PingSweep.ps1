# Ping Sweep #

function GenerateFileName()
{
    $timeStamp = Get-Date -Format o | Foreach-Object{ $_ -replace ":",'.' }

    $fileName = "LiveHosts_"+$timeStamp+".txt"

    return $fileName
}
function main()
{
 Write-Host -ForegroundColor Blue "*** PS Ping Sweep ***"

 $start  = Read-Host "[+] Starting host index-> "
 $finish = Read-host "[+] Last host index-> "

 $network = Read-Host "[+] Enter the network ID-> "

 Write-Host -ForegroundColor Blue "[*] Starting host-> ",$start
 Write-Host -ForegroundColor Blue "[*] Last host->     ",$finish
 Write-host -ForegroundColor Blue "[*] Network ID->    ",$network
 Write-Host -ForegroundColor Yellow "[*] Beginning sweep "
 $start = [Int]::Parse($start)
 $finish= [Int]::Parse($finish)

 $segments = $network.Split('.')

 $baseAddress = ""

 $fileName = GenerateFileName ; Out-File $fileName

 for($i = 0; $i -lt $segments.length-1; $i++)
 {
     $baseAddress += $segments[$i]
     $baseAddress += '.'
 }

 while($start -le $finish)
 {
     $addr = [System.String]::Concat($baseAddress,$start)
     
     $result = Test-Connection -ComputerName $addr -Count 1 -Quiet
     
     if($result)
     {
         Write-Host -ForegroundColor Green "[*] Host alive at->`t   ",$addr
         $liveHost = "[*] Host alive at-> $addr`n"
         $liveHost | Add-Content $fileName 
     }
     else 
     {
        Write-Host -ForegroundColor Red "[!] Host unresponsive at-> ",$addr    
     }
     $start++
 }
}

main
