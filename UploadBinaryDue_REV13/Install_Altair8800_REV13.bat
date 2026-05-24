@echo off
setlocal
cd /d "%~dp0"
title Altair8800 REV13 BIN Installer

echo.
echo Altair8800 Due Z80 Final REV13 - Easy BIN Installer
echo -----------------------------------------------------
echo.

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0Install_Altair8800_REV13.ps1" %*

echo.
echo Installer finished. Review any messages above.
pause
