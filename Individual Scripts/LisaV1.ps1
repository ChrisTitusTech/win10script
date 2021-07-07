<#
Global Variables
#>
$ErrorActionPreference = 'SilentlyContinue'
del Log.log; Start-Transcript -Path 'Log.log'

<#
Fetch Administrator SID for later HKCU injection through SYSTEM account, and mount.
Also Mount HKEY_CLASSES_ROOT.
#>
Write-Host "Fetching Administrator Account SID" -ForegroundColor Green
$objUser = New-Object System.Security.Principal.NTAccount("Administrator")
$strSID = $objUser.Translate([System.Security.Principal.SecurityIdentifier])
$strSID.Value
Write-Host "Mount Administrator Registry Hive with alias HKU:\" -ForegroundColor Green
New-PSDrive -PSProvider Registry -Name HKU -Root HKEY_USERS\$strSID
New-PSDrive -PSProvider Registry -Name HKCR -Root HKEY_CLASSES_ROOT

<# First remove capabilities and features before further configuration. #>
Write-Host "Changing Windows Capabilities..." -ForegroundColor Green

if((Get-WindowsCapability -Name 'App.Support.QuickAssist~~~~0.0.1.0' -Online).State -eq "Installed") {
    Remove-WindowsCapability -Online -Name 'App.Support.QuickAssist~~~~0.0.1.0'
}
if((Get-WindowsCapability -Name 'Hello.Face.17658~~~~0.0.1.0' -Online).State -eq "Installed") {
    Remove-WindowsCapability -Online -Name 'Hello.Face.17658~~~~0.0.1.0'
}
if((Get-WindowsCapability -Name 'Hello.Face.Migration.17658~~~~0.0.1.0' -Online).State -eq "Installed") {
    Remove-WindowsCapability -Online -Name 'Hello.Face.Migration.17658~~~~0.0.1.0'
}
if((Get-WindowsCapability -Name 'Language.Handwriting~~~en-US~0.0.1.0' -Online).State -eq "Installed") {
    Remove-WindowsCapability -Online -Name 'Language.Handwriting~~~en-US~0.0.1.0'
}
if((Get-WindowsCapability -Name 'MathRecognizer~~~~0.0.1.0' -Online).State -eq "Installed") {
    Remove-WindowsCapability -Online -Name 'MathRecognizer~~~~0.0.1.0'
}
if((Get-WindowsCapability -Name 'Media.WindowsMediaPlayer~~~~0.0.12.0' -Online).State -eq "Installed") {
    Remove-WindowsCapability -Online -Name 'Media.WindowsMediaPlayer~~~~0.0.12.0'
}
if((Get-WindowsCapability -Name 'OneCoreUAP.OneSync~~~~0.0.1.0' -Online).State -eq "Installed") {
    Remove-WindowsCapability -Online -Name 'OneCoreUAP.OneSync~~~~0.0.1.0'
}

Write-Host "Changing Windows Optional Features..." -ForegroundColor Green

if((Get-WindowsOptionalFeature -FeatureName 'Internet-Explorer-Optional-amd64' -Online).State -eq "Enabled") {
    Disable-WindowsOptionalFeature -Online -FeatureName 'Internet-Explorer-Optional-amd64' -NoRestart
}
if((Get-WindowsOptionalFeature -FeatureName 'SmbDirect' -Online).State -eq "Enabled") {
    Disable-WindowsOptionalFeature -Online -FeatureName 'SmbDirect' -NoRestart
}
if((Get-WindowsOptionalFeature -FeatureName 'SMB1Protocol' -Online).State -eq "Enabled") {
    Disable-WindowsOptionalFeature -Online -FeatureName 'SMB1Protocol' -NoRestart
}
if((Get-WindowsOptionalFeature -FeatureName 'Microsoft-Windows-Client-EmbeddedExp-Package' -Online).State -eq "Enabled") {
    Disable-WindowsOptionalFeature -Online -FeatureName 'Microsoft-Windows-Client-EmbeddedExp-Package' -NoRestart
}
if((Get-WindowsOptionalFeature -FeatureName 'WindowsMediaPlayer' -Online).State -eq "Enabled") {
    Disable-WindowsOptionalFeature -Online -FeatureName 'WindowsMediaPlayer' -NoRestart
}
if((Get-WindowsOptionalFeature -FeatureName 'WCF-TCP-PortSharing45' -Online).State -eq "Enabled") {
    Disable-WindowsOptionalFeature -Online -FeatureName 'WCF-TCP-PortSharing45' -NoRestart
}
if((Get-WindowsOptionalFeature -FeatureName 'WCF-Services45' -Online).State -eq "Enabled") {
    Disable-WindowsOptionalFeature -Online -FeatureName 'WCF-Services45' -NoRestart
}
if((Get-WindowsOptionalFeature -FeatureName 'Printing-Foundation-InternetPrinting-Client' -Online).State -eq "Enabled") {
    Disable-WindowsOptionalFeature -Online -FeatureName 'Printing-Foundation-InternetPrinting-Client' -NoRestart
}
if((Get-WindowsOptionalFeature -FeatureName 'FaxServicesClientPackage' -Online).State -eq "Enabled") {
    Disable-WindowsOptionalFeature -Online -FeatureName 'FaxServicesClientPackage' -NoRestart
}
if((Get-WindowsOptionalFeature -FeatureName 'Printing-Foundation-Features' -Online).State -eq "Enabled") {
    Disable-WindowsOptionalFeature -Online -FeatureName 'Printing-Foundation-Features' -NoRestart
}
if((Get-WindowsOptionalFeature -FeatureName 'WorkFolders-Client' -Online).State -eq "Enabled") {
    Disable-WindowsOptionalFeature -Online -FeatureName 'WorkFolders-Client' -NoRestart
}
if((Get-WindowsOptionalFeature -FeatureName 'MSRDC-Infrastructure' -Online).State -eq "Enabled") {
    Disable-WindowsOptionalFeature -Online -FeatureName 'MSRDC-Infrastructure' -NoRestart
}
if((Get-WindowsOptionalFeature -FeatureName 'SearchEngine-Client-Package' -Online).State -eq "Enabled") {
    Disable-WindowsOptionalFeature -Online -FeatureName 'SearchEngine-Client-Package' -NoRestart
}
if((Get-WindowsOptionalFeature -FeatureName 'Printing-PrintToPDFServices-Features' -Online).State -eq "Enabled") {
    Disable-WindowsOptionalFeature -Online -FeatureName 'Printing-PrintToPDFServices-Features' -NoRestart
}
if((Get-WindowsOptionalFeature -FeatureName 'Printing-XPSServices-Features' -Online).State -eq "Enabled") {
    Disable-WindowsOptionalFeature -Online -FeatureName 'Printing-XPSServices-Features' -NoRestart
}
if((Get-WindowsOptionalFeature -FeatureName 'Windows-Defender-Default-Definitions' -Online).State -eq "Enabled") {
    Disable-WindowsOptionalFeature -Online -FeatureName 'Windows-Defender-Default-Definitions' -NoRestart
}
if((Get-WindowsOptionalFeature -FeatureName 'NetFx4-AdvSrvs' -Online).State -eq "Enabled") {
    Disable-WindowsOptionalFeature -Online -FeatureName 'NetFx4-AdvSrvs' -NoRestart
}

<# Adjust Services #>
Write-Host "Adjusting services start type..." -ForegroundColor Green

$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\luafv"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\TrkWks"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\CDPUserSvc"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\cbdhsvc"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\WSearch"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\BDESVC"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\CDPSvc"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\DiagTrack"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\DoSvc"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\DPS"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\DusmSvc"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\iphlpsvc"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\RasMan"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\ShellHWDetection"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\smphost"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\Spooler"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\SstpSvc"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\TabletInputService"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
#$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\UsoSvc"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
#New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\WdiServiceHost"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\WdiSystemHost"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\DsmSvc"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\NcbService"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\WPDBusEnum"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\WbioSrvc"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\UnistoreSvc"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\WerSvc"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\PimIndexMaintenanceSvc"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\MapsBroker"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\LxpSvc"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 3 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\StorSvc"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 3 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\PolicyAgent"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\IKEEXT"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\dmwappushservice"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\NgcSvc"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 3 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\LicenseManager"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 3 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\wlidsvc"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\TokenBroker"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 3 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\WaaSMedicSvc"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\PhoneSvc"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 3 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\NcaSvc"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\irmon"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\irmon"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\FDResPub"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\fhsvc"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\ScDeviceEnum"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\CertPropSvc"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\SessionEnv"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\TermService"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 2 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\CSC"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\CscService"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\wanarp"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\volmgrx"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\stisvc"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 3 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\wuauserv"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 3 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\Vid"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\spaceport"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\kdnic"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\rdpbus"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\BcastDVRUserService"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\GraphicsPerfSvc"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\SecurityHealthService"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\wscsvc"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\storqosflt"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\rspndr"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\MsLldp"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\lltdio"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\gencounter"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\CldFlt"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\SgrmBroker"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\Themes"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\SgrmAgent"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\tsusbhub"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\NetBIOS"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\wcifs"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\FileCrypt"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\Dfsc"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\cdrom"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 3 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\afunix"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start" -PropertyType DWord -Value 4 -Force

# Adjust Services Trigger/Failure Settings
sc.exe failure wuauserv actions= '""' reset= '""'
sc.exe triggerinfo wuauserv delete # We only want to trigger Windows Update service on manual cumulative updating.


<# Adjust Autorun Entries #>
Write-Host "Adjusting Autorun Entries" -ForegroundColor Green
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Font Drivers" -Name "Adobe Type Manager"
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Drivers32" -Name msacm.l3acm -PropertyType String -Value "" -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\Drivers32" -Name msacm.l3acm -PropertyType String -Value "" -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\Drivers32" -Name vidc.cvid -PropertyType String -Value "" -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Drivers32" -Name VIDC.RTV1 -PropertyType String -Value "" -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\Drivers32" -Name VIDC.RTV1 -PropertyType String -Value "" -Force

<# Disable Windows Components through Registry #>
Write-Host "Disable Windows Components through Registry." -ForegroundColor Green
# Remote Assistance
$Path = "HKLM:\SYSTEM\CurrentControlSet\Control\Remote Assistance"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "fAllowFullControl" -PropertyType DWord -Value 0 -Force
New-ItemProperty -Path $Path -Name "fAllowToGetHelp" -PropertyType DWord -Value 0 -Force
# Disk Quota
$Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DiskQuota"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Enable" -PropertyType DWord -Value 0 -Force
$Path = "HKU:\Software\Policies\Microsoft\Windows\Explorer"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "HidePeopleBar" -PropertyType DWord -Value 1 -Force
# Previous Versions
$Path = "HKLM:\Software\Policies\Microsoft\PreviousVersions"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "DisableBackupRestore" -PropertyType DWord -Value 1 -Force
$Path = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "NoPreviousVersionsPage" -PropertyType DWord -Value 1 -Force
# Offline Files
$Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\NetCache"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Enabled" -PropertyType DWord -Value 0 -Force
# File History
$Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\FileHistory"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Disabled" -PropertyType DWord -Value 1 -Force
# AutoPlay (Disable for All Drives)
$Path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "NoDriveTypeAutoRun" -PropertyType DWord -Value 255 -Force
$Path = "HKU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "DisableAutoplay" -PropertyType Dword -Value 1 -Force
# Mobility Center
$Path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\MobilityCenter"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "NoMobilityCenter" -PropertyType DWord -Value 1 -Force
# Taskview (+Taskbar Icon)
$Path = "HKU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "ShowTaskViewButton" -PropertyType Dword -Value 0 -Force
# Notification Center (+Taskbar Icon)
$Path = "HKU:\SOFTWARE\Policies\Microsoft\Windows\Explorer"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "DisableNotificationCenter" -PropertyType Dword -Value 1 -Force
# CD Burning
$Path = "HKU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "NoCDBurning" -PropertyType Dword -Value 1 -Force
# Miracast
$Path = "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "PlatformSupportMiracast" -PropertyType Dword -Value 0 -Force
# Phone Linking / Shared Experience
$Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "EnableMmx" -PropertyType Dword -Value 0 -Force

<# Windows Security and Privacy through Registry #>
Write-Host "Adjusting Windows Security and Privacy through Registry" -ForegroundColor Green
# Root Certificate Updates
$Path = "HKLM:\SOFTWARE\Policies\Microsoft\SystemCertificates\AuthRoot"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "DisableRootAutoUpdate" -PropertyType Dword -Value 1 -Force
New-ItemProperty -Path $Path -Name "EnableDisallowedCertAutoUpdate" -PropertyType Dword -Value 0 -Force
# Telemetry (Security) / Opt-in Notification
# $Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
# New-ItemProperty -Path $Path -Name "AllowTelemetry" -PropertyType Dword -Value 0 -Force
# New-ItemProperty -Path $Path -Name "DisableTelemetryOptInChangeNotification" -PropertyType Dword -Value 1 -Force
# $Path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
# New-ItemProperty -Path $Path -Name "AllowTelemetry" -PropertyType Dword -Value 0 -Force

# Application Compatibility
$Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "AITEnable" -PropertyType Dword -Value 0 -Force
New-ItemProperty -Path $Path -Name "DisableEngine" -PropertyType Dword -Value 1 -Force
New-ItemProperty -Path $Path -Name "DisablePCA" -PropertyType Dword -Value 1 -Force
New-ItemProperty -Path $Path -Name "DisablePcaUI" -PropertyType Dword -Value 1 -Force
New-ItemProperty -Path $Path -Name "DisableInventory" -PropertyType Dword -Value 1 -Force
New-ItemProperty -Path $Path -Name "SbEnable" -PropertyType Dword -Value 0 -Force
New-ItemProperty -Path $Path -Name "DisableUAR" -PropertyType Dword -Value 1 -Force
# Disable Automatic Online Activation / Validation Telemetry
$Path = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform\Activation"; if(-not (Test-Path -LiteralPath $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Manual" -PropertyType Dword -Value 1 -Force
New-ItemProperty -Path $Path -Name "NotificationDisabled" -PropertyType Dword -Value 1 -Force
# Bluetooth Marketing Advertising
$Path = "HKLM:\SOFTWARE\Microsoft\PolicyManager\current\device\Bluetooth"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "AllowAdvertising" -PropertyType Dword -Value 0 -Force
# Windows Help Experience Improvement Program
$Path = "HKU:\Software\Policies\Microsoft\Assistance"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
$Path = "HKU:\Software\Policies\Microsoft\Assistance\Client"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
$Path = "HKU:\Software\Policies\Microsoft\Assistance\Client\1.0"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "NoImplicitFeedback" -PropertyType Dword -Value 1 -Force
# Peer to Peer services
$Path = "HKLM:\SOFTWARE\Policies\Microsoft\Peernet"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Disabled" -PropertyType Dword -Value 1 -Force
# CEIP
$Path = "HKLM:\SOFTWARE\Policies\Microsoft\SQMClient"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
$Path = "HKLM:\SOFTWARE\Policies\Microsoft\SQMClient\Windows"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "CEIPEnable" -PropertyType Dword -Value 0 -Force
$Path = "HKLM:\SOFTWARE\Microsoft\SQMClient\Windows"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "CEIPEnable" -PropertyType Dword -Value 0 -Force
# Windows Update
$Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "DisableWindowsUpdateAccess" -PropertyType Dword -Value 0 -Force
New-ItemProperty -Path $Path -Name "ExcludeWUDriversInQualityUpdate" -PropertyType Dword -Value 1 -Force
$Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "NoAutoUpdate" -PropertyType Dword -Value 1 -Force
New-ItemProperty -Path $Path -Name "AUOptions" -PropertyType Dword -Value 1 -Force
New-ItemProperty -Path $Path -Name "UseWUServer" -PropertyType Dword -Value 0 -Force
New-ItemProperty -Path $Path -Name "NoAutoRebootWithLoggedOnUsers" -PropertyType Dword -Value 1 -Force
$Path = "HKLM:\SOFTWARE\Policies\Microsoft\MRT"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "DontOfferThroughWUAU" -PropertyType Dword -Value 1 -Force
# Windows Store
$Path = "HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "AutoDownload" -PropertyType Dword -Value 2 -Force
# Delivery Optimization
$Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "DODownloadMode" -PropertyType Dword -Value 100 -Force
# Device/Vendor Metadata
$Path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "PreventDeviceMetadataFromNetwork" -PropertyType Dword -Value 1 -Force
# Text/Ink Data Collection
$Path = "HKU:\Software\Microsoft\InputPersonalization"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "RestrictImplicitInkCollection" -PropertyType Dword -Value 1 -Force
New-ItemProperty -Path $Path -Name "RestrictImplicitTextCollection" -PropertyType Dword -Value 1 -Force
$Path = "HKU:\Software\Microsoft\InputPersonalization\TrainedDataStore"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "HarvestContacts" -PropertyType Dword -Value 0 -Force
$Path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\TextInput"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "AllowLinguisticDataCollection" -PropertyType Dword -Value 0 -Force
$Path = "HKU:\Software\Microsoft\Input\TIPC"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Enabled" -PropertyType Dword -Value 0 -Force
$Path = "HKU:\Software\Microsoft\Personalization\Settings"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "AcceptedPrivacyPolicy" -PropertyType Dword -Value 0 -Force
# Clipboard History
#$Path = "HKLM:\Software\Policies\Microsoft\Windows\System"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
#New-ItemProperty -Path $Path -Name "AllowClipboardHistory" -PropertyType Dword -Value 0 -Force
# Settings Pane Online Tips/Help
$Path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "AllowOnlineTips" -PropertyType Dword -Value 0 -Force
# Windows Ask Feedback
$Path = "HKU:\Software\Microsoft\Siuf"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
$Path = "HKU:\Software\Microsoft\Siuf\Rules"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "NumberOfSIUFInPeriod" -PropertyType Dword -Value 0 -Force
New-ItemProperty -Path $Path -Name "PeriodInNanoSeconds" -PropertyType Dword -Value 0 -Force
# Track Programs/Documents
$Path = "HKU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Start_TrackProgs" -PropertyType Dword -Value 0 -Force
New-ItemProperty -Path $Path -Name "Start_TrackDocs" -PropertyType Dword -Value 0 -Force
# Website Access of Language List
$Path = "HKU:\Control Panel\International\User Profile"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "HttpAcceptLanguageOptOut" -PropertyType Dword -Value 1 -Force
# Startmenu/Taskbar Tracking
$Path = "HKU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "NoInstrumentation" -PropertyType Dword -Value 1 -Force
New-ItemProperty -Path $Path -Name "NoRecentDocsHistory" -PropertyType Dword -Value 1 -Force
New-ItemProperty -Path $Path -Name "ClearRecentDocsOnExit" -PropertyType Dword -Value 1 -Force
$Path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "NoRecentDocsHistory" -PropertyType Dword -Value 1 -Force
# Login Screen Password Reveal
$Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CredUI"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "DisablePasswordReveal" -PropertyType Dword -Value 1 -Force
# Content Delivery Manager
$Path = "HKU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "SilentInstalledAppsEnabled" -PropertyType Dword -Value 0 -Force
New-ItemProperty -Path $Path -Name "SystemPaneSuggestionsEnabled" -PropertyType Dword -Value 0 -Force
New-ItemProperty -Path $Path -Name "SoftLandingEnabled" -PropertyType Dword -Value 0 -Force
New-ItemProperty -Path $Path -Name "ContentDeliveryAllowed" -PropertyType Dword -Value 0 -Force
# Typing Insights
$Path = "HKU:\Software\Microsoft\Input\Settings"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "InsightsEnabled" -PropertyType Dword -Value 0 -Force
# PerfTrack
$Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WDI"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
$Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WDI\{9c5a40da-b965-4fc3-8781-88dd50a6299d}"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "ScenarioExecutionEnabled" -PropertyType Dword -Value 0 -Force
# Online Front Provider
$Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "EnableFontProviders" -PropertyType Dword -Value 0 -Force
# Speech Model Update through BITS
$Path = "HKLM:\SOFTWARE\Policies\Microsoft\Speech"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "AllowSpeechModelUpdate" -PropertyType Dword -Value 0 -Force
# KMS Client Online AVS Validation
$Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Software Protection Platform"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "NoGenTicket" -PropertyType Dword -Value 1 -Force
# Adobe Type Manager Font Driver (ATMFD)
$Path = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "DisableATMFD" -PropertyType Dword -Value 1 -Force
# Tailored Experiences Diagnostic Data
$Path = "HKU:\Software\Microsoft\Windows\CurrentVersion\Privacy"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "TailoredExperiencesWithDiagnosticDataEnabled" -PropertyType Dword -Value 0 -Force
# Automatic Sign-in after restart
#$Path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
#New-ItemProperty -Path $Path -Name "DisableAutomaticRestartSignOn" -PropertyType Dword -Value 1 -Force
# Microsoft Accounts Allowance
# $Path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
# New-ItemProperty -Path $Path -Name "NoConnectedUser" -PropertyType Dword -Value 3 -Force
# UWP App Privacy except Microphone (Capability Access Manager)
# $Permissions = Get-ChildItem -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore' -Recurse -Depth 1 | Where-Object { $_.PSChildName -NotLike 'microphone'}
# ForEach ($item in $Permissions) { $path = $item -replace "HKEY_LOCAL_MACHINE","HKLM:"; Set-ItemProperty -Path $path -Name 'Value' -Value "Deny" -Force }


<# Remove Context Menu Handlers #>
Write-Host "Removing Context Menu Handlers" -ForegroundColor Green
$Path = "HKLM:\SOFTWARE\Classes\*\shellex\ContextMenuHandlers\EPP"; if(Test-Path -LiteralPath $Path){
    # Windows Defender
    Remove-Item -LiteralPath "HKLM:\SOFTWARE\Classes\*\shellex\ContextMenuHandlers\EPP"
    Remove-Item -LiteralPath "HKLM:\SOFTWARE\Classes\Drive\shellex\ContextMenuHandlers\EPP"
    Remove-Item -LiteralPath "HKLM:\SOFTWARE\Classes\Directory\shellex\ContextMenuHandlers\EPP"
    # Cast to Device
    $Path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
    New-ItemProperty -Path $Path -Name "{7AD84985-87B4-4a16-BE58-8B72A5B390F7}" -PropertyType String -Value "" -Force
    # Edit with Paint 3D / Rotate Image / 3D Print
    $Context = Get-ChildItem -Path 'HKCR:\SystemFileAssociations' -Recurse -Depth 4 | Where-Object { $_.PSChildName }
    ForEach ($item in $Context) { $path = $item -replace "HKEY_CLASSES_ROOT","HKCR:"; Remove-Item -Path $path -Include '3D Edit','ShellImagePreview','3D Print' -Recurse -Force -Confirm:$False }
    # Give Access To
    Remove-Item -LiteralPath "HKCR:\*\shellex\ContextMenuHandlers\Sharing" -Recurse:$True -Confirm:$False
    Remove-Item -LiteralPath "HKCR:\Directory\Background\shellex\ContextMenuHandlers\Sharing" -Recurse:$True -Confirm:$False
    Remove-Item -LiteralPath "HKCR:\Directory\shellex\ContextMenuHandlers\Sharing" -Recurse:$True -Confirm:$False
    Remove-Item -LiteralPath "HKCR:\Directory\shellex\CopyHookHandlers\Sharing" -Recurse:$True -Confirm:$False
    Remove-Item -LiteralPath "HKCR:\Drive\shellex\ContextMenuHandlers\Sharing" -Recurse:$True -Confirm:$False
    Remove-Item -LiteralPath "HKCR:\Drive\shellex\PropertySheetHandlers\Sharing" -Recurse:$True -Confirm:$False
    Remove-Item -LiteralPath "HKCR:\LibraryFolder\background\shellex\ContextMenuHandlers\Sharing" -Recurse:$True -Confirm:$False
    Remove-Item -LiteralPath "HKCR:\UserLibraryFolder\shellex\ContextMenuHandlers\Sharing" -Recurse:$True -Confirm:$False
    # Include in Library
    Remove-Item -LiteralPath "HKCR:\Folder\ShellEx\ContextMenuHandlers\Library Location" -Recurse:$True -Confirm:$False
    # Modern Sharing
    Remove-Item -LiteralPath "HKCR:\*\shellex\ContextMenuHandlers\ModernSharing" -Recurse:$True -Confirm:$False
    # New Contact
    Remove-Item -LiteralPath "HKCR:\.contact\ShellNew" -Recurse:$True -Confirm:$False
    # Pin Quick Access
    Remove-Item -LiteralPath "HKCR:\Folder\shell\pintohome" -Recurse:$True -Confirm:$False
    Remove-Item -LiteralPath "HKLM:\SOFTWARE\Classes\Folder\shell\pintohome" -Recurse:$True -Confirm:$False
    # Pin to Start
    Remove-Item -LiteralPath "HKCR:\Folder\shellex\ContextMenuHandlers\PintoStartScreen" -Recurse:$True -Confirm:$False
    Remove-Item -LiteralPath "HKCR:\exefile\shellex\ContextMenuHandlers\PintoStartScreen" -Recurse:$True -Confirm:$False
    Remove-Item -LiteralPath "HKCR:\Microsoft.Website\ShellEx\ContextMenuHandlers\PintoStartScreen" -Recurse:$True -Confirm:$False
    Remove-Item -LiteralPath "HKCR:\mscfile\shellex\ContextMenuHandlers\PintoStartScreen" -Recurse:$True -Confirm:$False
    # Troubleshoot
    $Path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
    New-ItemProperty -Path $Path -Name "{1d27f844-3a1f-4410-85ac-14651078412d}" -PropertyType String -Value "" -Force
    Remove-Item -LiteralPath "HKCR:\lnkfile\shellex\ContextMenuHandlers\Compatibility" -Recurse:$True -Confirm:$False
    # Send To
    Remove-Item -LiteralPath "HKCR:\AllFilesystemObjects\shellex\ContextMenuHandlers\SendTo" -Recurse:$True -Confirm:$False
    Remove-Item -LiteralPath "HKCR:\UserLibraryFolder\shellex\ContextMenuHandlers\SendTo" -Recurse:$True -Confirm:$False
}


<# Remove Sound Scheme #>
Write-Host "Removing Sound Scheme" -ForegroundColor Green
$sid = $strSID.Value
$SoundScheme = Get-ChildItem -Path 'HKU:\AppEvents\Schemes\Apps' -Recurse -Depth 3 | Where-Object { $_.PSChildName }
ForEach ($item in $SoundScheme) { $path = $item -replace [regex]::Escape("HKEY_USERS\$sid"),"HKU:"; Set-ItemProperty -LiteralPath $path -Name '(Default)' -Value "" -Force }


<# General Windows Configuration #>
Write-Host "Setting General Windows Configuration through Registry" -ForegroundColor Green
# NTP Timeserver
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Parameters"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "NtpServer" -PropertyType String -Value "0.pool.ntp.org,0x9" -Force
# Region Settings
$Path = "HKU:\Control Panel\International"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "sShortDate" -PropertyType String -Value "dd-MMM-yy" -Force
New-ItemProperty -Path $Path -Name "sShortTime" -PropertyType String -Value "HH:mm" -Force
New-ItemProperty -Path $Path -Name "sTimeFormat" -PropertyType String -Value "HH:mm:ss" -Force
New-ItemProperty -Path $Path -Name "iFirstDayOfWeek" -PropertyType String -Value "0" -Force
# Verbose Boot/Reboot Messages
#$Path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
#New-ItemProperty -Path $Path -Name "VerboseStatus" -PropertyType Dword -Value 1 -Force
# Use Only Latest CLR (NET)
$Path = "HKLM:\SOFTWARE\Microsoft\.NETFramework"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "OnlyUseLatestCLR" -PropertyType Dword -Value 1 -Force
$Path = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NETFramework"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "OnlyUseLatestCLR" -PropertyType Dword -Value 1 -Force
# Show BSOD instead of smiley
$Path = "HKLM:\System\CurrentControlSet\Control\CrashControl"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "DisplayParameters" -PropertyType Dword -Value 1 -Force
# Disable Automatic Crash Debugging
Remove-Item -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\AeDebug" -Force -Recurse -Confirm:$False
# Network Icon on logon screen
$Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "DontDisplayNetworkSelectionUI" -PropertyType Dword -Value 1 -Force
# Low Disk Space Checks
$Path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "NoLowDiskSpaceChecks" -PropertyType Dword -Value 1 -Force
# Shutdown Button without Login
$Path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "shutdownwithoutlogon" -PropertyType Dword -Value 1 -Force
# Recently Added Apps in Start Menu
$Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "HideRecentlyAddedApps" -PropertyType Dword -Value 1 -Force
# Auto Restart after BSOD
$Path = "HKLM:\SYSTEM\CurrentControlSet\Control\CrashControl"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "AutoReboot" -PropertyType Dword -Value 0 -Force
# Classic Volume Mixer
$Path = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\MTCUVC"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "EnableMtcUvc" -PropertyType Dword -Value 0 -Force
# Chkdsk 10 second timeout.
$Path = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "AutoChkTimeout" -PropertyType Dword -Value 10 -Force
# Hide Fonts Based on Language Settings
$Path = "HKU:\Software\Microsoft\Windows NT\CurrentVersion\Font Management"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Auto Activation Mode" -PropertyType Dword -Value 1 -Force
# Click-once to Login
#$Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
#New-ItemProperty -Path $Path -Name "NoLockScreen" -PropertyType Dword -Value 1 -Force
# Disable Crash Dumps
$Path = "HKLM:\SYSTEM\CurrentControlSet\Control\CrashControl"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "CrashDumpEnabled" -PropertyType Dword -Value 0 -Force
# Explorer Icon Cache Size
$Path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Max Cached Icons" -PropertyType String -Value "8192" -Force
# Disable Language Switch Hotkeys
$Path = "HKU:\Keyboard Layout\Toggle"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Language Hotkey" -PropertyType String -Value "3" -Force
New-ItemProperty -Path $Path -Name "Hotkey" -PropertyType String -Value "3" -Force
New-ItemProperty -Path $Path -Name "Layout Hotkey" -PropertyType String -Value "3" -Force
# Disable Sticky/Filter/Toggle Hotkeys
$Path = "HKU:\Control Panel\Accessibility\StickyKeys"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Flags" -PropertyType String -Value "506" -Force
$Path = "HKU:\Control Panel\Accessibility\Keyboard Response"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Flags" -PropertyType String -Value "122" -Force
$Path = "HKU:\Control Panel\Accessibility\ToggleKeys"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Flags" -PropertyType String -Value "58" -Force
# Disable F1 Help Key
$Path = "HKU:\SOFTWARE\Classes\Typelib\{8cec5860-07a1-11d9-b15e-000d56bfe6ee}\1.0\0\win32"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path -Force}
New-ItemProperty -Path $Path -Name "(Default)" -PropertyType String -Value "" -Force
$Path = "HKU:\SOFTWARE\Classes\Typelib\{8cec5860-07a1-11d9-b15e-000d56bfe6ee}\1.0\0\win64"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path -Force}
New-ItemProperty -Path $Path -Name "(Default)" -PropertyType String -Value "" -Force
# Disable Network Location Wizard
$Path = "HKLM:\SYSTEM\CurrentControlSet\Control\Network\NetworkLocationWizard"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "HideWizard" -PropertyType Dword -Value 1 -Force
# Disable New Network Location Window
$Path = "HKLM:\SYSTEM\CurrentControlSet\Control\Network\NewNetworkWindowOff"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
# Disable Automatic Setup of Network Connected Devices
$Path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\NcdAutoSetup\Private"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "AutoSetup" -PropertyType Dword -Value 0 -Force
# Don't Notify When Clock Changes
$Path = "HKU:\Control Panel\TimeDate"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "DstNotification" -PropertyType Dword -Value 0 -Force
# Hide/Show Disabled/Disconnected Audio Devices
#$Path = "HKU:\Software\Microsoft\Multimedia\Audio\DeviceCpl"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
#New-ItemProperty -Path $Path -Name "ShowHiddenDevices" -PropertyType Dword -Value 0 -Force
#New-ItemProperty -Path $Path -Name "ShowDisconnectedDevices" -PropertyType Dword -Value 1 -Force
# Disable Windows Detects Communications Activity
$Path = "HKU:\Software\Microsoft\Multimedia\Audio"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "UserDuckingPreference" -PropertyType Dword -Value 3 -Force
# Disable Modern Push Notifications
$Path = "HKU:\Software\Policies\Microsoft\Windows\CurrentVersion\PushNotifications"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "NoToastApplicationNotification" -PropertyType Dword -Value 1 -Force
# Disable Spelling/Typing Related Aid.
$Path = "HKU:\Software\Microsoft\TabletTip\1.7"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "EnableAutocorrection" -PropertyType Dword -Value 0 -Force
New-ItemProperty -Path $Path -Name "EnableSpellchecking" -PropertyType Dword -Value 0 -Force
New-ItemProperty -Path $Path -Name "EnableTextPrediction" -PropertyType Dword -Value 0 -Force
New-ItemProperty -Path $Path -Name "EnablePredictionSpaceInsertion" -PropertyType Dword -Value 0 -Force
New-ItemProperty -Path $Path -Name "EnableDoubleTapSpace" -PropertyType Dword -Value 0 -Force
# GameBar/GameDVR Related
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR"; New-ItemProperty -Name AllowGameDVR -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -PropertyType Dword -Value 0 -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WindowsRuntime\ActivatableClassId\Windows.Gaming.GameBar.PresenceServer.Internal.PresenceWriter" -Name ActivationType -PropertyType Dword -Value 0 -Force
$Path = "HKU:\SOFTWARE\Microsoft\GameBar"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "UseNexusForGameBarEnabled" -PropertyType Dword -Value 0 -Force
$Path = "HKU:\System\GameConfigStore"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "GameDVR_Enabled" -PropertyType Dword -Value 0 -Force
# Enable/Disable Full Screen Optimizations (All to 0 is On)
#$Path = "HKU:\System\GameConfigStore"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
#New-ItemProperty -Path $Path -Name "GameDVR_DXGIHonorFSEWindowsCompatible" -PropertyType Dword -Value 1 -Force
#New-ItemProperty -Path $Path -Name "GameDVR_EFSEFeatureFlags" -PropertyType Dword -Value 0 -Force
#New-ItemProperty -Path $Path -Name "GameDVR_FSEBehavior" -PropertyType Dword -Value 2 -Force
#New-ItemProperty -Path $Path -Name "GameDVR_FSEBehaviorMode" -PropertyType Dword -Value 2 -Force
#New-ItemProperty -Path $Path -Name "GameDVR_HonorUserFSEBehaviorMode" -PropertyType Dword -Value 1 -Force
# Game Mode On/Off
#$Path = "HKU:\Software\Microsoft\GameBar"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
#New-ItemProperty -Path $Path -Name "AutoGameModeEnabled" -PropertyType Dword -Value 0 -Force

<# Explorer/Desktop Related Configuration #>
# Search whole filesystem instead of using Index
$Path = "HKU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Search\Preferences"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "WholeFileSystem" -PropertyType Dword -Value 1 -Force
# Disable Explorer Search History
$Path = "HKU:\Software\Policies\Microsoft\Windows\Explorer"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "DisableSearchBoxSuggestions" -PropertyType Dword -Value 1 -Force
# Disable Sharing Wizard
$Path = "HKU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "SharingWizardOn" -PropertyType Dword -Value 0 -Force
# Hide Folder Merge Conflicts
$Path = "HKU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "HideMergeConflicts" -PropertyType Dword -Value 1 -Force
# Disable Aero Shake
$Path = "HKU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "DisallowShaking" -PropertyType Dword -Value 1 -Force
# Disable Aero Snap Assist
$Path = "HKU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "SnapAssist" -PropertyType Dword -Value 0 -Force
New-ItemProperty -Path $Path -Name "JointResize" -PropertyType Dword -Value 0 -Force
# Maximum Wallpaper JPEG Quality
$Path = "HKU:\Control Panel\Desktop"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "JPEGImportQuality" -PropertyType Dword -Value 999 -Force
# Always Desktop-Mode
$Path = "HKU:\Software\Microsoft\Windows\CurrentVersion\ImmersiveShell"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "TabletMode" -PropertyType Dword -Value 0 -Force
New-ItemProperty -Path $Path -Name "SignInMode" -PropertyType Dword -Value 1 -Force
New-ItemProperty -Path $Path -Name "ConvertibleSlateModePromptPreference" -PropertyType Dword -Value 2 -Force
$Path = "HKU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "TaskbarAutoHideInTabletMode" -PropertyType Dword -Value 0 -Force
New-ItemProperty -Path $Path -Name "TaskbarAppsVisibleInTabletMode" -PropertyType Dword -Value 1 -Force
# UWP Disable Dynamic Scrollbars
$Path = "HKU:\Control Panel\Accessibility"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "DynamicScrollbars" -PropertyType Dword -Value 0 -Force
# Change Application Start/Shutdown Delay
$Path = "HKU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "StartupDelayInMSec" -PropertyType Dword -Value 1872 -Force
$Path = "HKU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Shutdown\Serialize"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "StartupDelayInMSec" -PropertyType Dword -Value 0 -Force
# Show/Hide Explorer Menus
$Path = "HKU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "AlwaysShowMenus" -PropertyType Dword -Value 0 -Force
# Disable Search the Microsoft Store
$Path = "HKLM:\Software\Policies\Microsoft\Windows\Explo‌​rer"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "NoUseStoreOpenWith" -PropertyType DWord -Value 1 -Force
# Explorer Thumbnail Cache
$Path = "HKU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "NoThumbnailCache" -PropertyType Dword -Value 1 -Force
$Path = "HKU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "DisableThumbnailCache" -PropertyType Dword -Value 1 -Force
# No New App Alert
$Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "NoNewAppAlert" -PropertyType Dword -Value 1 -Force
# Disable Touch Screen Gestures
$Path = "HKU:\Control Panel\Cursors"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "ContactVisualization" -PropertyType Dword -Value 0 -Force
New-ItemProperty -Path $Path -Name "GestureVisualization" -PropertyType Dword -Value 0 -Force
# Disable Network Drive Mapping icon error in tray
$Path = "HKLM:\SYSTEM\CurrentControlSet\Control\NetworkProvider"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "RestoreConnection" -PropertyType Dword -Value 0 -Force
# Disable Explorer Quick Access
$Path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "HubMode" -PropertyType Dword -Value 1 -Force
# Disable Themes Ability to Change Sounds, Wallpapers, Icons, etc.
$Path = "HKU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "ThemeChangesDesktopIcons" -PropertyType Dword -Value 0 -Force
New-ItemProperty -Path $Path -Name "ThemeChangesMousePointers" -PropertyType Dword -Value 0 -Force
New-ItemProperty -Path $Path -Name "ColorSetFromTheme" -PropertyType Dword -Value 0 -Force
New-ItemProperty -Path $Path -Name "WallpaperSetFromTheme" -PropertyType Dword -Value 0 -Force
$Path = "HKU:\Software\Policies\Microsoft\Windows\Personalization"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "NoChangingSoundScheme" -PropertyType Dword -Value 1 -Force
# Explorer Animation / Shortcut Resolve Speed
$Path = "HKU:\Control Panel\Mouse"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "MouseHoverTime" -PropertyType String -Value "1" -Force
$Path = "HKU:\Control Panel\Desktop"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "MenuShowDelay" -PropertyType String -Value "1" -Force
$Path = "HKU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "LinkResolveIgnoreLinkInfo" -PropertyType Dword -Value "1" -Force
New-ItemProperty -Path $Path -Name "NoResolveSearch" -PropertyType Dword -Value "1" -Force
New-ItemProperty -Path $Path -Name "NoResolveTrack" -PropertyType Dword -Value "1" -Force

<# Configure DPI / Text Scaling + Mouse 1:1 Movement #>
Write-Host "Configure DPI Preferences" -ForegroundColor Green
# Windows 8 (Custom DPI) Scaling
$Path = "HKU:\Control Panel\Desktop"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Win8DpiScaling" -PropertyType Dword -Value 1 -Force
New-ItemProperty -Path $Path -Name "DpiScalingVer" -PropertyType Dword -Value 4096 -Force
# High DPI Aware Executables
$Path = "HKU:\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "C:\Windows\System32\mmc.exe" -PropertyType String -Value "~ HIGHDPIAWARE" -Force
New-ItemProperty -Path $Path -Name "C:\Windows\System32\msiexec.exe" -PropertyType String -Value "~ HIGHDPIAWARE" -Force
New-ItemProperty -Path $Path -Name "C:\Windows\System32\perfmon.exe" -PropertyType String -Value "~ HIGHDPIAWARE" -Force
# We always want to dictate custom DPI % even at common values i.e. 100%/125%/150%. This solves some issues with window locations / blurry taskbar icons after resolution change / alt+tab
 
<# Low-level Configuration #>
Write-Host "Set Low-level Configuration" -ForegroundColor Green
# UWP Swap File
$Path = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "SwapfileControl" -PropertyType Dword -Value 0 -Force
# NTFS
$Path = "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "NtfsDisable8dot3NameCreation" -PropertyType Dword -Value 1 -Force
New-ItemProperty -Path $Path -Name "NtfsDisableLastAccessUpdate" -PropertyType Dword -Value -2147483647 -Force
New-ItemProperty -Path $Path -Name "LongPathsEnabled" -PropertyType Dword -Value 1 -Force
New-ItemProperty -Path $Path -Name "NtfsDisableCompression" -PropertyType Dword -Value 1 -Force
New-ItemProperty -Path $Path -Name "NtfsEncryptPagingFile" -PropertyType Dword -Value 1 -Force

<# Power Management #>
Write-Host "Set Power Management Configuration" -ForegroundColor Green
# Fast Startup
$Path = "HKLM:\System\CurrentControlSet\Control\Session Manager\Power"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "HiberbootEnabled" -PropertyType Dword -Value 0 -Force
# Expose all unhidden power plan options
$PowerSettings = Get-ChildItem -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings' -Recurse -Depth 1 | Where-Object { $_.PSChildName -NotLike 'DefaultPowerSchemeValues' -and $_.PSChildName -NotLike '0' -and $_.PSChildName -NotLike '1' }
ForEach ($item in $PowerSettings) { $path = $item -replace "HKEY_LOCAL_MACHINE","HKLM:"; Set-ItemProperty -Path $path -Name 'Attributes' -Value 2 -Force }

<# Network General/Protocol Configuration #>
Write-Host "Set General Networking Configuration" -ForegroundColor Green
Set-NetIPinterface -InterfaceAlias '*' -NlMtuBytes 1440
Set-NetTCPSetting -EcnCapability Enable
Set-NetAdapterBinding -Name '*' -DisplayName 'Client for Microsoft Networks' -Enabled 0 -ea SilentlyContinue
Set-NetAdapterBinding -Name '*' -DisplayName 'Internet Protocol Version 6 (TCP/IPv6)' -Enabled 0 -ea SilentlyContinue
Set-NetAdapterBinding -Name '*' -DisplayName 'Microsoft LLDP Protocol Driver' -Enabled 0 -ea SilentlyContinue
Set-NetAdapterBinding -Name '*' -DisplayName 'Link-Layer Topology Discovery Responder' -Enabled 0 -ea SilentlyContinue
Set-NetAdapterBinding -Name '*' -DisplayName 'Link-Layer Topology Discovery Mapper I/O Driver' -Enabled 0 -ea SilentlyContinue
Set-NetAdapterBinding -Name '*' -DisplayName 'QoS Packet Scheduler' -Enabled 0 -ea SilentlyContinue
Set-NetAdapterBinding -Name '*' -DisplayName 'Hyper-V Extensible Virtual Switch' -Enabled 0 -ea SilentlyContinue
Set-NetAdapterBinding -Name '*' -DisplayName 'Microsoft Network Adapter Multiplexor Protocol' -Enabled 0 -ea SilentlyContinue
Set-NetAdapterBinding -Name '*' -DisplayName 'Microsoft NDIS Capture' -AllBindings -Enabled 0 -ea SilentlyContinue
Set-NetAdapterBinding -Name '*' -DisplayName 'Microsoft RDMA - NDK' -AllBindings -Enabled 0 -ea SilentlyContinue
Set-NetAdapterBinding -Name '*' -DisplayName 'NetBIOS Interface' -AllBindings -Enabled 0 -ea SilentlyContinue
Set-NetAdapterBinding -Name '*' -DisplayName 'NDIS Usermode I/O Protocol' -AllBindings -Enabled 0 -ea SilentlyContinue
Set-NetAdapterBinding -Name '*' -DisplayName 'Point to Point Protocol Over Ethernet' -AllBindings -Enabled 0 -ea SilentlyContinue
Set-NetAdapterBinding -Name '*' -DisplayName 'WINS Client(TCP/IP) Protocol' -AllBindings -Enabled 0 -ea SilentlyContinue
Set-NetAdapterBinding -Name '*' -DisplayName 'NDIS Usermode I/O Protocol' -AllBindings -Enabled 0 -ea SilentlyContinue
#VMware Adapter (NAT)
Set-NetAdapterBinding -Name 'VMware Network Adapter VMNet8' -DisplayName 'Client For Microsoft Networks' -AllBindings -Enabled 0 -ea SilentlyContinue
Set-NetAdapterBinding -Name 'VMware Network Adapter VMNet8' -DisplayName 'File and Printer Sharing for Microsoft Networks' -AllBindings -Enabled 0 -ea SilentlyContinue

# Disable Nagle's Algorithm on all interfaces
#$i = 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces'  
#Get-ChildItem $i | ForEach-Object {  
#    Set-ItemProperty -Path "$i\$($_.pschildname)" -name TcpAckFrequency -value 1
#    Set-ItemProperty -Path "$i\$($_.pschildname)" -name TCPNoDelay -value 1
#}

# Disable NetBIOS on all interfaces
$i = 'HKLM:\SYSTEM\CurrentControlSet\Services\netbt\Parameters\interfaces'  
Get-ChildItem $i | ForEach-Object {  
    Set-ItemProperty -Path "$i\$($_.pschildname)" -name NetBiosOptions -value 2
}

$Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "EnableMulticast" -PropertyType Dword -Value 1 -Force
New-ItemProperty -Path $Path -Name "RegistrationEnabled" -PropertyType Dword -Value 0 -Force
New-ItemProperty -Path $Path -Name "DisableSmartNameResolution" -PropertyType Dword -Value 1 -Force
$Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\NetworkConnectivityStatusIndicator"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "NoActiveProbe" -PropertyType Dword -Value 1 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\NlaSvc\Parameters\Internet"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "EnableActiveProbing" -PropertyType Dword -Value 0 -Force
New-ItemProperty -Path $Path -Name "ActiveDnsProbeContent" -PropertyType String -Value "192.168.1.1:8080" -Force
New-ItemProperty -Path $Path -Name "ActiveDnsProbeHost" -PropertyType String -Value "192.168.1.1:8080" -Force
New-ItemProperty -Path $Path -Name "ActiveWebProbeHost" -PropertyType String -Value "192.168.1.1:8080" -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "DisabledComponents" -PropertyType Dword -Value 0x00000020 -Force # Prefer ipv4 over ivp6, recommended instead of disabling
$Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LLTD"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "EnableLLTDIO" -PropertyType Dword -Value 0 -Force
New-ItemProperty -Path $Path -Name "EnableRspndr" -PropertyType Dword -Value 0 -Force
# $Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\TCPIP\v6Transition"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
# New-ItemProperty -Path $Path -Name "6to4_State" -PropertyType String -Value "Disabled" -Force
# New-ItemProperty -Path $Path -Name "ISATAP_State" -PropertyType String -Value "Disabled" -Force
# New-ItemProperty -Path $Path -Name "Teredo_State" -PropertyType String -Value "Disabled" -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\services\Tcpip\QoS"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Do not use NLA" -PropertyType String -Value "1" -Force
$Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WcmSvc\GroupPolicy"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "fMinimizeConnections" -PropertyType Dword -Value "1" -Force
$Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\HotspotAuthentication"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Enabled" -PropertyType Dword -Value "0" -Force
$Path = "HKLM:\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "AutoConnectAllowedOEM" -PropertyType Dword -Value "0" -Force
$Path = "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "value" -PropertyType Dword -Value "0" -Force
$Path = "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "value" -PropertyType Dword -Value "0" -Force
$Path = "HKLM:\SOFTWARE\Microsoft\WlanSvc\AnqpCache"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "OsuRegistrationStatus" -PropertyType Dword -Value "0" -Force

<# SMB Server Configuration #>
Write-Host "Setting up Samba Configuration" -ForegroundColor Green
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name LocalAccountTokenFilterPolicy -PropertyType Dword -Value 1 -Force # Enable Administrative Shares
Set-SmbServerConfiguration -EnableSMB1Protocol $false -Force
# SMB Client Configuration
Set-SmbClientConfiguration -EnableInsecureGuestLogons 0 -Force
Set-SmbClientConfiguration -EnableBandwidthThrottling 0 -Force


<# Remote Desktop Configuration #>
Write-Host "Configuring Remote Desktop" -ForegroundColor Green
# Enable Remote Desktop
$Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "fDenyTSConnections" -PropertyType DWord -Value 0 -Force
# Don't Adjust Remote Session DPI
$Path = "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "IgnoreClientDesktopScaleFactor" -PropertyType Dword -Value 1 -Force
# Change Listening Port
$Path = "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "PortNumber" -PropertyType Dword -Value 11139 -Force
# Prioritize H.264/AVC 444 graphics mode for Remote Desktop Connections
#$Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
#New-ItemProperty -Path $Path -Name "AVC444ModePreferred" -PropertyType Dword -Value 1 -Force
# Configure H.264/AVC Hardware encoding for Remote Desktop Connections
#$Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
#New-ItemProperty -Path $Path -Name "AVCHardwareEncodePreferred" -PropertyType Dword -Value 1 -Force
# Increase DWM Frame Capture Interval (If not using AVC codec). 2 is the lowest before dwm.exe goes berserk.
$Path = "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "DWMFRAMEINTERVAL" -PropertyType Dword -Value 2 -Force
# RDP Compression Level (If not using AVC codec)
#$Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
#New-ItemProperty -Path $Path -Name "MaxCompressionLevel" -PropertyType Dword -Value 0 -Force

<# Change Scheduled Tasks #>
Write-Host "Changing Default Scheduled Tasks" -ForegroundColor Green
# Disable all Windows Default Tasks, with exceptions.
Get-ScheduledTask -TaskPath "\Microsoft\*" | Where-Object {$_.Taskname -notmatch 'SynchronizeTime' -and $_.Taskname -notmatch 'MsCtfMonitor' -and $_.Taskname -notmatch 'RemoteFXvGPUDisableTask' `
-and $_.Taskname -notmatch 'ResPriStaticDbSync' -and $_.Taskname -notmatch 'WsSwapAssessmentTask' -and $_.Taskname -notmatch 'Sysprep Generalize Drivers' -and $_.Taskname -notmatch 'Device Install Group Policy' `
 -and $_.Taskname -notmatch 'DXGIAdapterCache' -and $_.Taskname -notmatch 'UninstallDeviceTask'} | Disable-ScheduledTask

<# Configure Logging (Event/Channels/WMI #>
Write-Host "Configure Logging" -ForegroundColor Green
<# Event Log Configuration #>
(Get-WinEvent -ListLog *).LogName | %{[System.Diagnostics.Eventing.Reader.EventLogSession]::GlobalSession.ClearLog($_)} # Clear Event Log
# Change Individual Channels
$EventLog = Get-WinEvent -ListLog "Microsoft-Windows-LiveId/Operational"; $EventLog.IsEnabled = $false; $EventLog.SaveChanges()
$EventLog = Get-WinEvent -ListLog "Microsoft-Windows-CloudStore/Operational"; $EventLog.IsEnabled = $false; $EventLog.SaveChanges()
$EventLog = Get-WinEvent -ListLog "Microsoft-Windows-UniversalTelemetryClient/Operational"; $EventLog.IsEnabled = $false; $EventLog.SaveChanges()
$EventLog = Get-WinEvent -ListLog "Microsoft-Windows-WindowsSystemAssessmentTool/Operational"; $EventLog.IsEnabled = $false; $EventLog.SaveChanges()
$EventLog = Get-WinEvent -ListLog "Microsoft-Windows-ReadyBoost/Operational"; $EventLog.IsEnabled = $false; $EventLog.SaveChanges()
$EventLog = Get-WinEvent -ListLog "Microsoft-Windows-HelloForBusiness/Operational"; $EventLog.IsEnabled = $false; $EventLog.SaveChanges()
$EventLog = Get-WinEvent -ListLog "Microsoft-Windows-SettingSync/Debug"; $EventLog.IsEnabled = $false; $EventLog.SaveChanges()
$EventLog = Get-WinEvent -ListLog "Microsoft-Windows-Known Folders API Service"; $EventLog.IsEnabled = $false; $EventLog.SaveChanges()
$EventLog = Get-WinEvent -ListLog "Microsoft-Windows-SettingSync/Operational"; $EventLog.IsEnabled = $false; $EventLog.SaveChanges()
$EventLog = Get-WinEvent -ListLog "Microsoft-Windows-Store/Operational"; $EventLog.IsEnabled = $false; $EventLog.SaveChanges()
$EventLog = Get-WinEvent -ListLog "Microsoft-Windows-CAPI2/Operational"; $EventLog.IsEnabled = $true; $EventLog.SaveChanges()
$EventLog = Get-WinEvent -ListLog "Microsoft-Windows-Application-Experience/Program-Telemetry"; $EventLog.IsEnabled = $true; $EventLog.SaveChanges() # Actually logs program incompatibility and fixed applied
# Filter Harmless DistributedCOM logging in 'System'.
$Path = "HKLM:\SYSTEM\CurrentControlSet\Control\WMI\Autologger\EventLog-System\{1b562e86-b7aa-4131-badc-b6f3a001407e}"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "Enabled" -PropertyType Dword -Value 0 -Force
# Disable all non-critical WMI loggers (Including third-party)
$Logger = Get-ChildItem -Path 'HKLM:\System\CurrentControlSet\Control\WMI\Autologger' -Recurse -Depth 1 | Where-Object { $_.PSChildName -NotLike 'Circular Kernel Context Logger' -and $_.PSChildName -NotLike 'EventLog-Application' `
 -and $_.PSChildName -NotLike 'EventLog-Security' -and $_.PSChildName -NotLike 'EventLog-System' }
ForEach ($item in $Logger) { $path = $item -replace "HKEY_LOCAL_MACHINE","HKLM:"; Set-ItemProperty -Path $path -Name 'Start' -Value 0 -Force }
# Disable Performance Counters (Causes Vmauthd errors)
#$Path = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Perflib"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
#New-ItemProperty -Path $Path -Name "Disable Performance Counters" -PropertyType Dword -Value 1 -Force

<# Driver Adjustments #>
Write-Host "Change Low-level Driver Settings" -ForegroundColor Green
# Disable Devices in Devmgmt.msc that were already disabled through registry. (Get rid of exclamation mark)
Get-PnpDevice | Where-Object { $_.FriendlyName -match 'Remote Desktop Device Redirector Bus' } | Disable-PnpDevice -Confirm:$false -ea SilentlyContinue
Get-PnpDevice | Where-Object { $_.FriendlyName -match 'Microsoft Hyper-V Virtualization Infrastructure Driver' } | Disable-PnpDevice -Confirm:$false -ea SilentlyContinue
Get-PnpDevice | Where-Object { $_.FriendlyName -match 'Microsoft Storage Spaces Controller' } | Disable-PnpDevice -Confirm:$false -ea SilentlyContinue
Get-PnpDevice | Where-Object { $_.FriendlyName -match 'Microsoft Kernel Debug Network Adapter' } | Disable-PnpDevice -Confirm:$false -ea SilentlyContinue
Get-PnpDevice | Where-Object { $_.FriendlyName -match 'Remote Desktop USB Hub' } | Disable-PnpDevice -Confirm:$false -ea SilentlyContinue

# Disable Line-based Interrupt Emulation on devices where 'MSISupported' key exist. (Mostly applies to In-box HD Audio driver on most platforms)
$MSIMode = Get-ChildItem -Path 'HKLM:\SYSTEM\CurrentControlSet\Enum\PCI' -Recurse -Depth 5 | Where-Object { $_.PSChildName -Like 'MessageSignaledInterruptProperties' }
ForEach ($item in $MSIMode) { $path = $item -replace "HKEY_LOCAL_MACHINE","HKLM:"; Set-ItemProperty -Path $path -Name 'MSISupported' -Value 1 -Force }

# Change Mouse/Keyboard Event Buffer Size (Tested)
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\mouclass\Parameters"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "MouseDataQueueSize" -PropertyType Dword -Value 22 -Force
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters"; if(-not (Test-Path -Path $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -Path $Path -Name "KeyboardDataQueueSize" -PropertyType Dword -Value 22 -Force

# Purge Temporary Directories and other files
Write-Host "Clean Windows Component Store (WinSxS) and Temporary Directories" -ForegroundColor Green
rm -r C:\Windows\SoftwareDistribution\* -Force
rm -r C:\Users\Administrator\AppData\Local\Temp\* -Force
Remove-Item c:\Users\Public\Desktop\desktop.ini -Force
Remove-Item c:\Users\Administrator\Desktop\desktop.ini -Force
dism /online /Cleanup-Image /StartComponentCleanup # Winsxs (Old updates)

<# Script end #>
Stop-Transcript
Remove-PSDrive -Name HKU
Remove-PSDrive -Name HKCR
Write-Host "Script Done." -ForegroundColor Green