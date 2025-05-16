@echo off
setlocal

:: Check PowerShell execution policy
powershell -NoProfile -Command ^
  "if ((Get-ExecutionPolicy) -eq 'Restricted') { exit 1 } else { exit 0 }"

if errorlevel 1 (
    echo [ERROR] PowerShell script execution is restricted.
    echo Please enable script execution with:
    echo.
    echo     powershell -NoProfile -Command "Set-ExecutionPolicy Unrestricted -Scope CurrentUser -Force"
    echo.
    pause
    exit /b 1
)

:: If not restricted, run the actual PowerShell script
powershell -NoProfile -ExecutionPolicy Bypass -File "install.ps1"
pause