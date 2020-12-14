
$server = Read-Host "[+] Server Name "

$guests = @() ; Get-VM -ComputerName $server | Where-Object { $_.State -eq 'Running' } | Foreach-Object { $guests += $_ }

$credential = Get-Credential

$guests | Foreach-Object { 

                            $current_host = $_.Name
                            
                            Write-Host -FOregroundColor Yellow "[~] Updating: $current_host "

                            try
                            {
                                Invoke-Command -ComputerName $current_host -Credential $credential -ScriptBlock { gpupdate /force ; Restart-Computer -Force -Confirm:$false }

                                Write-Host -ForegroundColor Green "[*] Group Policy Updated on: $current_host "
                            }
                            catch
                            {
                                Write-Host -ForegroundColor Red "[!] Failed to interact with: $_"
                            }
                            
                         }

