@ECHO off

echo -----------------------------------------------------------------------------------------------
echo THIS SCRIPT WILL EXTRACT WINDOWS SPOTLIGHT IMAGES
echo YOU MIGHT ENCOUNTER AN ERROR IF YOU HAVE NOT ENABLED WINDOWS SPOTLIGHT FOR YOUR LOCK SCREEN
echo -----------------------------------------------------------------------------------------------

echo Script created by AaravHattangadi

timeout 3 > nul

:oknotok
set /p var=Are you sure you want to continue?[Y/N]: 
if %var%== Y goto EXTRACT
if not %var%== Y exit

:extract
set /p optdir=Enter that path to your output directory here:

cd /d %userprofile%\AppData\Local\Packages\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\LocalState\Assets
robocopy . %optdir% /s /xf /min:200000
cd %optdir%
ren *.* *.jpg

echo The process has completed.

echo This script will automatically close now.
timeout 5
exit
