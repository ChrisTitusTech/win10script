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

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = New-Object System.Drawing.Point(600,400)
$Form.text                       = "Form"
$Form.TopMost                    = $false

$PictureBox1                     = New-Object system.Windows.Forms.PictureBox
$PictureBox1.width               = 600
$PictureBox1.height              = 45
$PictureBox1.location            = New-Object System.Drawing.Point(0,14)
$PictureBox1.imageLocation       = "https://raw.githubusercontent.com/ChrisTitusTech/win10script/master/ctt-restore-scripts.png"
$PictureBox1.SizeMode            = [System.Windows.Forms.PictureBoxSizeMode]::zoom
$EActionCenter                  = New-Object system.Windows.Forms.Button
$EActionCenter.text             = "Enable Action Center"
$EActionCenter.width            = 200
$EActionCenter.height           = 30
$EActionCenter.location         = New-Object System.Drawing.Point(50,100)
$EActionCenter.Font             = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$ECortana                       = New-Object system.Windows.Forms.Button
$ECortana.text                  = "Enable Cortana"
$ECortana.width                 = 200
$ECortana.height                = 30
$ECortana.location              = New-Object System.Drawing.Point(50,150)
$ECortana.Font                  = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$HTrayIcons                     = New-Object system.Windows.Forms.Button
$HTrayIcons.text                = "Hide Tray Icons"
$HTrayIcons.width               = 200
$HTrayIcons.height              = 30
$HTrayIcons.location            = New-Object System.Drawing.Point(350,100)
$HTrayIcons.Font                = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$Form.controls.AddRange(@($PictureBox1,$EActionCenter,$ECortana,$HTrayIcons))

$HTrayIcons.Add_Click({ 
	$ErrorActionPreference = 'SilentlyContinue'
	Write-Host "Hiding tray icons..."
	Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "EnableAutoTray" -ErrorAction SilentlyContinue 
	Write-Host "Done - Reverted to Stock Settings"
})
	
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

[void]$Form.ShowDialog()