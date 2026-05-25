# Altair8800 Due Z80 REV14 TURBO

GitHub-ready REV14 package for the Arduino Due Altair 8800 simulator build.

REV14 keeps the improved switchable **Intel 8080 / Zilog Z80** work from the previous revisions, then adds a new high-speed front-panel optimization. The goal is to make the Arduino Due spend more time executing emulated CPU instructions and less time constantly repainting the physical LED/address/data/status bus on every single memory cycle.

## What is new in REV14

- **Much faster raw RUN mode** for CPU-heavy programs.
- **Front-panel LEDs still work while running.** They are sampled/updated during fast RUN instead of being forced on every emulated bus cycle.
- **Z80 mode retained** from REV11/REV12/REV13 work.
- **Opcode audit work retained** from REV12/REV13.
- **Save/load and clock-governor fixes retained** from REV10/REV13.
- **`!` Max Perf mode is now the preferred fast mode** for benchmarks and CP/M math programs.
- STOP, RESET, STEP, EXAMINE, DEPOSIT, WAIT, and governed/accurate clock behavior remain normal.

## Why REV14 is faster

Older builds updated the physical front-panel bus LEDs very aggressively during RUN. That is useful for visual bus watching, but on the Arduino Due it costs real CPU time. A real Z80 executes its own instructions directly in hardware; the Arduino Due has to emulate every Z80 instruction in software, so every avoidable GPIO update matters.

REV14 adds an optimized fast front-panel mode:

- raw full-speed RUN skips most per-cycle GPIO bus repainting;
- memory reads/writes, opcode fetches, stack push/pop, and 16-bit memory helper paths are optimized;
- the panel still receives periodic activity updates so the LEDs remain alive while the machine runs;
- accurate/governed clock modes keep the more traditional visible bus-cycle behavior.

## Best speed settings

For the fastest benchmark/test mode:

```text
CPU mode       : Z80
Throttle       : off / full speed
Profiling      : off
Serial panel   : off
Serial debug   : off
Max perf       : enabled with !
```

The menu may show a high target such as 20 MHz, but this is still software emulation on an 84 MHz Arduino Due. REV14 does not turn the Due into a real 20 MHz Z80; it reduces overhead so practical raw emulation speed is much better than before.

## Easy BIN upload

Use the folder:

```text
Easy_BIN_Upload/
```

It contains:

```text
altair8800_REV14.bin
upload_REV14.bat
upload_REV14.ps1
README_EASY_UPLOAD.txt
```

Add `bossac.exe` to that folder, then run:

```bat
upload_REV14.bat COM7
```

Replace `COM7` with your Arduino Due programming-port COM number.

## Source folder

The Arduino sketch/source is in:

```text
Altair8800_max/
```

The main sketch file is:

```text
Altair8800_max/Altair8800_max.ino
```

That name is left unchanged so the known-working Arduino sketch layout remains intact.

## REV14 technical notes

The main REV14 switch is in `config.h`:

```cpp
#define USE_FAST_RUN_FRONT_PANEL 1
#define FAST_RUN_PANEL_SAMPLE_MASK 0x0FFF
```

Rollback option:

```cpp
#define USE_FAST_RUN_FRONT_PANEL 0
```

That disables the REV14 fast-panel optimization if you ever want to compare old-style bus LED behavior against the new turbo behavior.

## Included notes

- `RELEASE_NOTES_REV14.md`
- `CHANGELOG.md`
- `REV14_TURBO_SPEED_NOTES.txt`
- `REV13_to_REV14_TURBO.patch`
- `QUICK_FLASH_WINDOWS.md`
- `Easy_BIN_Upload/README_EASY_UPLOAD.txt`

## License

Original project license is preserved in `LICENSE` and in the source folder.
