@echo off
echo Install? (y/n)
set /p ic="> "

if "%ic%" == "y" goto i
if "%ic%" == "yes" goto i
if "%ic%" == "n" exit
if "%ic%" == "no" exit

:: Installer
:: https://raw.githubusercontent.com/christitustech/win10script/master/win10debloat.ps1
:: create folr scripts
:: https://raw.githubusercontent.com/christitustech/win10script/master/scripts/more.ps1
:i
cd /d C:\
mkdir UWT
cd UWT
xcopy /E /Y "https://raw.githubusercontent.com/christitustech/win10script/master/win10debloat.ps1"
mkdir scripts
xcopy /E /Y "https://raw.githubusercontent.com/christitustech/win10script/master/scripts/more.ps1"