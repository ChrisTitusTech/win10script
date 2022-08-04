$adlist= Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/Brandonbr1/ad-list-hosts/main/host' # Repo: https://github.com/Brandonbr1/ad-list-hosts/
$adfile = "$env:windir\System32\drivers\etc\hosts"
$adlist | Add-Content -PassThru $adfile