# Altair8800 Due Z80 Final REV13

Enhanced Arduino Due build of David Hansel's Altair 8800 Simulator with a switchable Intel 8080 / Zilog Z80 CPU core, corrected persistent settings, improved clock-speed control, Z80 opcode-audit fixes, and a cleaned final REV13 package.

This repository is based on the original Altair 8800 Simulator project by David Hansel:

- Original project: https://github.com/dhansel/Altair8800
- Original Hackster project page: https://www.hackster.io/david-hansel/arduino-altair-8800-simulator-3594a6
- Original support group: https://groups.google.com/forum/#!forum/altair-duino

This REV13 tree is an enhanced fork/drop-in package for the Arduino Due version. The goal is to keep the original Altair behavior available while adding a stronger Arduino Due setup for modern use, CP/M work, Z80 testing, and easier long-term configuration.

---

## What this project does

The Altair 8800 Simulator recreates the experience of using a MITS Altair 8800 on modern microcontroller hardware. It emulates the CPU, memory, front panel behavior, serial devices, disk controllers, hard disk support, printer support, and boot ROM helpers. With the Arduino Due and an SD card, it can boot included disk images such as CP/M and Altair Disk BASIC.

This Final REV13 build keeps that original purpose, but improves the Arduino Due version in these major ways:

- Boots by default into a faster Arduino Due profile.
- Supports runtime selection between Intel 8080 and Zilog Z80 emulation.
- Keeps true Intel 8080 mode for original Altair compatibility.
- Adds a safer cycle-count clock governor for fixed-speed operation.
- Fixes save/load persistence problems found in earlier enhanced revisions.
- Fixes SD-backed `STORAGE.DAT` random-write behavior.
- Audits and fixes important Z80 opcode/disassembler behavior.
- Provides a clearer startup banner and detailed revision notes.
- Builds successfully under the included PC/Linux host test target.

---

## Original version vs Final REV13

| Area | Original Altair8800 package | This Final REV13 package |
|---|---|---|
| Main target | Arduino Altair 8800 simulator with Arduino Mega, Arduino Due, Teensy, and PC support depending on configuration | Arduino Due focused enhanced build, while keeping the host/Linux test build usable |
| Default CPU in provided config | Intel 8080 only: `#define USE_Z80 0` | Switchable CPU build: `#define USE_Z80 2`; default reset profile prefers Zilog Z80 |
| 8080 compatibility | Original Intel 8080 emulation | Preserved; Intel 8080 remains selectable from the configuration menu |
| Z80 support | Available in source, but not enabled in the provided original config | Enabled and selectable at runtime; useful for Z80 CP/M software and Z80 opcode testing |
| Default performance style | More original-style Altair behavior with older throttle model | Max-performance default: 20 MHz target label, full-speed throttle off, 64 KB RAM, 115200 baud |
| Fixed-speed behavior | Older throttle / auto-adjust delay style | Cycle-count clock governor based on emulated instruction cycles and real elapsed microseconds |
| Clock menu | Basic throttle controls | `k`, `K`, `G`, `Q`, `!`, profiles, serial presets, and benchmark/timing report |
| Configuration persistence | Older config file version and persistence behavior | Config version bumped to 15; old stale configs rejected; save verifies by reading the saved header back |
| SD-backed settings | Could fail if `STORAGE.DAT` was short or append-style writes ignored seek positions | `STORAGE.DAT` is extended/preallocated and writable SD files are opened for random read/write |
| Arduino Due flash fallback | Original external library style | Local `DueFlashStorage.h` fallback included in the package |
| SD library compatibility | Expected external SdFat/library behavior | Local `SdFat.h` compatibility shim included for this package |
| Z80 opcode audit | Original Z80 implementation | REV12 audit fixes retained: DDCB/FDCB BIT behavior, ED 70/71, undefined ED handling, ignored DD/FD prefix timing, and disassembler cleanup |
| Startup banner | Original project banner/status behavior | Clear REV13 banner showing selected CPU, target speed, throttle mode, RAM, and primary I/O |
| Documentation | Minimal GitHub README plus full original documentation PDF/DOCX | Expanded README plus retained original documentation and revision notes |

---

## Important REV13 defaults

Fresh defaults in this package are:

| Setting | Final REV13 default |
|---|---|
| Target board | Arduino Due / SAM3X8E |
| Sketch to open | `Altair8800.ino` |
| USB port to use | Arduino Due Programming Port / Micro USB |
| Terminal speed | 115200 baud, 8 data bits, no parity, 1 stop bit |
| RAM | 64 KB |
| CPU mode | Zilog Z80 by default, switchable to Intel 8080 |
| CPU target label | 20 MHz |
| Throttle | Off / full speed by default |
| MITS floppy drives | Enabled: `NUM_DRIVES 4` |
| Hard disk support | Enabled: `NUM_HDSK_UNITS 1` |
| Cromemco/Tarbell drives | Disabled by default in this package |
| Printer support | Enabled |

The default is meant to be fast and convenient. For the most authentic old-software behavior, use the safe/original profile or manually select Intel 8080 mode plus a governed 2 MHz target.

---

## New and changed files in REV13

Important new files added by the enhanced package:

```text
DueFlashStorage.h
SdFat.h
README_FIRST_ARDUINO_DUE.txt
REV4_UPGRADE_NOTES.txt
REV5_ACCURATE_CLOCK_NOTES.txt
REV6_UPDATE_NOTES.txt
REV10_CHANGELOG_DROPIN.txt
REV10_SAVE_LOAD_SETTINGS_FIX_NOTES.txt
REV10_HOTFIX_CPU_CLOCK_GOVERNOR.txt
REV10_HOTFIX_SAVE_LOAD_SD_RANDOM_WRITE.txt
REV11_Z80_SWITCHABLE_CPU_NOTES.txt
REV12_CPU_OPCODE_AUDIT_NOTES.txt
FINAL_REV13_BUILD_LOG.txt
FINAL_REV13_STATIC_AUDIT.txt
FINAL_REV13_STARTUP_SMOKE_TEST_OUTPUT.txt
FINAL_REV13_VERIFICATION_NOTES.txt
```

Important source files changed from the original package:

```text
Altair8800.ino
config.cpp
config.h
cpucore.cpp
cpucore.h
cpucore_z80.cpp
disassembler_z80.cpp
host_due.cpp
host_due.h
host_pc.cpp
profile.cpp
profile.h
timer.cpp
Makefile
Arduino/Arduino.cpp
Arduino/Arduino.h
```

The disk image files from the original package are retained.

---

## Build verification status

The REV13 package includes its own verification logs. I also performed a fresh host/Linux build check of this tree.

Result:

```text
make clean
make -j2
```

The host build completed successfully. The only warning observed was the existing deprecated `ftime()` warning inside the PC Arduino compatibility shim. That warning does not indicate a REV13 logic failure.

The included static audit notes report:

```text
Intel 8080 root opcode dispatch table: 256 / 256 entries
Z80 root opcode dispatch table:       256 / 256 entries
Z80 CB prefix group:                  algorithmic 256-opcode coverage
Z80 DDCB/FDCB group:                  algorithmic 256-opcode coverage
Startup banner contains Final REV13:  PASS
```

---

## Opening the project in the Arduino IDE

Open this sketch:

```text
Altair8800.ino
```

Recommended Arduino IDE board selection:

```text
Tools -> Board -> Arduino SAM Boards -> Arduino Due (Programming Port)
```

Use the Arduino Due **Programming Port**, not the Native USB port, unless you intentionally changed the project settings.

Serial terminal settings:

```text
115200 baud
8 data bits
No parity
1 stop bit
No flow control unless your terminal setup requires otherwise
```

After upload, open the serial monitor or a terminal program at 115200 8N1.

A correct REV13 startup should look similar to this:

```text
================================================
 Altair 8800 Simulator - Enhanced Due Build
 Final REV13 - Stable 8080/Z80 + opcode audit - Created 2026-05-24
================================================
Emu CPU    : Zilog Z80
CPU target : 20.000 MHz
Throttle   : off / full speed
RAM        : 64 KB maximum
Primary I/O: USB Programming Port / Micro USB @ 115200 baud
Config menu: STOP + AUX1. Turbo toggle: Ctrl+T when serial input is enabled.
Clocking   : k/K/G clock selections automatically enable governed speed.
```

On the PC/Linux host build, the primary I/O line may say `Console @ 115200 baud`. That is expected for the host simulator target.

---

## Entering the configuration menu

Use the Altair front panel controls:

```text
Hold STOP and raise AUX1
```

The configuration menu is where most REV13 improvements are controlled.

Important main-menu keys:

| Key | Action |
|---|---|
| `c` | Toggle emulated CPU between Intel 8080 and Zilog Z80 |
| `k` | Move to the next faster CPU target preset and enable governed speed |
| `K` | Move to the next slower CPU target preset and enable governed speed |
| `G` | Enter a custom CPU target in kHz and enable governed speed |
| `Q` | Enable the cycle-accurate clock governor for the current target |
| `!` | Apply maximum-performance/full-speed profile |
| `A` | Open quick boot profiles |
| `N` | Open serial presets |
| `B` | Run benchmark/timing report |
| `D` | Configure MITS disk drives |
| `H` | Configure hard disks |
| `E` | Configure serial cards |
| `P` | Configure printer |
| `m` | Configure memory |
| `s` | Configure host serial settings |
| `I` | Configure interrupts |
| `F` | SD card file manager, when available |
| `S` | Save configuration |
| `L` | Load configuration |
| `R` | Reset to compiled defaults |
| `x` | Exit menu |

---

## Saving your power-on default settings

Configuration `0` is the power-on default. Save your preferred settings there.

Recommended fast REV13 default save:

```text
STOP + AUX1      enter configuration menu
!                apply max-performance profile
c                optional: toggle CPU if you want Intel 8080 instead of Z80
S                save configuration
0                save as config #0
y                overwrite if asked
x                exit
```

If you want the machine to power up in Z80 mode, make sure the processor line says:

```text
Pro(c)essor : Zilog Z80
```

If you want the machine to behave more like a standard Altair 8080 system, set it to:

```text
Pro(c)essor : Intel 8080
```

Then save config `0`.

---

## CPU modes: when to use 8080 vs Z80

Use **Intel 8080 mode** when:

- You want the most authentic original Altair behavior.
- You are testing original Altair software.
- A program behaves strangely and you want the safest compatibility mode.
- You are comparing behavior against real 8080-only hardware.

Use **Zilog Z80 mode** when:

- You want to run Z80-specific test programs.
- You want to run software that uses Z80 opcodes.
- You are working with CP/M programs that expect or benefit from Z80 instructions.
- You want to test the REV12 opcode-audit fixes.

Normal 8080 CP/M software should usually run in Z80 mode too because the Z80 is backward compatible with the 8080 instruction set, but Intel 8080 mode remains the best fallback for original Altair compatibility.

---

## Clock and speed behavior

REV13 has two main speed styles.

### Full-speed mode

Full-speed mode lets the Arduino Due run the emulator as fast as it can.

In the menu this appears as:

```text
Throttle : off / full speed
```

Use this when you want maximum performance.

To force this mode:

```text
STOP + AUX1
!
S
0
y
x
```

### Governed target-speed mode

Governed mode attempts to make the emulated CPU obey the selected target speed by comparing emulated instruction cycles to real elapsed time.

Use one of these keys:

```text
k   next faster clock preset
K   next slower clock preset
G   custom target in kHz
Q   enable accurate clock for current target
```

In REV13, choosing a target speed with `k`, `K`, or `G` automatically enables the governor. This fixes the earlier problem where the menu could show a selected target but the emulator still ran at raw full speed.

### Good realistic Altair setting

For old software that expects a closer original machine speed:

```text
CPU       : Intel 8080
Target    : 2 MHz
Throttle  : cycle-accurate target
RAM       : 64 KB
Terminal  : 9600 or 115200 depending on your setup
```

The quick profile menu can apply a safe/original profile for this.

---

## Preparing the SD card for disks and CP/M

Disk support uses an SD card connected to the Arduino Due SPI header. The original documentation has the full wiring details. This package keeps the original disk images in the `disks` folder.

For the Arduino Due SD card, copy the **contents** of the `disks` folder to the **root** of the SD card.

Example SD card root after copying:

```text
DISK01.DSK
DISK02.DSK
DISK03.DSK
DISK04.DSK
...
DISK16.DSK
DISKDIR.TXT
HDSK01.DSK
HDSK02.DSK
HDSK03.DSK
HDSKDIR.TXT
README.TXT
```

Do not only copy the `disks` folder itself unless you also changed the firmware to look inside that folder. The simulator expects the disk image files at the SD card root.

Important included MITS disk images:

| Image | Description |
|---|---|
| `DISK01.DSK` | CP/M 63K |
| `DISK02.DSK` | Altair DOS 1.0 |
| `DISK03.DSK` | Altair Disk BASIC |
| `DISK05.DSK` | CP/M games |
| `DISK06.DSK` | SuperCalc II |
| `DISK07.DSK` | WordStar |
| `DISK08.DSK` | Zork |
| `DISK10.DSK` | Dazzler programs, boots CP/M |
| `DISK11.DSK` | VDM-1 programs, boots CP/M |
| `DISK13.DSK` | CP/M 3.0 disk 1, boot |
| `DISK14.DSK` | CP/M 3.0 disk 2, utilities |
| `DISK16.DSK` | CP/M 2.2 MITS + Tarbell |

Important included hard disk images:

| Image | Description |
|---|---|
| `HDSK01.DSK` | Altair hard disk BASIC |
| `HDSK02.DSK` | Altair Accounting System |
| `HDSK03.DSK` | 88-HDSK CP/M |

---

## Loading a disk and starting CP/M: easy menu method

This is the easiest way to boot the included CP/M floppy image.

### 1. Prepare the SD card

Copy the contents of `disks` to the SD card root, then insert the SD card into the simulator SD interface.

Make sure these files are present at minimum:

```text
DISK01.DSK
DISKDIR.TXT
```

### 2. Boot the simulator

Upload/run the REV13 sketch and open your terminal at 115200 8N1.

### 3. Enter the configuration menu

```text
STOP + AUX1
```

### 4. Mount the CP/M disk in MITS drive 0

From the configuration menu:

```text
D
```

This opens the MITS disk drive menu.

Press:

```text
0
```

Each press cycles drive 0 through the available `DISKxx.DSK` images. Stop when drive 0 shows:

```text
DISK01.DSK: CP/M (63k)
```

Then press:

```text
x
```

This returns to the main configuration menu and applies the mounted disk choice.

### 5. Select the Disk Boot ROM as the AUX1 shortcut

On the main configuration menu, use:

```text
u
```

or:

```text
U
```

Cycle the Aux1 shortcut program until it shows:

```text
Disk boot ROM
```

Then save if you want this to remain your normal boot setup:

```text
S
0
y
```

Exit the menu:

```text
x
```

### 6. Start CP/M

Raise the AUX1 shortcut switch to run the Disk Boot ROM. The Disk Boot ROM loads at `0xFF00` and boots the mounted disk.

If the disk boots correctly, you should arrive at a CP/M prompt:

```text
A>
```

Try:

```text
DIR
```

That should list files on the CP/M disk.

---

## Loading a disk and starting CP/M: front panel method

This is closer to the original documented Altair-style process.

### Mount `DISK01.DSK` in drive 0

Set the switches for MITS disk mounting:

```text
SW15..SW0 = 0001 0000 0000 0001
```

Meaning:

```text
0001       MITS disk mount command
0000       drive 0
00000001   disk image 01, so DISK01.DSK
```

Press:

```text
AUX2 down
```

This mounts `DISK01.DSK` in drive 0.

### Start the Disk Boot ROM

Set the low program-select switches to the Disk Boot ROM program number:

```text
00001000
```

Then press:

```text
AUX1 down
```

The simulator installs the Disk Boot ROM at `0xFF00` and starts it. If `DISK01.DSK` is mounted correctly, CP/M should boot and display:

```text
A>
```

At the CP/M prompt, try:

```text
DIR
```

---

## Loading more disks for CP/M

CP/M can use more than one mounted drive if you mount additional disk images.

Example using the menu:

1. Enter the configuration menu with `STOP + AUX1`.
2. Press `D` for MITS disk drives.
3. Press `0` until drive 0 shows `DISK01.DSK` for the boot disk.
4. Press `1` until drive 1 shows another disk, such as `DISK05.DSK` for games.
5. Press `x` to return.
6. Boot CP/M from drive 0.

Inside CP/M:

```text
A>DIR
A>B:
B>DIR
```

The exact CP/M drive letters depend on the mounted controller/drive mapping, but the normal pattern is drive 0 as `A:`, drive 1 as `B:`, and so on.

---

## Booting hard disk CP/M

The included hard disk CP/M image is:

```text
HDSK03.DSK
```

Easy menu method:

1. Copy `HDSK03.DSK` and `HDSKDIR.TXT` to the SD card root.
2. Enter the configuration menu with `STOP + AUX1`.
3. Press `H` to configure hard disks.
4. Mount `HDSK03.DSK` on unit 0, platter 0.
5. Return with `x`.
6. Select or run the Hard Disk Boot ROM.

Front panel boot ROM selection for hard disk boot:

```text
00001110
```

Then press:

```text
AUX1 down
```

The hard disk boot ROM loads at `0xFC00` and boots from unit 0, platter 0.

---

## SD card file manager

When the SD card is detected, the configuration menu shows:

```text
(F)ile manager for SD card
```

Use this for SD card management and file transfer features. The original simulator also supports XMODEM transfer through the file manager.

This can help you inspect whether the expected disk files are actually visible to the simulator.

---

## Save/load behavior in REV13

REV13 keeps the REV10 persistence fixes.

Important points:

- Config `0` is the automatic power-on default.
- Save now verifies by reopening the saved config and checking the current config header.
- Old stale config records from earlier enhanced builds are rejected.
- SD-backed `STORAGE.DAT` is preferred for reliable persistence.
- Arduino Due has no true EEPROM, so SD-backed storage is more reliable than relying on flash fallback.

Recommended persistence setup:

```text
Use a working SD card.
Let the simulator create/use STORAGE.DAT.
Save your desired settings as config #0.
Power cycle and confirm the same settings return.
```

If save/load fails:

1. Confirm the SD card is detected.
2. Confirm `STORAGE.DAT` can be created at the SD card root.
3. Use the SD file manager to inspect files if needed.
4. Delete/recreate a bad `STORAGE.DAT` if it was created by an older broken build.
5. Save config `0` again.

---

## Recommended first setup

For a strong normal REV13 setup:

```text
1. Upload Altair8800.ino to Arduino Due Programming Port.
2. Open terminal at 115200 8N1.
3. Enter menu with STOP + AUX1.
4. Press ! for max performance.
5. Press c only if you want Intel 8080 instead of default Z80.
6. Press D and mount DISK01.DSK in drive 0 if you want CP/M ready.
7. Set Aux1 shortcut to Disk boot ROM if desired.
8. Save as config #0.
9. Exit and boot CP/M.
```

For original Altair-style compatibility:

```text
1. Enter menu with STOP + AUX1.
2. Set CPU to Intel 8080.
3. Choose the safe/original 2 MHz governed profile from A, or set 2 MHz using k/K and Q.
4. Use a conservative serial speed if old software loses characters.
5. Save as config #0.
```

---

## Terminal tips

Use a terminal program that supports:

- 115200 baud, 8N1.
- ANSI escape sequences if you want cleaner screen/control behavior.
- Optional transmit delay when pasting long BASIC or CP/M text.

For old software that loses pasted characters, add a small character delay and line delay in your terminal program. This is especially useful when sending long text listings or commands to emulated serial software.

---

## Troubleshooting

### I do not see the REV13 banner

Make sure you uploaded this package's `Altair8800.ino`, not the original sketch or an older revision.

Expected banner line:

```text
Final REV13 - Stable 8080/Z80 + opcode audit - Created 2026-05-24
```

### My selected clock speed does not seem to apply

Use `k`, `K`, `G`, or `Q` in the configuration menu. REV13 should show:

```text
Throttle : cycle-accurate target
```

Use `!` only when you intentionally want full speed.

### Save says failed

REV13 only reports save success after read-back verification. If save fails, the storage backend did not write correctly.

Best fix:

```text
Use a working SD card and let the simulator create/use STORAGE.DAT.
```

### CP/M does not boot

Check these items:

1. `DISK01.DSK` is copied to the SD card root.
2. The SD card is detected by the simulator.
3. Drive 0 is actually mounted to `DISK01.DSK`.
4. You started the Disk Boot ROM, not BASIC.
5. Try Intel 8080 mode if a program behaves strangely.
6. Try the 2 MHz governed profile if timing-sensitive software acts wrong.

### I mounted the disk but still get no `A>` prompt

Try the menu method first because it confirms the mounted image name on screen.

Expected drive 0 menu line:

```text
Drive (0) mounted disk image : DISK01.DSK: CP/M (63k)
```

Then boot with the Disk Boot ROM.

### CP/M boots but typed/pasted input is unreliable

Use a terminal program with transmit delay, or use a slower serial preset from the `N` serial preset menu.

---

## Revision history summary

### REV4

- Added a cleaner startup banner.
- Added easier emulated CPU clock target controls.
- Added full-speed/turbo support.
- Added quick boot profiles.
- Added serial presets.
- Added benchmark/timing reporting.
- Added Arduino Due compile compatibility shims.

### REV5

- Added cycle-count based clock governor.
- Kept max-performance defaults.
- Switched default serial behavior toward 115200 baud.
- Added `Q` accurate clock mode.

### REV6

- Set requested default profile:
  - 20 MHz target.
  - 64 KB RAM.
  - 115200 baud.
  - USB Programming Port / Micro USB primary.
  - Full-speed throttle off.

### REV10

- Fixed save/load settings behavior.
- Bumped config record version to 15.
- Rejected stale older configs.
- Added read-back verification after saving.
- Fixed short `STORAGE.DAT` problems.
- Fixed SD random-write behavior so writes land at the requested offset instead of appending.
- Fixed clock target changes so they actually enable governed speed.

### REV11

- Enabled switchable CPU support with:

```cpp
#define USE_Z80 2
```

- Added menu CPU selection:

```text
Pro(c)essor : Intel 8080 / Zilog Z80
```

- Startup banner reports selected CPU.
- Reset defaults prefer Z80 while keeping Intel 8080 selectable.

### REV12

- Audited CPU opcode dispatch paths.
- Confirmed 256/256 root opcode table coverage for Intel 8080 and Z80.
- Fixed DDCB/FDCB indexed BIT behavior.
- Added ED 70 and ED 71 real-Z80 undocumented I/O behavior.
- Corrected undefined ED-prefix behavior.
- Improved ignored DD/FD prefix timing.
- Cleaned Z80 disassembler formatting and certain opcode names.

### Final REV13

- Cleaned final package naming.
- Fixed stale banner text so the live startup banner reports Final REV13.
- Preserved REV10, REV11, and REV12 fixes.
- Included build, static audit, startup smoke test, and verification notes.

---

## License

This project is based on David Hansel's Altair 8800 Simulator and remains under the GNU General Public License included in this repository.

Keep the original license file with the source tree.

---

## Credits

Original Altair 8800 Simulator:

```text
David Hansel
https://github.com/dhansel/Altair8800
```

Original disk and hard disk images are credited in `disks/README.TXT`, including work by Mike Douglas and Udo Munk. Keep those notes with the disk images.

This enhanced REV13 package is a modified Arduino Due-focused build intended to make the simulator easier to configure, faster by default, more reliable for saved settings, and more useful for Z80/CP/M experiments while retaining original Intel 8080 compatibility.
