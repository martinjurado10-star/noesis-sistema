# ============================================================
#  NOESIS - Inventario: la maquina contra el diseño
#
#  Muestra que falta del stack y que hay instalado que no deberia.
#  No instala ni desinstala nada: solo mira y avisa.
#
#      powershell -ExecutionPolicy Bypass -File inventario.ps1
# ============================================================
$ErrorActionPreference = "Stop"

$instalados = @()
$claves = @('HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*',
            'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*',
            'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*')
$instalados = Get-ItemProperty $claves -ErrorAction SilentlyContinue |
              Where-Object { $_.DisplayName } |
              Select-Object -ExpandProperty DisplayName -Unique

$ESPERADO = @('Chrome','Google Drive','Git','Python 3.12','Node','Zed','Tesseract','Zoom')
$PROHIBIDO = @(
    @{ Nombre = 'Microsoft 365';       Motivo = 'capa de documentos: la cubre Google Docs' }
    @{ Nombre = 'OneDrive';            Motivo = 'capa de documentos: la cubre Google Drive' }
    @{ Nombre = 'Copilot';             Motivo = 'duplica a Claude' }
    @{ Nombre = 'Adobe';               Motivo = 'app suelta por tarea' }
    @{ Nombre = 'Python 3.13';         Motivo = 'segundo interprete' }
    @{ Nombre = 'Python 3.14';         Motivo = 'segundo interprete' }
    @{ Nombre = 'Subsystem for Linux'; Motivo = 'segundo sistema' }
)

Write-Host ""
Write-Host "=== Lo que tiene que estar ===" -ForegroundColor Cyan
foreach ($e in $ESPERADO) {
    $hay = $instalados | Where-Object { $_ -like "*$e*" } | Select-Object -First 1
    if ($hay) { Write-Host ("  ok      {0}" -f $hay) -ForegroundColor DarkGray }
    else      { Write-Host ("  FALTA   {0}" -f $e) -ForegroundColor Yellow }
}

Write-Host ""
Write-Host "=== Lo que no tiene que estar ===" -ForegroundColor Cyan
$sucio = $false
foreach ($p in $PROHIBIDO) {
    $hay = $instalados | Where-Object { $_ -like ('*' + $p.Nombre + '*') }
    foreach ($h in $hay) {
        Write-Host ("  SOBRA   {0}" -f $h) -ForegroundColor Red
        Write-Host ("          {0}" -f $p.Motivo) -ForegroundColor DarkGray
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
Write-Host "=== Interpretes de Python ===" -ForegroundColor Cyan
py --list 2>&1 | ForEach-Object { "  $_" }

Write-Host ""
Write-Host "  El diseño y el por que de cada linea: SISTEMA.md" -ForegroundColor DarkGray
Write-Host ""
