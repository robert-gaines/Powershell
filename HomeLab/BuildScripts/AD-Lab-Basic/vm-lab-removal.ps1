<# VM Lab Removal #>

function RemoveSwitches
{
    $adapter = Get-NetAdapter | Where-Object Name -Like "Ethernet"
    
    $extAdapter = $adapter.Name 

    try
    {
        Write-Host -ForegroundColor Yellow "[*] Removing the main external switch ..."

        Remove-VMSwitch -Name "EXT-MAIN" -Force 
        
        Write-Host -ForegroundColor Yellow "[*] Removing the main internal switch ..."
        
        Remove-VMSwitch -Name "INT-MAIN" -Force 

        Write-Host -ForegroundColor Yellow "[*] Removing the alternate internal switch ..."
        
        Remove-VMSwitch -Name "INT-ALT" -Force 
        
        Write-Host -ForegroundColor Yellow "[*] Removing the cluster internal switch ..."
        
        Remove-VMSwitch -Name "INT-CLUSTER" -Force  
        
        Write-Host -ForegroundColor Yellow "[*] Removing the private switch ..."  

        Remove-VMSwitch -Name "PRI-MAIN" -Force 
    }
    catch
    {
        WRite-Host -ForegroundColor Red "[!] Failed to remove a virtual switch [!]"
    }
}

function RemoveVM
{

    try
    {
        Remove-VM -Name "WIN-M-DC"    -Force
        Remove-VM -Name "WIN-M-CE-1"  -Force
        Remove-VM -Name "WIN-M-CE-2"  -Force
        Remove-VM -Name "WIN-M-CE-3"  -Force
        Remove-VM -Name "WIN-M-CE-4"  -Force
        Remove-VM -Name "WIN-M-DTP-1" -Force
        Remove-VM -Name "WIN-M-DTP-2" -Force
    }
    catch
    {
        Write-Host "[!] Failed to Remove VM [!]"
    }

}

function RemoveDisks
{
    $currentUser = $env:USERNAME

    Remove-Item -Force -Recurse -Path C:\Users\$currentUser\Desktop\Lab\VHD\

    Remove-Item -Force -Recurse -Path C:\Users\$currentUser\Desktop\Lab\Storage-VHD\ 
}

function ShutdownVM
{
    Get-VM | Foreach-Object {
                                $state = $_.State

                                if($state -ne "Off")
                                {
                                    Stop-VM -name $_.Name
                                }
                            }
}

function main()
{
    Write-Host -ForegroundColor Green "[*] VM Lab Removal Script [*]"

    ShutdownVM ; Start-Sleep -Seconds 15

    RemoveSwitches

    RemoveVM

    RemoveDisks

    Clear-Host
}

main