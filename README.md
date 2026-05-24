# Altair 8800 Simulator - Enhanced Arduino Due Build REV11

**Revision:** REV11 - Switchable Z80 CPU + REV10 Save/Load and Accurate Clock Fixes  
**Created:** 2026-05-23  
**Target board:** Arduino Due / SAM3X8E  
**Default console:** USB Programming Port / Micro USB  
**Default baud:** 115200 8N1  
**Default RAM:** 64 KB  
**Default CPU target:** 20 MHz  
**Default throttle:** off / full speed

This is an enhanced Arduino Due build of the Altair 8800 simulator. REV11 keeps the REV10 save/load and CPU clock governor fixes and enables the switchable Intel 8080 / Zilog Z80 CPU build. REV10 was focused on fixing the power-loss configuration problem seen after REV8, where the menu could return to an old saved 250 kHz / cycle-accurate configuration after a full power cycle.

REV10 does three important things:

1. It keeps the compiled defaults maxed out: 20 MHz target, 64 KB RAM, 115200 baud, Micro USB console, throttle off / full speed.
2. It rejects older saved configuration records from earlier enhanced revisions, so an old slow config #0 cannot keep coming back after power loss.
3. It now verifies a saved config by reopening it and checking the REV10 header before saying it saved successfully.

After installing REV10, the board should no longer boot back to the old 250 kHz configuration unless you explicitly save a new REV10 config with those settings.

---

## Open in Arduino IDE

Open this file:

```text
Altair8800_REV10_SaveLoad_Settings_Fix\Altair8800.ino
```

Board selection:

```text
Tools -> Board -> Arduino Due (Programming Port)
```

Serial monitor / terminal:

```text
115200 baud
8 data bits
no parity
1 stop bit
```

---

## REV10 default settings

| Setting | REV10 compiled default |
|---|---:|
| CPU clock target | 20 MHz |
| RAM | 64 KB |
| Host baud | 115200 8N1 |
| Host console | USB Programming Port / Micro USB |
| Throttle | off / full speed |
| Profiling | off |
| Serial panel | off |
| Serial input | off |
| Serial debug | off |

These are compile-time defaults. REV10 also supports persistent config #0, but old config records from REV9 and older are ignored on purpose.

---

## Why REV10 was needed

The board was showing this after power loss:

```text
CPU clock target : 250 kHz
Set throttle mode: cycle-accurate target
```

That means the firmware was loading an older saved config #0 instead of using the newer max defaults. Because the Due has no true EEPROM, persistent storage can be complicated:

- If an SD card with `STORAGE.DAT` is available, the project stores settings there.
- If not, it tries to use the Arduino Due internal flash fallback.
- Older enhanced packages could leave an old slow config record behind.

REV10 bumps the config record version and refuses to load older records. This makes the firmware fall back to the compiled REV10 max defaults instead of continuing to load the old slow settings.

---

## First boot after uploading REV10

After upload, enter the config menu:

```text
STOP + AUX1
```

You should see something close to:

```text
CPU clock target (k/K,G)    : 20.000 MHz
Set throttle mode (t/T)     : off / full speed
Configure memory            : 64 KB RAM
Configure host serial       : Primary: USB Programming Port
```

If you see 20 MHz and full speed, REV10 is doing what it should.

---

## Save your current settings as the power-on default

Use config #0. Config #0 is the power-on default.

```text
STOP + AUX1
!      apply max performance profile
S      save configuration
0      save as config #0
y      overwrite if asked
x      exit
```

Important: REV10 will ignore old configs from REV9 and below. A newly saved REV10 config #0 should load normally if the selected storage backend is actually writing correctly.

---

## If it still will not save custom settings

If REV10 always boots max defaults but does not remember custom changes after power loss, then the Arduino Due internal flash fallback is not writing reliably in your exact board/core setup.

Best reliable fix:

1. Use a working SD card on the Altair simulator SD interface.
2. Let the firmware create/use `STORAGE.DAT` on the SD card.
3. Save your settings as config #0.

With no SD card and no external EEPROM/FRAM, the Arduino Due has to use internal flash emulation. That is more fragile than a real EEPROM device. REV10 prevents the old bad/slow config from returning, but a true reliable save still requires a working nonvolatile backend.

---

## Speed controls

| Key | Action |
|---|---|
| `k` | Next faster preset |
| `K` | Next slower preset |
| `G` | Enter a custom CPU target clock |
| `t/T` | Change throttle mode |
| `Q` | Accurate cycle-governed target mode |
| `!` | Max-performance profile |
| `A` | Profile menu |
| `N` | Serial preset menu |
| `B` | Benchmark/timing report |

---

## Fast mode vs accurate mode

### Full speed mode

```text
Throttle: off / full speed
```

This lets the Arduino Due run the emulator as fast as it can.

### Accurate clock mode

```text
Q = cycle-accurate target
```

This uses the emulator's cycle counter and the Arduino `micros()` timer to hold the selected target as closely as possible. Use this when you want a realistic Altair-style clock.

---

## Safe realistic Altair profile

The safe profile keeps old software closer to the real machine:

```text
CPU target : 2 MHz
RAM        : 64 KB
Clocking   : cycle-governed
Baud       : 9600 8N1
Console    : Micro USB
```

Use this if old BASIC, CP/M, serial, or disk activity is timing-sensitive.

---

## REV10 source-level changes

REV10 changes include:

- Updated revision banner to REV10 with the 2026-05-23 creation date.
- Bumped configuration file version to 15.
- Added strict rejection of old config records below version 15.
- Prevents old 250 kHz / cycle-accurate records from REV9 and earlier from loading at power-on.
- Keeps max-performance compiled defaults: 20 MHz, 64 KB RAM, 115200, Micro USB, throttle off.
- Keeps accurate cycle governor from REV5/REV6/REV8.
- Adds save read-back verification so the menu does not falsely claim success when a config cannot be reopened.
- Pre-allocates/extends SD `STORAGE.DAT` to the expected storage size before using it.
- Keeps local SD compatibility wrapper and the safe `rename()` copy/delete fallback.
- Keeps local Due flash compatibility fallback, but documents that SD `STORAGE.DAT` is the preferred reliable persistence method.

---

## Known limitation

The Arduino Due does not have real EEPROM. If there is no SD-backed `STORAGE.DAT`, the firmware must emulate saved settings using internal flash. Internal flash save behavior can depend on sketch size, flash layout, Arduino SAM core behavior, and board/bootloader details. REV10 avoids loading the old broken slow config and makes the default behavior correct even if the flash fallback is unreliable.

---

## License and original project

This project is based on the Altair 8800 Simulator originally by David Hansel and is distributed under the GPL license included in this repository. REV10 adds Arduino Due usability, clocking, default-profile, and configuration-persistence improvements.


## REV10 Hotfix - Save/Load Settings SD Random Write Fix

This REV10 package includes a hotfix for Arduino Due builds using the included local `SdFat.h` compatibility shim.  The stock Arduino SD `FILE_WRITE` mode can behave like append mode, but `STORAGE.DAT` must be used as a random-access persistent block device.  Writable SD files are now opened without append mode using `O_READ | O_WRITE | O_CREAT`, so config SAVE writes land at the exact mini-filesystem offsets and immediate LOAD/verification can work correctly.

After uploading, test from the config menu with `S`, config `0`, overwrite `y`, then `L`, config `0`.  If a bad `STORAGE.DAT` was produced by the earlier REV10 attempt, delete/rename `STORAGE.DAT` from the SD card, reboot, and save config `0` again.


## REV10 Hotfix - CPU Clock Target Governor Fix

This package also fixes the clock-selection behavior. In the earlier REV10 hotfix, `k`, `K`, and `G` changed and saved the displayed CPU clock target, but the emulator could still run at raw/full Arduino Due speed if throttle mode was OFF. Now selecting a CPU clock target automatically enables the cycle-count governor, so RUN obeys the selected target speed.

Use `!` for intentional max-performance/full-speed mode. Use `Q` or any `k`/`K`/`G` clock selection for governed target-speed mode. Save config `0` afterward if you want that speed to be the power-on default.


## REV11 Z80 CPU upgrade

REV11 changes `config.h` to:

```cpp
#define USE_Z80 2
```

That compiles both CPU cores and enables the configuration-menu processor selector:

```text
Pro(c)essor : Intel 8080 / Zilog Z80
```

Use `c` in the configuration menu to toggle between Intel 8080 and Zilog Z80.
Save as config `0` to make the selected CPU the power-on default.

The compiled reset-default profile now prefers Z80 when Z80 support is compiled in.
However, if the board already has a saved REV10 config #0, that saved config may
still select Intel 8080 until you toggle to Z80 and save config #0 again.

Intel 8080 mode is intentionally preserved because some original Altair software
is safest in true 8080 mode. Z80 mode is the better choice for Z80-aware CP/M
software and Z80-specific instructions.

REV11 also tightens the Z80 refresh/R-register handling so the Z80-only refresh
register is advanced only while the selected emulated CPU is actually Z80.
