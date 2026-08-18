# ============================================================
#  NOESIS - Inventario: la maquina contra el diseño
#
#  Muestra que falta y que sobra. No instala ni desinstala nada.
#  No tiene lista propia: lee stack.json, que es la unica fuente.
#
#      powershell -ExecutionPolicy Bypass -File inventario.ps1
# ============================================================
$ErrorActionPreference = "Stop"

$cfg = Get-Content (Join-Path $PSScriptRoot 'stack.json') -Raw -Encoding UTF8 | ConvertFrom-Json

$claves = @('HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*',
            'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*',
            'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*')
$instalados = Get-ItemProperty $claves -ErrorAction SilentlyContinue |
              Where-Object { $_.DisplayName } |
              Select-Object -ExpandProperty DisplayName -Unique

# El registro deja entradas muertas: cuando hay forma de mirar el
# programa real (una ruta, las apps, las distros), se mira eso.
function Esta-De-Verdad($item) {
    if ($item.ruta) { return Test-Path ([Environment]::ExpandEnvironmentVariables($item.ruta)) }
    switch ($item.comprobar) {
        'appx' { return [bool](Get-AppxPackage -Name "*$($item.detectar)*" -ErrorAction SilentlyContinue) }
        'wsl'  { return [bool]((wsl.exe --list --quiet 2>$null) -replace "`0","").Trim() }
    }
    $clave = if ($item.detectar) { $item.detectar } else { $item.nombre }
    return [bool]($instalados | Where-Object { $_ -like "*$clave*" })
}

Write-Host ""
Write-Host "=== Programas ===" -ForegroundColor Cyan
foreach ($e in $cfg.programas) {
    $hay = $instalados | Where-Object { $_ -like "*$($e.detectar)*" } | Select-Object -First 1
    if ($hay) { Write-Host ("  ok      {0,-22} {1}" -f $e.funcion, $hay) -ForegroundColor DarkGray }
    else      { Write-Host ("  FALTA   {0,-22} {1}" -f $e.funcion, $e.nombre) -ForegroundColor Yellow }
}

Write-Host ""
Write-Host "=== Piezas propias (no salen de ningun instalador) ===" -ForegroundColor Cyan
foreach ($p in $cfg.local) {
    if (Test-Path ([Environment]::ExpandEnvironmentVariables($p.ruta))) {
        Write-Host ("  ok      {0,-22} {1}" -f $p.funcion, $p.nombre) -ForegroundColor DarkGray
    } else {
        Write-Host ("  FALTA   {0,-22} {1}" -f $p.funcion, $p.nombre) -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "=== Servicios (viven en la nube, no se verifican) ===" -ForegroundColor Cyan
foreach ($s in $cfg.servicios) {
    Write-Host ("          {0,-22} {1}" -f $s.funcion, $s.nombre) -ForegroundColor DarkGray
}

Write-Host ""
Write-Host "=== Lo que no tiene que estar ===" -ForegroundColor Cyan
$sucio = $false
foreach ($p in $cfg.prohibidos) {
    if (Esta-De-Verdad $p) {
        Write-Host ("  SOBRA   {0}" -f $p.nombre) -ForegroundColor Red
        Write-Host ("          {0}" -f $p.motivo) -ForegroundColor DarkGray
        $sucio = $true
    }
}
if (-not $sucio) { Write-Host "  limpio" -ForegroundColor Green }

Write-Host ""
Write-Host "=== Hardware (define que se puede correr) ===" -ForegroundColor Cyan
$gpu = Get-CimInstance Win32_VideoController | Select-Object -First 1
Write-Host ("  video : {0}" -f $gpu.Name)
Write-Host ("  cpu   : {0}" -f (Get-CimInstance Win32_Processor).Name)
Write-Host ("  ram   : {0} GB" -f [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory/1GB,0))
if ($gpu.Name -match 'UHD|Intel.*Graphics') {
    Write-Host "  sin placa dedicada: nada que pida GPU (ver SISTEMA.md)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "  Una sola fuente: stack.json. El por que: SISTEMA.md" -ForegroundColor DarkGray
Write-Host ""
