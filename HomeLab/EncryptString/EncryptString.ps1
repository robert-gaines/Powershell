<#
   Storing plaintext credentials at rest is generally a bad idea.
   This script converts a string value to an encrypted string stored
   in a text file
 #>

$plaintext = Read-Host "[+] Enter the plaintext string-> " 

try
{
    $convert_string = $plaintext | ConvertTo-SecureString -AsPlainText -Force

    $cipher_text = $convert_string | ConvertFrom-SecureString 

    $cipher_text | Out-File 'ciphertext.txt' -Encoding UTF8

    Write-Host -ForegroundColor Green "[*] Cipher text written to: ciphertext.txt "
}
catch
{
   Write-Host -ForegroundColor Red "[!] Failed to encipher the string" 
}

