param(
    [string]$Port = "",
    [string]$Bin = "",
    [string]$Bossac = ""
)

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

function Write-Header($Text) {
    Write-Host ""
    Write-Host "==== $Text ====" -ForegroundColor Cyan
}

function Resolve-LocalPath {
    param([string]$PathText)
    if (-not $PathText) { return "" }
    if ([System.IO.Path]::IsPathRooted($PathText)) { return $PathText }
    return (Join-Path $ScriptDir $PathText)
}

function Find-BinFile {
    param([string]$Requested)

    $requestedPath = Resolve-LocalPath $Requested
    if ($requestedPath -and (Test-Path $requestedPath)) {
        return (Resolve-Path $requestedPath).Path
    }

    $preferred = Join-Path $ScriptDir "altair8800_REV13.bin"
    if (Test-Path $preferred) {
        return (Resolve-Path $preferred).Path
    }

    $bins = Get-ChildItem -Path $ScriptDir -Filter "*.bin" -File -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending
    if ($bins.Count -eq 1) {
        return $bins[0].FullName
    }

    if ($bins.Count -gt 1) {
        Write-Host "Multiple .bin files found:" -ForegroundColor Yellow
        for ($i = 0; $i -lt $bins.Count; $i++) {
            Write-Host ("[{0}] {1}" -f ($i + 1), $bins[$i].Name)
        }
        $choice = Read-Host "Choose binary number"
        $idx = [int]$choice - 1
        if ($idx -ge 0 -and $idx -lt $bins.Count) {
            return $bins[$idx].FullName
        }
    }

    throw "No .bin firmware file found. Put altair8800_REV13.bin in this folder."
}

function Find-Bossac {
    param([string]$Requested)

    $candidates = @()

    $requestedPath = Resolve-LocalPath $Requested
    if ($requestedPath) { $candidates += $requestedPath }

    $candidates += (Join-Path $ScriptDir "bossac.exe")

    if ($env:LOCALAPPDATA) {
        $arduino15 = Join-Path $env:LOCALAPPDATA "Arduino15\packages\arduino\tools\bossac"
        if (Test-Path $arduino15) {
            $found = Get-ChildItem -Path $arduino15 -Filter "bossac.exe" -File -Recurse -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending
            foreach ($f in $found) { $candidates += $f.FullName }
        }
    }

    $candidates += "C:\Program Files (x86)\Arduino\hardware\tools\bossac.exe"
    $candidates += "C:\Program Files\Arduino\hardware\tools\bossac.exe"

    foreach ($c in $candidates) {
        if ($c -and (Test-Path $c)) {
            return (Resolve-Path $c).Path
        }
    }

    throw "bossac.exe was not found. Install Arduino IDE + Arduino SAM Boards, or copy bossac.exe into this folder beside upload.bat."
}

function Show-SerialPorts {
    Write-Host "Detected COM ports:"
    $ports = [System.IO.Ports.SerialPort]::GetPortNames() | Sort-Object
    if ($ports.Count -eq 0) {
        Write-Host "  No COM ports detected." -ForegroundColor Yellow
    } else {
        foreach ($p in $ports) {
            $name = ""
            try {
                $dev = Get-CimInstance Win32_PnPEntity | Where-Object { $_.Name -match "\($p\)" } | Select-Object -First 1
                if ($dev) { $name = " - " + $dev.Name }
            } catch { }
            Write-Host "  $p$name"
        }
    }
}

function Reset-DueBootloader {
    param([string]$ComPort)

    Write-Host "Trying a light 1200-baud reset/touch on $ComPort..."
    try {
        $sp = New-Object System.IO.Ports.SerialPort $ComPort, 1200, "None", 8, "One"
        $sp.DtrEnable = $false
        $sp.RtsEnable = $false
        $sp.Open()
        Start-Sleep -Milliseconds 250
        $sp.Close()
        Start-Sleep -Seconds 1
    } catch {
        Write-Host "Reset/touch skipped or failed. This is often OK on the Due Programming Port." -ForegroundColor Yellow
    }
}

Write-Header "Altair8800 Due Z80 Final REV13 Installer"

$binPath = Find-BinFile $Bin
Write-Host "Firmware binary: $binPath"

$bossacPath = Find-Bossac $Bossac
Write-Host "bossac.exe     : $bossacPath"

if (-not $Port) {
    Write-Header "COM Port Selection"
    Show-SerialPorts
    $Port = Read-Host "Enter Arduino Due Programming Port COM number/name, example COM7"
}

if (-not $Port) {
    throw "No COM port selected."
}

$Port = $Port.Trim().ToUpper()
if ($Port -notmatch '^COM\d+$') {
    throw "COM port must look like COM7, COM8, etc. You entered: $Port"
}

Reset-DueBootloader $Port

Write-Header "Flashing Firmware"
$args = @("--port=$Port", "-U", "false", "-e", "-w", "-v", "-b", $binPath, "-R")
Write-Host "Running: `"$bossacPath`" $($args -join ' ')"

& $bossacPath @args
$exit = $LASTEXITCODE

if ($exit -ne 0) {
    throw "bossac failed with exit code $exit. Check COM port, USB cable, Arduino Due Programming Port, and reset button."
}

Write-Header "Done"
Write-Host "Firmware flashed successfully." -ForegroundColor Green
Write-Host "Next: insert the SD card with disk images, open serial at 115200 baud, configure disks, then boot CP/M."
