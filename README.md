# Windows10GamingFocus
This is A FORK Based On ChrisTitusTech that's foucus on debloat and optimize windows 10 for the lowest latency and best gaming experience, the Ultimate Windows 10 Script is a creation from multiple debloat scripts and gists from github. I also added Chocolatey and other tools to the script that I install on every machine.

## Changelog!

6 Dec 2020
```
added Option to enable or disable Microsoft Software Protection Platform Service” Causing High CPU Usage in older systems
added Option to enable or disable Microsoft Store and Wsappx to Fix 100% Disk Usage in Windows 10 in older systems
```

5 Dec 2020
```
fixed Restrict windows update p2p only to local
added Disable Core Parking on current PowerPlan Ultimate Performance
Now No Need To disable High precision event timer manually! script will do it for you!
```
2 Dec 2020
```
Option to Enable & Install Or Disable & Uninstall Microsoft OneDrive
```
## This Script Does The Following!

- Dark Mode.
- One Command to launch and run.
- Chocolatey Install.
- O&O Shutup10 CFG and Run.
- Added Install Programs.
- Added Debloat Microsoft Store Apps.
- Removing Bloadwares.
- Disable Or Enable Microsoft Windows Defender and related Processes.
- Disable or Enable Microsoft Software Protection Platform Service” Causing High CPU Usage.
- Disable or Enable Wsappx to Fix 100% Disk Usage in Windows 10 in older systems.
- Disabling Telemetry.
- Disabling Wi-Fi Sense.
- Disabling SmartScreen Filter.
- Disabling Bing Search in Start Menu.
- Disabling Application suggestions.
- Disabling Activity History.
- Disabling Background application access.
- Disabling Location Tracking.
- Disabling automatic Maps updates.
- Disabling Feedback.
- Disabling Tailored Experiences.
- Disabling Advertising ID.
- Disabling Cortana.
- Disabling Error reporting.
- Restricting Windows Update P2P only to local network.
- Stopping and disabling Diagnostics Tracking Service.
- Stopping and disabling WAP Push Service.
- Lowering UAC level.
- Disabling SMB 1.0 protocol.
- Setting current network profile to private.
- Setting unknown networks profile to private.
- Disabling automatic installation of network devices.
- Enabling F8 boot menu options.
- Disabling Meltdown (CVE-2017-5754) compatibility flag.
- Enabling Malicious Software Removal Tool offering.
- Enabling driver offering through Windows Update.
- Disabling Windows Update automatic restart.
- Stopping and disabling Home Groups services.
- Disabling Shared Experiences.
- Disabling Remote Assistance.
- Enabling Remote Desktop w/o Network Level Authentication.
- Disabling Autoplay.
- Disabling Autorun for all drives.
- Disabling Storage Sense.
- Disabling scheduled defragmentation.
- Stopping and disabling Superfetch service.
- Starting and enabling Windows Search indexing service.
- Setting BIOS time to UTC.
- Disabling Hibernation.
- Enabling Sleep start menu and keyboard button.
- Disabling display and sleep mode timeouts.
- Disabling Fast Startup.
- Disabling Action Center.
- Enabling Lock screen.
- Enabling Lock screen (removing scheduler workaround).
- Disabling Sticky keys prompt.
- Showing task manager details.
- Showing file operations details.
- Disabling file delete confirmation dialog.
- Hiding Taskbar Search icon / box.
- Hiding Task View button.
- Hiding People icon.
- Showing all tray icons.
- Disabling search for app in store for unknown extensions.
- Disabling 'How do you want to open this file?' prompt.
- Adjusting visual effects for performance.
- Enabling NumLock after startup.
- Enabling Dark Mode
- Stopping Edge from taking over as the default .PDF viewer 
- Showing known file extensions.
- Hiding hidden files.
- Hiding sync provider notifications.
- Hiding recent shortcuts.
- Changing default Explorer view to This PC.
- Hiding Music icon from This PC.
- Hiding Music icon from Explorer namespace.
- Hiding Videos icon from This PC.
- Hiding Videos icon from Explorer namespace.
- Hiding 3D Objects icon from This PC.
- Hiding 3D Objects icon from Explorer namespace.
- Enabling thumbnails.
- Enable creation of Thumbs.db.
- Option to Enable & Install Or Disable & Uninstall Microsoft OneDrive.
- Disabling built-in Adobe Flash in IE and Edge.
- Installing Windows Media Player.
- Uninstalling Internet Explorer.
- Uninstalling Work Folders Client.
- Installing Linux Subsystem.
- Setting Photo Viewer association for bmp, gif, jpg, png and tif.
- Adding Photo Viewer to "Open with.
- Installing Microsoft Print to PDF.
- Enabling DaddyMadu Quality of Life Tweaks.
- Disabling GameDVR1.
- Disabling GameDVR2.
- Disabling Full ScreenOptimization.
- Apply Gaming Optimization Fixs.
- Applying PC Optimizations.
- Forcing Raw Mouse Input 1:1 and Disabling Enhance Pointer Precision. (some old games donot honor this and might need mouse acceleration fix from here! http://donewmouseaccel.blogspot.com/2010/03/markc-windows-7-mouse-acceleration-fix.html).
- Disabling High Precision Event Timer.
- Enabling Gaming Mode.
- Enabling HAGS.
- Disable Windows 10 Core Parking On Current PowerPlan "Ultimate Performance".
- Optimizing Network and applying Tweaks for no throttle and maximum speed!.
- Removing Edit with Paint 3D from context menu.
- Running DaddyMadu Ultimate Cleaner => Temp folders & Flush DNS + Reset IP.
- Fix issue with games shortcut that created by games lunchers turned white.
- Clearing Temp folders.

# Notice Before Use!

- Kindly note that if you choose to disable Microsoft Store and WSAPPX Service and wanted to enable it again, you have to run the script with this setting enabled then restart pc and rerun it again with the same settings to get Microsoft Store back! it a limitition of windows 10 as this registry tweak needs restart to take effect before script is trying to install microsoft store!
- When disabling Microsoft Store & WSAPPX Service and Microsoft Software Protection Platform Service, This PC Properties will only be accessible from File Explorer!

# How To Use!
Disable Any Power saving feature under your network Devices. ex: Lan card, Wifi Card etc!
also under Network Power Management Untick all marks!
Click OK and you are good to go!
Simply Run cmd (Command Prompt) as Administrator and paste the following!
```
powershell -nop -c "iex(New-Object Net.WebClient).DownloadString('http://tweaks.daddymadu.gg')"
```
if error then use the following!
```
powershell -NoProfile -ExecutionPolicy unrestricted -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; &iex(New-Object Net.WebClient).DownloadString('http://tweaks.daddymadu.gg')"
```
Or Run Powershell As Administrator and paste the following!
```
iex(New-Object Net.WebClient).DownloadString('http://tweaks.daddymadu.gg')
```

## Modifications
I encourage people to fork this project and comment out things they don't like! Here is a list of normal things people change:
- Uninstalling OneDrive (This is on in my script)
- Installing Adobe, Chocolatey, Notepad++, MPC-HC, and 7-Zip

Comment any thing you don't want out... Example:

```
########## NOTE THE # SIGNS! These disable lines This example shows UACLow being set and Disabling SMB1
### Security Tweaks ###
	"SetUACLow",                  # "SetUACHigh",
	"DisableSMB1",                # "EnableSMB1",

########## NOW LETS SWAP THESE VALUES AND ENABLE SMB1 and Set UAC to HIGH
### Security Tweaks ###
	"SetUACHigh",
	"EnableSMB1",
```
