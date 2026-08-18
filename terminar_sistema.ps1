# ============================================================
#  NOESIS - Terminar el sistema (REQUIERE ADMINISTRADOR)
#
#  Saca todo lo que quedo y que Windows no deja desinstalar
#  sin permisos de administrador.
#
#  COMO CORRERLO
#      Desde PowerShell normal, una sola linea:
#
#      Start-Process powershell -Verb RunAs -ArgumentList '-ExecutionPolicy','Bypass','-File','C:\Noesis\00_sistema\terminar_sistema.ps1'
#
#      Windows va a pedir confirmacion. Aceptar y esperar.
#      Office solo puede tardar 10 minutos. No cerrar la ventana.
#
#  QUE SACA           POR QUE (ver SISTEMA.md)
#      Microsoft 365      capa de documentos: la cubre Google Docs
#      OneDrive           capa de documentos: la cubre Google Drive (ya esta vacio)
#      Adobe Creative Cloud   app suelta por tarea
#      Notion             duplica notas y documentos con Google
#      TeamViewer         sin uso; ademas es acceso remoto abierto
#
#  QUE NO TOCA
#      Chrome, Google Drive, Git, GitHub Desktop, Python 3.12, Node,
#      Zed, Tesseract, Zoom, Canva, Claude. Y nada de tus archivos.
# ============================================================

$ErrorActionPreference = "Continue"

# --- Verificar que corre elevado ---
$id = [Security.Principal.WindowsIdentity]::GetCurrent()
$pr = New-Object Security.Principal.WindowsPrincipal($id)
if (-not $pr.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host ""
    Write-Host "  Esta ventana NO es de administrador." -ForegroundColor Red
    Write-Host "  Cerra esta y pega esto en PowerShell:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  Start-Process powershell -Verb RunAs -ArgumentList '-ExecutionPolicy','Bypass','-File','C:\Noesis\00_sistema\terminar_sistema.ps1'"
    Write-Host ""
    Read-Host "  (enter para cerrar)"
    exit 1
}

Write-Host ""
Write-Host "=== Terminando el sistema ===" -ForegroundColor Cyan
Write-Host "    No se toca ningun archivo tuyo. Solo programas." -ForegroundColor DarkGray
Write-Host ""

$resultado = @()

function Paso($nombre, $accion) {
    Write-Host ("  {0} ..." -f $nombre) -ForegroundColor White -NoNewline
    try {
        & $accion
        Write-Host "  hecho" -ForegroundColor Green
        $script:resultado += @{ Que = $nombre; Como = "hecho" }
    } catch {
        Write-Host "  fallo" -ForegroundColor Red
        Write-Host ("     {0}" -f $_.Exception.Message) -ForegroundColor DarkGray
        $script:resultado += @{ Que = $nombre; Como = "fallo: " + $_.Exception.Message }
    }
}

# ---------- 1. Microsoft 365 ----------
Paso "Microsoft 365 (Word, Excel)" {
    $c2r = 'C:\Program Files\Common Files\Microsoft Shared\ClickToRun\OfficeClickToRun.exe'
    if (Test-Path $c2r) {
        $a = @('scenario=install','scenariosubtype=ARP','sourcetype=None',
               'productstoremove=O365HomePremRetail.16_es-es_x-none',
               'culture=es-es','version.16=16.0','DisplayLevel=False')
        Start-Process -FilePath $c2r -ArgumentList $a -Wait
    }
}

# ---------- 2. OneDrive ----------
Paso "OneDrive" {
    Get-Process OneDrive -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
    foreach ($od in @("$env:SystemRoot\SysWOW64\OneDriveSetup.exe", "$env:SystemRoot\System32\OneDriveSetup.exe")) {
        if (Test-Path $od) { Start-Process -FilePath $od -ArgumentList '/uninstall' -Wait }
    }
}

# ---------- 3. Adobe Creative Cloud ----------
# Adobe se resucita solo: una tarea programada relanza CCXProcess y hay
# un servicio de actualizacion. Hay que desarmar eso ANTES de desinstalar,
# o el desinstalador nunca lo agarra quieto.
# Y su desinstalador no tiene modo silencioso: abre SU PROPIA VENTANA
# y hay que apretar "Desinstalar" ahi.
Paso "Adobe Creative Cloud (abre su ventana: apreta Desinstalar)" {
    # 1) que no se relance
    Get-ScheduledTask | Where-Object { $_.TaskName -match 'Adobe|Creative|SoftLanding' } |
        Disable-ScheduledTask -ErrorAction SilentlyContinue | Out-Null
    Get-Service -Name 'AdobeUpdateService','AGSService','AGMService' -ErrorAction SilentlyContinue |
        ForEach-Object {
            Stop-Service $_.Name -Force -ErrorAction SilentlyContinue
            Set-Service  $_.Name -StartupType Disabled -ErrorAction SilentlyContinue
        }
    # 2) recien ahora, cerrarlo
    Get-Process | Where-Object { $_.ProcessName -match 'Adobe|Creative|CoreSync|CCX|CCLibrary' } |
        Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 4
    # 3) y desinstalarlo
    $u = 'C:\Program Files (x86)\Adobe\Adobe Creative Cloud\Utils\Creative Cloud Uninstaller.exe'
    if (Test-Path $u) { Start-Process -FilePath $u -Wait }
}

# ---------- 4. Notion ----------
# Se instala en la carpeta del usuario: no necesita administrador,
# pero si esta abierto el desinstalador falla en silencio.
Paso "Notion" {
    Get-Process -Name 'Notion*' -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
    winget uninstall --name 'Notion' --silent --disable-interactivity --force 2>&1 | Out-Null
    Remove-Item "$env:LOCALAPPDATA\Programs\Notion" -Recurse -Force -ErrorAction SilentlyContinue
}

# ---------- 5. TeamViewer ----------
# winget no lo encuentra: tiene su propio desinstalador.
Paso "TeamViewer" {
    Get-Process -Name 'TeamViewer*' -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
    foreach ($tv in @('C:\Program Files\TeamViewer\uninstall.exe',
                      'C:\Program Files (x86)\TeamViewer\uninstall.exe')) {
        if (Test-Path $tv) { Start-Process -FilePath $tv -ArgumentList '/S' -Wait }
    }
}

# ---------- Resultado ----------
Write-Host ""
Write-Host "=== Que quedo ===" -ForegroundColor Cyan
Write-Host ""

$chequeos = @(
    @{ Que = 'Microsoft 365';  Prueba = { Test-Path 'C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE' } }
    @{ Que = 'Adobe';          Prueba = { Test-Path 'C:\Program Files\Adobe\Adobe Creative Cloud' } }
    @{ Que = 'OneDrive';       Prueba = { [bool](Get-Process OneDrive -ErrorAction SilentlyContinue) } }
    @{ Que = 'Notion';         Prueba = { Test-Path "$env:LOCALAPPDATA\Programs\Notion" } }
    @{ Que = 'TeamViewer';     Prueba = { Test-Path 'C:\Program Files\TeamViewer' } }
)
foreach ($c in $chequeos) {
    if (& $c.Prueba) { Write-Host ("  TODAVIA ESTA   {0}" -f $c.Que) -ForegroundColor Yellow }
    else             { Write-Host ("  fuera          {0}" -f $c.Que) -ForegroundColor Green }
}

Write-Host ""
Write-Host "  Algunos dejan restos en la lista de programas hasta reiniciar." -ForegroundColor DarkGray
Write-Host ""
Write-Host "  Para ver la maquina contra el diseño:" -ForegroundColor White
Write-Host "     powershell -ExecutionPolicy Bypass -File C:\Noesis\00_sistema\inventario.ps1"
Write-Host ""
Write-Host "  FALTA UNA COSA QUE NO PUEDO HACER YO:" -ForegroundColor Yellow
Write-Host "  dar de baja la suscripcion de Microsoft 365 desde tu cuenta Microsoft."
Write-Host "  Desinstalarlo libera la maquina pero NO corta el cobro."
Write-Host ""
Read-Host "  (enter para cerrar)"
