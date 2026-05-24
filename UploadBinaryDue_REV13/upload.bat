@echo off
setlocal
cd /d "%~dp0"

REM Altair8800 Due Z80 Final REV13 quick uploader.
REM PowerShell example: .\upload.bat COM7
REM Command Prompt example: upload.bat COM7
REM Optional binary form: .\upload.bat altair8800_REV13.bin COM7

set "BIN=altair8800_REV13.bin"
set "PORT="

if "%~1"=="" goto RUN_INSTALLER

if /I "%~x1"==".bin" (
    set "BIN=%~1"
    set "PORT=%~2"
) else (
    set "PORT=%~1"
)

:RUN_INSTALLER
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0Install_Altair8800_REV13.ps1" -Bin "%BIN%" -Port "%PORT%"

set "RESULT=%ERRORLEVEL%"
echo.
if not "%RESULT%"=="0" (
    echo Upload failed. Review the messages above.
) else (
    echo Upload finished successfully.
)
pause
exit /b %RESULT%
