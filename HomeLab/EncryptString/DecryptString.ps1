        

$ciphertext_test = Test-Path -Path 'ciphertext.txt'

if($ciphertext_test)
{
    try
    {
        $secure_string = Get-Content -Path "ciphertext.txt" | ConvertTo-SecureString

        $temp = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure_string)

        $password = [Runtime.InteropServices.Marshal]::PtrToStringAuto($temp) 
        
        Write-Host -ForegroundColor Green "[*] Plaintext password: $password "  
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
