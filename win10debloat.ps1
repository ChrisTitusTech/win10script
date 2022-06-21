Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$ErrorActionPreference = 'SilentlyContinue'
$wshell = New-Object -ComObject Wscript.Shell
$Button = [System.Windows.MessageBoxButton]::YesNoCancel
$ErrorIco = [System.Windows.MessageBoxImage]::Error
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
	Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
	Exit
}

# GUI Specs
Write-Host "Checking for Winget..."

# If Winget isn't Installed, Open App Installer Store Page to Install
if (!(Get-AppPackage -name 'Microsoft.DesktopAppInstaller')) {
    Write-Host "Winget not Found, Installing Now"
    Start-Process "ms-windows-store://pdp/?ProductId=9NBLGGH4NNS1"
    $nid = (Get-Process WinStore.App).Id; Wait-Process -Id $nid
    Write-Host "Winget Successfully Installed"
}

Write-Host "Script has been updated, launching video and new github project."
Start-Process "https://www.youtube.com/watch?v=tPRv-ATUBe4"
Start-Process "https://christitus.com/windows-tool/"
