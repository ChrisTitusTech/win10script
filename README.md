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

## My reductions
- WSearch Service is enabled (for search)
- StorSvc service is enabled (for external usb drives)
- QWAVE service is enabled (for sound)
- Spooler service is enabled (even network printers don't seem to work)
- WpcMonSvcis serviec enabled (parental control, if you have children)
- PrintNotify service is enabled (printer notification)
- BthAvctpSvc service is enabled (it is for wireless headphones/speakers)
- cbdhsvc_48486de service is enabled (it is the clipboard, this feature is really convenient for me)
- WpnService service is enabled (for push notifications)
- RtkBtManServ service is enabled (Realtek Bluetooth Device Manager, I'm not sure about this one so I keep it)

## How to Run
Paste this command into Powershell (admin):
```
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/d4rklynk/win10script/master/win10debloat.ps1'))
```
For complete details check out https://christitus.com/debloat-windows-10-2020/
