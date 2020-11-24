# Windows10GamingFocus
This is A FORK Based On ChrisTitusTech that's foucus on debloat and optimize windows 10 for the lowest latency and best gaming experience, the Ultimate Windows 10 Script is a creation from multiple debloat scripts and gists from github. I also added Chocolatey and other tools to the script that I install on every machine.

## My Additions

- Dark Mode
- One Command to launch and run
- Chocolatey Install
- O&O Shutup10 CFG and Run
- Added Install Programs
- Added Debloat Microsoft Store Apps
- Added Gaming Optimization Tweaks
- Disabling HPET
- Add Ultimate PowerPlan and Activating. (dublicate might be found if script re-runs, just delete them!)
- Install Microsoft Visual Studio Libraries 2005-2017
- Disable FastBoot
- Forcing Raw Mouse Input 1:1 and Disabling Enhance Pointer Precision. (some old games donot honor this and might need mouse acceleration fix from here! http://donewmouseaccel.blogspot.com/2010/03/markc-windows-7-mouse-acceleration-fix.html).
- Enable Windows 10 Gaming Mode
- Enable Hardware-accelerated GPU scheduling
- Optimizing Network and applying Tweaks for no throttle and maximum speed!

# How To Use!
Simply Run cmd (Command Prompt) as Administrator and paste the following!
```
powershell -nop -c "iex(New-Object Net.WebClient).DownloadString('http://tweaks.daddymadu.gg')"
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
