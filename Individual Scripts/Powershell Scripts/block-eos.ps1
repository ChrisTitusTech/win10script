# This blocks EpicGames Online Service Bloat
# https://steamcommunity.com/sharedfiles/filedetails/?id=2594056744&tscn=1630889353

$content= Invoke-WebRequest -Uri 'https://www.thicc-thighs.de/hosts' 
$file = "$env:windir\System32\drivers\etc\hosts"
$content | Add-Content -PassThru $file