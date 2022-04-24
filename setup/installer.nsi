# define name of installer
OutFile "uwt_setup.exe"
Name "UWT Setup"
Unicode True
 # DOESNT WORK!!!
# include  stuff
!include "MUI2.nsh"
 
# define installation directory
InstallDir C:\UWT
 
# For removing Start Menu shortcut in Windows 7
RequestExecutionLevel user
 
# start default section
Section
    !define MUI_COMPONENTSPAGE_SMALLDESC ;No value
    !define MUI_INSTFILESPAGE_COLORS "FFFFFF 000000" ;Two colors
    !define MUI_UNICON "X:\CTTwin10box\Setup\dellogo.png"
    !define MUI_ICON "X:\CTTwin10box\Setup\logo.png"
    !define MUI_HEADERIMAGE_BITMAP "bi.bmp"
    !define MUI_HEADERIMAGE_UNBITMAP "bu.bmp"
    !define MUI_WELCOMEFINISHPAGE_BITMAP "bf.bmp"
    !define MUI_UNWELCOMEFINISHPAGE_BITMAP "bd.bmp"
    !define MUI_ABORTWARNING
    !define MUI_ABORTWARNING_TEXT "Are you sure?"
    !define MUI_UNABORTWARNING
    !define MUI_UNABORTWARNING_TEXT "Are you sure?"
    !define MUI_PAGE_WELCOME
    !define MUI_PAGE_LICENSE "license.rtf"
    !define MUI_PAGE_INSTFILES
    !define MUI_PAGE_FINISH
    !define MUI_UNPAGE_WELCOME
    !define MUI_UNPAGE_LICENSE "license.rtf"
    !define MUI_UNPAGE_INSTFILES
    !define MUI_UNPAGE_FINISH
    !define MUI_PAGE_HEADER_TEXT "Ultimate Windows Toolbox Setup"
    !define MUI_WELCOMEPAGE_TITLE "Ultimate Windows Toolbox Setup"
    !define MUI_WELCOMEPAGE_TEXT "Welcome to the Ultimate Windows Toolbox Setup!"
    !define MUI_LICENSEPAGE_TEXT_TOP "License"
    !insertmacro MUI_LICENSEPAGE_CHECKBOX 
    !define MUI_INSTFILESPAGE_FINISHHEADER_TEXT "Setup Completed!"
    !define MUI_INSTFILESPAGE_FINISHHEADER_SUBTEXT "You can now close this window."
    !define MUI_INSTFILESPAGE_ABORTHEADER_TEXT "Setup aborted."
    !define MUI_INSTFILESPAGE_ABORTHEADER_SUBTEXT "The Setup has been canceled."
    !define MUI_FINISHPAGE_TITLE "Setup Completed!"
    !define MUI_FINISHPAGE_TEXT "You can now close this window."


    #Install
    # NSISdl::download "http://www.URL.com/file.exe" "$INSTDIR\file.exe"
    # NSISdl::download "http://www.URL.com/file.exe" "$INSTDIR\file.exe"
    # NSISdl::download "http://www.URL.com/file.exe" "$INSTDIR\file.exe"
    
    # set the installation directory as the destination for the following actions
    SetOutPath $INSTDIR
 
    # create the uninstaller
    WriteUninstaller "$INSTDIR\remove.exe"
 
    # create a shortcut named "new shortcut" in the start menu programs directory
    # point the new shortcut at the program uninstaller
    CreateShortcut "$SMPROGRAMS\Ultimate Windows Toolbox.lnk" "$INSTDIR\win10debloat.ps1"
    CreateShortcut "$SMPROGRAMS\Remove Ultimate Windows Toolbox.lnk" "$INSTDIR\remove.exe"
SectionEnd
 
# uninstaller section start
Section "uninstall"
 
    # Remove the link from the start menu
    Delete "$SMPROGRAMS\Ultimate Windows Toolbox.lnk"
    Delete "$SMPROGRAMS\Remove Ultimate Windows Toolbox.lnk"

    # Delete the Program 
    delete $INSTDIR\win10debloat.ps1
    delete $INSTDIR\checkupdate.ps1
    delete $INSTDIR\scripts\more.ps1

    # Delete the uninstaller
    Delete $INSTDIR\remove.exe
# uninstaller section end
SectionEnd