:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------    
bitsadmin.exe /transfer "WPRS Powershell Script" https://github.com/Edowndotdown/WindowsApps-Permissions-Reset-Script/raw/main/WindowsAppsUnfukker.ps1 "%cd%\WindowsAppsUnfukker.ps1"
bitsadmin.exe /transfer "WPRS paexec " https://github.com/Edowndotdown/WindowsApps-Permissions-Reset-Script/raw/main/paexec.exe "%cd%\paexec.exe"

paexec -s -i cmd /C powershell -ExecutionPolicy Bypass -File "%cd%\WindowsAppsUnfukker.ps1" "%LocalAppData%" ^|^| pause
del WindowsAppsUnfukker.ps1
del paexec.exe
exit