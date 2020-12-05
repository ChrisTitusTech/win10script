# This script restores cortana, action center and tray icons to their out of box state

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$ErrorActionPreference = 'SilentlyContinue'

$Button = [System.Windows.MessageBoxButton]::YesNoCancel
$ErrorIco = [System.Windows.MessageBoxImage]::Error
$Ask = 'Do you want to run this as an Administrator?
        Select "Yes" to Run as an Administrator
        Select "No" to not run this as an Administrator
        
        Select "Cancel" to stop the script.'

If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
    $Prompt = [System.Windows.MessageBox]::Show($Ask, "Run as an Administrator or not?", $Button, $ErrorIco) 
    Switch ($Prompt) {
        #This will debloat Windows 10
        Yes {
            Write-Host "You didn't run this script as an Administrator. This script will self elevate to run as an Administrator and continue."
            Start-Process PowerShell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
            Exit
        }
        No {
            Break
        }
    }
}

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = New-Object System.Drawing.Point(804,708)
$Form.text                       = "CTT Restore Scripts"
$Form.TopMost                    = $false

$PictureBox1                     = New-Object system.Windows.Forms.PictureBox
$PictureBox1.width               = 600
$PictureBox1.height              = 45
$PictureBox1.location            = New-Object System.Drawing.Point(103,23)
$PictureBox1.imageLocation       = "https://raw.githubusercontent.com/ChrisTitusTech/win10script/master/ctt-restore-scripts.png"
$PictureBox1.SizeMode            = [System.Windows.Forms.PictureBoxSizeMode]::zoom
$EActionCenter                   = New-Object system.Windows.Forms.Button
$EActionCenter.text              = "Enable Action Center"
$EActionCenter.width             = 200
$EActionCenter.height            = 30
$EActionCenter.location          = New-Object System.Drawing.Point(43,99)
$EActionCenter.Font              = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$ECortana                        = New-Object system.Windows.Forms.Button
$ECortana.text                   = "Enable Cortana"
$ECortana.width                  = 200
$ECortana.height                 = 30
$ECortana.location               = New-Object System.Drawing.Point(43,153)
$ECortana.Font                   = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$HTrayIcons                      = New-Object system.Windows.Forms.Button
$HTrayIcons.text                 = "Hide Tray Icons"
$HTrayIcons.width                = 200
$HTrayIcons.height               = 30
$HTrayIcons.location             = New-Object System.Drawing.Point(407,99)
$HTrayIcons.Font                 = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$EClipboardHistory               = New-Object system.Windows.Forms.Button
$EClipboardHistory.text          = "Enable Clipboard History"
$EClipboardHistory.width         = 200
$EClipboardHistory.height        = 30
$EClipboardHistory.location      = New-Object System.Drawing.Point(407,151)
$EClipboardHistory.Font          = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$RWDIcon                         = New-Object system.Windows.Forms.Button
$RWDIcon.text                    = "Restore Windows Defender Icon"
$RWDIcon.width                   = 200
$RWDIcon.height                  = 45
$RWDIcon.location                = New-Object System.Drawing.Point(43,207)
$RWDIcon.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$ELocation                       = New-Object system.Windows.Forms.Button
$ELocation.text                  = "Enable Location"
$ELocation.width                 = 200
$ELocation.height                = 30
$ELocation.location              = New-Object System.Drawing.Point(407,215)
$ELocation.Font                  = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$RWindowsSearch                  = New-Object system.Windows.Forms.Button
$RWindowsSearch.text             = "Restore Windows Search"
$RWindowsSearch.width            = 200
$RWindowsSearch.height           = 45
$RWindowsSearch.location         = New-Object System.Drawing.Point(43,276)
$RWindowsSearch.Font             = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$RBackgroundApps                 = New-Object system.Windows.Forms.Button
$RBackgroundApps.text            = "Restore Background Apps"
$RBackgroundApps.width           = 200
$RBackgroundApps.height          = 45
$RBackgroundApps.location        = New-Object System.Drawing.Point(407,279)
$RBackgroundApps.Font            = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$Form.controls.AddRange(@($PictureBox1,$EActionCenter,$ECortana,$HTrayIcons,$EClipboardHistory,$RWDIcon,$ELocation,$RWindowsSearch,$RBackgroundApps))

$EActionCenter.Add_Click({
    Write-Host "Enabling Action Center..."
	Remove-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name "DisableNotificationCenter" -ErrorAction SilentlyContinue
	Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" -Name "ToastEnabled" -ErrorAction SilentlyContinue 
	Write-Host "Done - Reverted to Stock Settings"
})

$ECortana.Add_Click({
    Write-Host "Enabling Cortana..."
	Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Personalization\Settings" -Name "AcceptedPrivacyPolicy" -ErrorAction SilentlyContinue
	If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore")) {
		New-Item -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization" -Name "RestrictImplicitTextCollection" -Type DWord -Value 0
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization" -Name "RestrictImplicitInkCollection" -Type DWord -Value 0
	Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" -Name "HarvestContacts" -ErrorAction SilentlyContinue
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortana" -ErrorAction SilentlyContinue 
	Write-Host "Done - Reverted to Stock Settings"
})

$RWDIcon.Add_Click({
	Write-Host "Restoring Windows Defender Icon..."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "SecurityHealth" -Type ExpandString -Value "%windir%\system32\SecurityHealthSystray.exe" 
	Write-Host "Done - Reverted to Stock Settings"
})

$RWindowsSearch.Add_Click({
	Write-Host "Restoring Windows Search..."
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -Type DWord -Value "1"
	Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "CortanaConsent" -ErrorAction SilentlyContinue
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "DisableWebSearch" -ErrorAction SilentlyContinue
	Write-Host "Restore and Starting Windows Search Service..."
    Set-Service "WSearch" -StartupType Automatic
    Start-Service "WSearch" -WarningAction SilentlyContinue
    Write-Host "Restore Windows Search Icon..."
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Type DWord -Value 1 
	Write-Host "Done - Reverted to Stock Settings"
})

$HTrayIcons.Add_Click({
	$ErrorActionPreference = 'SilentlyContinue'
	Write-Host "Hiding tray icons..."
	Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "EnableAutoTray" -ErrorAction SilentlyContinue 
	Write-Host "Done - Reverted to Stock Settings"
})

$EClipboardHistory.Add_Click({
	Write-Host "Restoring Clipboard History..."
	Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Clipboard" -Name "EnableClipboardHistory" -ErrorAction SilentlyContinue
    Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "AllowClipboardHistory" -ErrorAction SilentlyContinue 
	Write-Host "Done - Reverted to Stock Settings"
})

$ELocation.Add_Click({
	Write-Host "Enabling Location Provider..."
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" -Name "DisableWindowsLocationProvider" -ErrorAction SilentlyContinue
	Write-Host "Enabling Location Scripting..."
    Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" -Name "DisableLocationScripting" -ErrorAction SilentlyContinue
	Write-Host "Enabling Location..."
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" -Name "DisableLocation" -ErrorAction SilentlyContinue
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" -Name "SensorPermissionState" -ErrorAction SilentlyContinue
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" -Name "Value" -Type String -Value "Allow"
	Write-Host "Allow access to Location..."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Name "Value" -Type String -Value "Allow"
	Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration" -Name "Status" -Type DWord -Value "1"
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsAccessLocation" -ErrorAction SilentlyContinue
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsAccessLocation_UserInControlOfTheseApps" -ErrorAction SilentlyContinue
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsAccessLocation_ForceAllowTheseApps" -ErrorAction SilentlyContinue
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsAccessLocation_ForceDenyTheseApps" -ErrorAction SilentlyContinue 
	Write-Host "Done - Reverted to Stock Settings"
})

$RBackgroundApps.Add_Click({
	Write-Host "Allowing Background Apps..."
	Get-ChildItem -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" -Exclude "Microsoft.Windows.Cortana*" | ForEach {
		Remove-ItemProperty -Path $_.PsPath -Name "Disabled" -ErrorAction SilentlyContinue
		Remove-ItemProperty -Path $_.PsPath -Name "DisabledByUser" -ErrorAction SilentlyContinue
	}
	Write-Host "Done - Reverted to Stock Settings"
})


[void]$Form.ShowDialog()
