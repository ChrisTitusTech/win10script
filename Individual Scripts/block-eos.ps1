$content= Invoke-WebRequest -Uri 'https://www.thicc-thighs.de/hosts' 
$file = "$env:windir\System32\drivers\etc\hosts"
$content | Add-Content -PassThru $file