$server = Read-Host "[+] Server Name: "

Stop-VM -ComputerName $server -VMName * 