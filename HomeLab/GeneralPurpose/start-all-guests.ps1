$server = Read-Host "[+] Server Name "

Start-VM -ComputerName $server -VMName * 