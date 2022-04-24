$uri = 'https://raw.githubusercontent.com/ChrisTitusTech/win10script/master/win10debloat.ps1'
$theHashIHave = Get-FileHash win10debloat.ps1 -Algorithm SHA256

try {
    $content = Invoke-RestMethod $uri
    $memstream = [System.IO.MemoryStream]::new(
        [System.Text.Encoding]::UTF8.GetBytes($content)
    )
    $thisFileHash = Get-FileHash -InputStream $memstream -Algorithm SHA256
    if($theHashIhave.Hash -eq $thisFileHash.Hash) {
        "Updated!"
    }
    else {
        "Update available!" # Thanks for Santiago Squarzon on stackoverflow for giving me this code!
        "Update? (y/n)"
        $YN = Read-Host "Choice"  
        if (yn -eq y){
            "Please download the new version and close this window."
            Start-Sleep -s 5
            Start-Process "https://github.com/ChrisTitusTech/win10script"
        }
        if (yn -eq n){
            exit
        }
    }
}
finally {
    $memstream.foreach('Dispose')
}