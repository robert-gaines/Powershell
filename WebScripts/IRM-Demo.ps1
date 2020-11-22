<# Invoke Rest Method #>

Write-Host -ForegroundColor Yellow "[*] Using the REST API to query Git Repo data"

$request = Invoke-RESTMethod https://api.github.com/users/robert-gaines/repos?per_page=100 

$repoCount = $request.Count

Write-Host -ForegroundColor Green "[*] Total Git Repos: $repoCount"

Write-Host -ForegroundColor Green "[*] Listing all repos "

$request | Foreach-Object {  Write-Host $_.Name }
