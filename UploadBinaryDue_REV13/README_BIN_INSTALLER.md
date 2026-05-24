# Altair8800 Due Z80 Final REV13 - Easy BIN Installer

This is the ready-to-flash Windows installer package for **Altair8800 Due Z80 Final REV13**.

Your uploaded firmware binary was renamed to:

```text
altair8800_REV13.bin
```

Firmware check:

```text
File size : 398,580 bytes
SHA-256   : 5764b792f0afc0fb9650093c019d1dd871fc19e70667f5bad3cc3fa8e8e997dd
```

## Folder contents

```text
UploadBinaryDue_REV13_READY_FINAL/
  Install_Altair8800_REV13.bat     double-click installer
  Install_Altair8800_REV13.ps1     real flashing script
  upload.bat                       quick command-line uploader
  altair8800_REV13.bin             REV13 firmware binary
  SHA256SUMS.txt                   checksum for the firmware
  README_BIN_INSTALLER.md          this file
```

## Important: bossac.exe

This package does not include `bossac.exe` because it was not in the uploaded files.

The installer will automatically search for `bossac.exe` in the normal Arduino locations, including:

```text
%LOCALAPPDATA%\Arduino15\packages\arduino\tools\bossac\
C:\Program Files (x86)\Arduino\hardware\tools\bossac.exe
C:\Program Files\Arduino\hardware\tools\bossac.exe
```

For a fully portable release exactly like the simple `UploadBinaryDue` style package, copy `bossac.exe` into this same folder beside `upload.bat`.

## Easiest flashing method

1. Plug the USB cable into the **Arduino Due Programming Port**.
2. Unzip this folder.
3. Double-click:

```text
Install_Altair8800_REV13.bat
```

4. When asked, enter the Due COM port, for example:

```text
COM7
```

The script runs BOSSA with this style of command:

```text
bossac.exe --port=COM7 -U false -e -w -v -b altair8800_REV13.bin -R
```

## PowerShell quick command

If you are already in the installer folder in **PowerShell**, run it like this:

```powershell
.\upload.bat COMX
```

Replace `COMX` with the Arduino Due Programming Port, for example:

```powershell
.\upload.bat COM7
```

This matters because PowerShell will not run `upload.bat COM7` from the current folder unless the command starts with `.\`.

## Command-line flashing method

From Command Prompt inside this folder:

```bat
upload.bat COMX
```

Example:

```bat
upload.bat COM7
```

Or explicitly name the binary:

```bat
upload.bat altair8800_REV13.bin COMX
```

Example:

```bat
upload.bat altair8800_REV13.bin COM7
```

From PowerShell, include `.\` because PowerShell does not run programs from the current folder by name:

```powershell
.\upload.bat COMX
```

## Finding the COM port

On Windows:

1. Open **Device Manager**.
2. Expand **Ports (COM & LPT)**.
3. Find the Arduino Due Programming Port.
4. Use that COM number in the installer.

## After flashing: SD card and CP/M

Flashing the `.bin` installs the emulator firmware only. CP/M still boots from disk image files on the SD card.

From the main REV13 project, copy the disk image files to the root of the SD card. Typical files include:

```text
DISK01.DSK
DISK02.DSK
DISKDIR.TXT
HDSK01.DSK
HDSKDIR.TXT
```

Then insert the SD card into the SD adapter connected to the Arduino Due / Altair8800 setup.

## Starting CP/M

1. Open your serial terminal at **115200 baud**.
2. Reset the Arduino Due.
3. Open the Altair8800 setup/configuration menu.
4. Confirm CPU mode, memory size, serial cards, and disk settings.
5. Mount/select the CP/M disk image as the boot disk.
6. Exit the setup menu and boot.
7. A successful CP/M boot should show:

```text
A>
```

## If flashing fails

Try these in order:

1. Confirm the USB cable is in the **Programming Port**, not the Native USB port.
2. Confirm the COM port is correct.
3. Press reset on the Arduino Due and run the installer again.
4. Install Arduino IDE and the **Arduino SAM Boards** package so `bossac.exe` is available.
5. Copy `bossac.exe` directly into this folder and rerun `Install_Altair8800_REV13.bat`.

## If firmware flashes but CP/M does not boot

The firmware and disk images are separate. Recheck:

- SD card is inserted.
- Disk image files are on the SD card root.
- File names match what the simulator expects.
- Boot disk is mounted in the simulator menu.
- Serial terminal is connected at 115200 baud.
