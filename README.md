# Ultimate Windows Toolbox
This script is the culmination of many scripts and gists from github with features of my own. I am building this script to be a swiss army knife of Windows tools to help setup and optimize machines.

## My Additions
- One command to run
- Full GUI implementation
- Winget install
- Install popular programs with one click
- O&O Shutup 10 CFG and Run
- Dark/Light mode
- Semi-configurable

## How to Run
Paste this command into Powershell (admin):
```
iex ((New-Object System.Net.WebClient).DownloadString('https://git.io/JJ8R4'))
```
Or, shorter:
```
iwr -useb https://git.io/JJ8R4 | iex
```

For complete details check out https://christitus.com/debloat-windows-10-2020/

## Arguments
Runs sections of the script unattended based off of passed arguments

Example:
```
./win10debloat.ps1 -Essential -Dark -QuitAfter
```
Runs Essential Tweaks, Enables Dark Mode, and then Quits the Script.

Options:
- `-Essential`: Essential Tweaks
- `-UndoEssential`: Undo Essential Tweaks
- `-UTCTime`: Set Time to UTC for Dual Boot
- `-Numlock`: Makes Numlock not reset on reboot
- `-NumlockFix`: Undo -Numlock
- `-Search`: Tweak Search and Start Menu
- `-Background`: Disable Background Apps
- `-BackgroundUndo`: Enable Background Apps
- `-DisableCortana`: Disable Cortana
- `-EnableCortana`: Enable Cortana
- `-BloatApps`: Remove Bloatware
- `-BloatUndo`: Reinstall removed Bloatware
- `-SecurityWindowsUpdates`: Set Windows Update to Security Updates Only
- `-DefaultWindowsUpdates`: Set Windows Update to Default
- `-DisableWindowsUpdates`: Disable Windows Update
- `-EnableWindowsUpdates`: Enable Windows Update
- `-DisableActionCenter`: Disable Action Center (Doesn't Run on Windows 11)
- `-EnableActionCenter`: Enable Action Center
- `-PerformanceVisuals`: Set Visuals for Performance
- `-AppearanaceVisuals`: Set Visuals for Appearance
- `-DisableOneDrive`: Disable and Uninstall OneDrive
- `-EnableOneDrive`: Enable and Install OneDrive
- `-Dark`: Enables Dark Mode
- `-Light`: Enables Light Mode
- `-HideTrayIcons`: Hides Tray Icons
- `-ShowTrayIcons`: Shows Tray Icons
- `-ClipboardHistoryUndo`: Enable Clipboard History (Disabled in -Essential)
- `-LocationTrackUndo`: Enable Location Tracking (Disabled in -Essential)
- `-EnableHibernation`: Enable Hibernation
- `-YourPhoneUndo`: Install Your Phone App (Removed in -BloatApps)
- `-PowerPlans`: Restore Default Windows Power Plans
- `-EnableNFS`: Enable NFS
- `-EnableVirtualization`: Enable Hyper-V and WSL
- `-WindowsUpdateRepair`: Reset/Repair Windows Update
- `-QuitAfter`: Quit after running arguments