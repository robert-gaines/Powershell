<# Remove Servers from a Lab Environment #> 

function RemoveADObjects($servers)
{
    Write-Host -ForegroundColor Yellow "[*] Removing Active Directory Objects for each server... "

    $servers | Foreach-Object {
                                    $server = $_.SERVER

                                    Write-Host -ForegroundColor Red "[*] Removing AD Object for: $server "

                                    try
                                    {
                                        Remove-ADComputer -Identity $server -Confirm:$false

                                        Write-Host -ForegroundColor Green "[*] Successfully removed: $server "
                                    }
                                    catch
                                    {
                                        Write-Host -ForegroundColor Red "[!] Failed to remove: $server "
                                    }
                              }
}

function RemoveVM($servers)
{
    $servers | Foreach-Object { $vm = $_.Server ; Remove-VM $vm -Confirm:$false }
}

function RemoveDirectory($directory)
{
    try
    {
        Remove-Item -Force -Recurse -Path $directory | Out-Null

        Write-Host -ForegroundColor Green "[*] Removed storage directory for VMs"
    }
    catch
    {
        Write-Host -ForegroundColor Red "[!] Failed to remove the VM storage directory "

        return
    }
}

function main()
{
    Write-Host -ForegroundColor Green "[*] Hyper-V Server Removal Script "

    $storage_directory = "G:\Shares\StorageTwo\Servers"

    $check_server_list = Test-Path -Path .\servers.csv

    if($check_server_list)
    {
       $server_list = Import-CSV -Path .\servers.csv 
    }
    else
    {
        Write-Host -ForegroundColor Red "[!] Failed to locate server inventory "

        return
    }

    Write-Host -ForegroundColor Yellow "[*] Listing server candidate names and IPs `n"

    $server_list | Foreach-Object { $server = $_.Server; Write-Host -ForegroundColor Yellow " `t $server" }

    RemoveADObjects $server_list

    RemoveVM $server_list

    RemoveDirectory $storage_directory
}

main


