# Powershell Packet Sniffer #

function GenerateFileName()
{
    $timeStamp = Get-Date -Format o | Foreach-Object{ $_ -replace ":",'.' }

    $fileName = "Capture_"+$timeStamp+".etl"

    return $fileName
}
function StartCapture($capturePath)
{
    netsh trace start persistent=yes capture=yes tracefile=$capturePath
}

function main()
{
  Write-Host -ForegroundColor Blue "[*] Powershell Packet Sniffer [*]"

  $capturePath = Get-Location ; $capturePath = [string]$capturePath

  $captureFile = GenerateFileName ; $capturePath = $capturePath+'\'+$captureFile

  Write-Host -ForegroundColor Blue "[*] Starting packet capture "

  try{
    StartCapture($capturePath)
  }
  catch{
    Write-Host -ForegroundColor Red "[!] Failed to conduct packet capture [!]"
  }
  finally
  {
    netsh trace stop
  }

}

main