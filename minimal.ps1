##########
# Tweaked Win10 Initial Setup Script
# Primary Author: Disassembler <disassembler@dasm.cz>
# Primary Author Source: https://github.com/Disassembler0/Win10-Initial-Setup-Script
# Tweaked Source: https://gist.github.com/alirobe/7f3b34ad89a159e6daa1/
#
#    Note from author: Never run scripts without reading them & understanding what they do.
#
#	Addition: One command to rule them all, One command to find it, and One command to Run it! 
#
#     > powershell -nop -c "iex(New-Object Net.WebClient).DownloadString('https://git.io/JJ8R4')"
#
#	Chris Titus Tech Additions:
#
#	- Dark Mode
#	- One Command to launch and run
#	- Chocolatey Install
#	- O&O Shutup10 CFG and Run
#	- Added Install Programs
#	- Added Debloat Microsoft Store Apps
#	- Added Confirm Menu for Adobe and Brave Browser
#	- Changed Default Apps to Notepad++, Brave, Irfanview, and more using XML Import feature
#
##########
# Default preset
Write-Host "Check out original author source for the CLI Sysadmin script @ https://github.com/Disassembler0/Win10-Initial-Setup-Script"
