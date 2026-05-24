@echo off
setlocal
cd /d "%~dp0"

REM Easy command-line uploader.
REM Examples:
REM   upload.bat COMX
REM   upload.bat altair8800_REV13.bin COMX
REM From PowerShell, run it as: .\upload.bat COMX

set "BIN=altair8800_REV13.bin"
set "PORT="

if "%~1"=="" goto RUN_INTERACTIVE

set "FIRST=%~1"
if /I "%~x1"==".bin" (
  set "BIN=%~1"
  set "PORT=%~2"
) else (
  set "PORT=%~1"
)

:RUN_INTERACTIVE
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0Install_Altair8800_REV13.ps1" -Bin "%BIN%" -Port "%PORT%"

echo.
pause
