READ THIS FIRST - UploadBinaryDue_REV13 GitHub replacement files

This ZIP is intentionally simple: the real replacement files are directly in this folder.
There is no extra nested UploadBinaryDue_REV13 folder inside this ZIP.

What to do:

1. On GitHub, open:
   KD5VMF/Altair-Duino-/UploadBinaryDue_REV13

2. Keep your existing bossac.exe in that GitHub folder.

3. Delete/replace the old copies of these files:
   .gitattributes
   Install_Altair8800_REV13.bat
   Install_Altair8800_REV13.ps1
   README.md
   README_BIN_INSTALLER.md
   SHA256SUMS.txt
   altair8800_REV13.bin
   upload.bat

4. Upload the actual extracted files from this folder.
   Do not paste the script text into GitHub's editor.
   Do not upload this ZIP file itself.

Final GitHub UploadBinaryDue_REV13 folder should contain:
   bossac.exe
   altair8800_REV13.bin
   upload.bat
   Install_Altair8800_REV13.bat
   Install_Altair8800_REV13.ps1
   README.md
   README_BIN_INSTALLER.md
   SHA256SUMS.txt
   .gitattributes

Quick test after uploading:
   Open raw upload.bat on GitHub.
   It should show about 33 lines, not 1 line.

PowerShell flashing command:
   .\upload.bat COMX

Example:
   .\upload.bat COM7
