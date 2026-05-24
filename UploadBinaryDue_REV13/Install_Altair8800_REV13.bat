@echo off
setlocal
cd /d "%~dp0"
title Altair8800 REV13 BIN Installer

echo.
echo Altair8800 Due Z80 Final REV13 - Easy BIN Installer
echo -----------------------------------------------------
echo.
echo This installer flashes altair8800_REV13.bin to an Arduino Due.
echo Use the Arduino Due PROGRAMMING PORT, not the Native USB port.
echo.

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0Install_Altair8800_REV13.ps1" %*

set "RESULT=%ERRORLEVEL%"
echo.
if not "%RESULT%"=="0" (
    echo Installer failed. Review the messages above.
) else (
    echo Installer finished successfully.
)
pause
exit /b %RESULT%
