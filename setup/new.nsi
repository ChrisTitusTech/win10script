;NSIS Modern User Interface
;Basic Example Script
;Written by Joost Verburg

;--------------------------------
;Include Modern UI

  !include "MUI2.nsh"

;--------------------------------
;General

  ;Name and file
  Name "UWT"
  OutFile "setupuwt.exe"
  Unicode True

  ;Default installation folder
  InstallDir "C:\UWT"

  ;Request application privileges for Windows Vista
  RequestExecutionLevel user

;--------------------------------
;Interface Settings

  !define MUI_ABORTWARNING

;--------------------------------
;Pages

  !insertmacro MUI_PAGE_LICENSE "X:\CTTwin10box\setup\License.rtf"
  !insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_INSTFILES
  
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES
  
;--------------------------------
;Languages
 
  !insertmacro MUI_LANGUAGE "English"

;--------------------------------
;Installer Sections

Section "UWT" SecDummy

    # Install
    NSISdl::download "https://raw.githubusercontent.com/ChrisTitusTech/win10script/master/checkupdate.ps1" "C:\UWT\checkupdate.ps1"
    NSISdl::download "https://raw.githubusercontent.com/ChrisTitusTech/win10script/master/win10debloat.ps1" "C:\UWT\win10debloat.ps1"
    NSISdl::download "https://raw.githubusercontent.com/ChrisTitusTech/win10script/master/scripts/more.ps1" "C:\UWT\scripts\more.ps1"
    
    # set the installation directory as the destination for the following actions
    SetOutPath C:\UWT
 
    # create the uninstaller
    WriteUninstaller "C:\UWT\remove.exe"
 
    # create a shortcut named "new shortcut" in the start menu programs directory
    # point the new shortcut at the program uninstaller
    CreateShortcut "$SMPROGRAMS\Ultimate Windows Toolbox.lnk" "C:\UWT\win10debloat.ps1"
    CreateShortcut "$SMPROGRAMS\Remove Ultimate Windows Toolbox.lnk" "C:\UWT\remove.exe"
    CreateShortcut "$SMPROGRAMS\Update Ultimate Windows Toolbox.lnk" "C:\UWT\checkupdate.ps1"

SectionEnd

;--------------------------------
;Descriptions

  ;Language strings
  LangString DESC_SecDummy ${LANG_ENGLISH} "English"

  ;Assign language strings to sections
  !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${SecDummy} $(DESC_SecDummy)
  !insertmacro MUI_FUNCTION_DESCRIPTION_END

;--------------------------------
;Uninstaller Section

Section "Uninstall"

    # Remove the link from the start menu
    Delete "$SMPROGRAMS\Ultimate Windows Toolbox.lnk"
    Delete "$SMPROGRAMS\Remove Ultimate Windows Toolbox.lnk"

    # Delete the Program 
    delete C:\UWT\win10debloat.ps1
    delete C:\UWT\checkupdate.ps1
    delete C:\UWT\scripts\more.ps1

    # Delete the uninstaller
    Delete C:\UWT\remove.exe
# uninstaller section end

SectionEnd