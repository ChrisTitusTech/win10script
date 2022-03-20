$content= Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/Brandonbr1/ad-list-hosts/main/host' 
$file = "$env:windir\System32\drivers\etc\hosts"
$content | Add-Content -PassThru $file