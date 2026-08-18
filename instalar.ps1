# ============================================================
#  NOESIS - Instalador del sistema
#
#  Todo programa que entra a esta maquina se declara en stack.json
#  y se instala desde aca. Este script NO tiene su propia lista:
#  hay una sola fuente de verdad y es stack.json.
#
#      powershell -ExecutionPolicy Bypass -File instalar.ps1
#      powershell -ExecutionPolicy Bypass -File instalar.ps1 -Simular
#
#  El por que de cada decision esta en SISTEMA.md
# ============================================================
param([switch]$Simular)

$ErrorActionPreference = "Stop"

$cfg = Get-Content (Join-Path $PSScriptRoot 'stack.json') -Raw -Encoding UTF8 | ConvertFrom-Json

function Esta-Instalado($nombre) {
    if (Get-Command $nombre -ErrorAction SilentlyContinue) { return $true }
    $claves = @('HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*',
                'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*',
                'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*')
    $r = Get-ItemProperty $claves -ErrorAction SilentlyContinue |
         Where-Object { $_.DisplayName -like "*$nombre*" }
    return [bool]$r
}

Write-Host ""
Write-Host "=== Programas declarados en stack.json ===" -ForegroundColor Cyan
Write-Host ""

$faltan = @()
foreach ($h in $cfg.programas) {
    if (Esta-Instalado $h.detectar) {
        Write-Host ("  ok      {0,-22} {1}" -f $h.funcion, $h.nombre) -ForegroundColor DarkGray
    } else {
        Write-Host ("  FALTA   {0,-22} {1}" -f $h.funcion, $h.nombre) -ForegroundColor Yellow
        $faltan += $h
    }
}

# Las piezas propias no se instalan con un comando: si faltan, se avisa.
$rotas = @()
foreach ($p in $cfg.local) {
    if (-not (Test-Path ([Environment]::ExpandEnvironmentVariables($p.ruta)))) { $rotas += $p }
}
if ($rotas) {
    Write-Host ""
    Write-Host "  PIEZAS PROPIAS QUE FALTAN (no salen de ningun instalador):" -ForegroundColor Red
    foreach ($p in $rotas) {
        Write-Host ("     {0} -> {1}" -f $p.nombre, $p.ruta) -ForegroundColor Red
        if ($p.nota) { Write-Host ("        {0}" -f $p.nota) -ForegroundColor DarkGray }
    }
}

if ($faltan.Count -eq 0) {
    Write-Host ""
    Write-Host "  Los programas estan completos." -ForegroundColor Green
    Write-Host ""
    exit 0
}

Write-Host ""
if ($Simular) {
    Write-Host "  (simulacion: no se instala nada)" -ForegroundColor DarkGray
    Write-Host ""
    exit 0
}

foreach ($h in $faltan) {
    Write-Host ("  instalando {0} ..." -f $h.nombre) -ForegroundColor White
    winget install --id $h.winget --accept-package-agreements --accept-source-agreements --disable-interactivity 2>&1 |
        Select-Object -Last 1
}

Write-Host ""
Write-Host "  Listo. Si algo no aparece todavia, abri una ventana nueva." -ForegroundColor Green
Write-Host ""
