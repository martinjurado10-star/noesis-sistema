# ============================================================
#  NOESIS - Instalador del sistema
#
#  Todo programa que entra a esta maquina se declara ACA primero.
#  Correr este script instala lo que falte y no toca lo que ya esta.
#
#      powershell -ExecutionPolicy Bypass -File instalar.ps1
#      powershell -ExecutionPolicy Bypass -File instalar.ps1 -Simular
#
#  El diseño y el por que de cada decision estan en SISTEMA.md
# ============================================================
param([switch]$Simular)

$ErrorActionPreference = "Stop"

# ------------------------------------------------------------
#  EL STACK. Una funcion, una herramienta.
#  Antes de agregar una linea aca: leer la regla en SISTEMA.md
# ------------------------------------------------------------
$STACK = @(
    @{ Funcion = "Navegador";            Id = "Google.Chrome";        Detectar = "chrome" }
    @{ Funcion = "Nube de archivos";     Id = "Google.GoogleDrive";   Detectar = "Google Drive" }
    @{ Funcion = "Control de versiones"; Id = "Git.Git";              Detectar = "git" }
    @{ Funcion = "Lenguaje principal";   Id = "Python.Python.3.12";   Detectar = "python" }
    @{ Funcion = "Lenguaje web";         Id = "OpenJS.NodeJS";        Detectar = "node" }
    @{ Funcion = "Editor de codigo";     Id = "ZedIndustries.Zed";    Detectar = "Zed" }
    @{ Funcion = "OCR";                  Id = "UB-Mannheim.TesseractOCR"; Detectar = "tesseract" }
    @{ Funcion = "Videollamadas";        Id = "Zoom.Zoom";            Detectar = "Zoom" }
)

# ------------------------------------------------------------
#  PROHIBIDOS. Si aparecen, el inventario avisa.
# ------------------------------------------------------------
$PROHIBIDOS = @(
    @{ Nombre = "Microsoft 365";   Motivo = "capa de documentos: la cubre Google Docs" }
    @{ Nombre = "OneDrive";        Motivo = "capa de documentos: la cubre Google Drive" }
    @{ Nombre = "Copilot";         Motivo = "duplica a Claude" }
    @{ Nombre = "Adobe";           Motivo = "app suelta por tarea" }
    @{ Nombre = "Python 3.14";     Motivo = "segundo interprete: ya esta 3.12" }
    @{ Nombre = "Subsystem for Linux"; Motivo = "segundo sistema" }
)

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
Write-Host "=== Stack declarado en SISTEMA.md ===" -ForegroundColor Cyan
Write-Host ""

$faltan = @()
foreach ($h in $STACK) {
    if (Esta-Instalado $h.Detectar) {
        Write-Host ("  ok      {0,-22} {1}" -f $h.Funcion, $h.Id) -ForegroundColor DarkGray
    } else {
        Write-Host ("  FALTA   {0,-22} {1}" -f $h.Funcion, $h.Id) -ForegroundColor Yellow
        $faltan += $h
    }
}

if ($faltan.Count -eq 0) {
    Write-Host ""
    Write-Host "  El stack esta completo. No hay nada que instalar." -ForegroundColor Green
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
    Write-Host ("  instalando {0} ..." -f $h.Id) -ForegroundColor White
    winget install --id $h.Id --accept-package-agreements --accept-source-agreements --disable-interactivity 2>&1 |
        Select-Object -Last 1
}

Write-Host ""
Write-Host "  Listo. Si algo no aparece todavia, abri una ventana nueva." -ForegroundColor Green
Write-Host ""
