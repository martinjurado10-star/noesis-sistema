# ============================================================
#  NOESIS - Acomodar el sistema (REQUIERE ADMINISTRADOR)
#
#  Un solo script para todo lo que Windows no deja hacer sin permisos.
#  Reemplaza a terminar_sistema.ps1 y volver_a_office.ps1: habia tres
#  scripts de administrador y eso es un doble dueño (ver SISTEMA.md).
#
#  COMO CORRERLO
#      Start-Process powershell -Verb RunAs -ArgumentList '-ExecutionPolicy','Bypass','-File','C:\Noesis\00_sistema\acomodar_sistema.ps1'
#
#  QUE HACE, EN ESTE ORDEN (el orden importa)
#      1. Blinda OneDrive     para que Office no lo traiga de vuelta
#      2. Saca Adobe          desarmando lo que lo resucita
#      3. Instala Office      tarda, no cerrar
#      4. Office sin nube     guarda en tu disco, sin Copilot
#
#  LO QUE NO SE PUEDE EVITAR: para activar la suscripcion hay que
#  iniciar sesion UNA vez con la cuenta que la pago.
#
#  NO TOCA NINGUN ARCHIVO TUYO. Solo programas.
# ============================================================
$ErrorActionPreference = "Continue"

$id = [Security.Principal.WindowsIdentity]::GetCurrent()
$pr = New-Object Security.Principal.WindowsPrincipal($id)
if (-not $pr.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host ""
    Write-Host "  Esta ventana NO es de administrador." -ForegroundColor Red
    Write-Host "  Pega esto en PowerShell:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  Start-Process powershell -Verb RunAs -ArgumentList '-ExecutionPolicy','Bypass','-File','C:\Noesis\00_sistema\acomodar_sistema.ps1'"
    Write-Host ""
    Read-Host "  (enter para cerrar)"
    exit 1
}

Write-Host ""
Write-Host "  ===========================================================" -ForegroundColor Cyan
Write-Host "    NOESIS - Acomodar el sistema" -ForegroundColor Cyan
Write-Host "  ===========================================================" -ForegroundColor Cyan
Write-Host "    No se toca ningun archivo tuyo. Solo programas." -ForegroundColor DarkGray
Write-Host ""

# ---------- 1. OneDrive: que no vuelva nunca ----------
Write-Host "  [1 de 4] Blindando contra OneDrive ..." -ForegroundColor White
$k = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive'
New-Item -Path $k -Force | Out-Null
Set-ItemProperty -Path $k -Name 'DisableFileSyncNGSC' -Value 1 -Type DWord
Set-ItemProperty -Path $k -Name 'DisableFileSync'     -Value 1 -Type DWord
Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run' -Name 'OneDriveSetup' -ErrorAction SilentlyContinue
Get-Process OneDrive -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Write-Host "           bloqueado: aunque algo lo instale, no sincroniza" -ForegroundColor Green
Write-Host ""

# ---------- 2. Adobe ----------
Write-Host "  [2 de 4] Sacando Adobe ..." -ForegroundColor White
if (Test-Path 'C:\Program Files\Adobe\Adobe Creative Cloud') {
    # Adobe se resucita solo: primero se desarma lo que lo relanza
    Get-ScheduledTask | Where-Object { $_.TaskName -match 'Adobe|Creative|SoftLanding' } |
        Disable-ScheduledTask -ErrorAction SilentlyContinue | Out-Null
    Get-Service | Where-Object { $_.Name -match 'Adobe|AGS|AGM' } | ForEach-Object {
        Stop-Service $_.Name -Force -ErrorAction SilentlyContinue
        Set-Service  $_.Name -StartupType Disabled -ErrorAction SilentlyContinue
    }
    Get-Process | Where-Object { $_.ProcessName -match 'Adobe|Creative|CoreSync|CCX|CCLibrary' } |
        Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 5

    # El desinstalador comun de Adobe se planta cuando algo suyo sigue vivo.
    # Para eso Adobe hace su propia herramienta de limpieza: es la que usamos.
    $limpiador = Join-Path $PSScriptRoot '_herramientas\AdobeCreativeCloudCleanerTool.exe'
    if (Test-Path $limpiador) {
        Write-Host "           usando el limpiador oficial de Adobe ..." -ForegroundColor DarkGray
        Start-Process -FilePath $limpiador -ArgumentList '--eulaAccepted=1','--removeAll=ALL' -Wait
    } else {
        $u = 'C:\Program Files (x86)\Adobe\Adobe Creative Cloud\Utils\Creative Cloud Uninstaller.exe'
        if (Test-Path $u) {
            Write-Host "    >>> SE ABRE LA VENTANA DE ADOBE: apreta DESINSTALAR ahi." -ForegroundColor Yellow
            Start-Process -FilePath $u -Wait
        } else {
            Write-Host "           no encuentro con que desinstalar Adobe" -ForegroundColor Red
        }
    }
    foreach ($r in @('C:\Program Files\Adobe','C:\Program Files (x86)\Adobe')) {
        Remove-Item $r -Recurse -Force -ErrorAction SilentlyContinue
    }
} else {
    Write-Host "           Adobe ya no esta" -ForegroundColor Green
}
Write-Host ""

# ---------- 3. Office ----------
Write-Host "  [3 de 4] Instalando Microsoft 365 (tarda, no cierres) ..." -ForegroundColor White
if (Test-Path 'C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE') {
    Write-Host "           Office ya esta instalado" -ForegroundColor Green
} else {
    winget install --id Microsoft.Office --accept-package-agreements --accept-source-agreements --disable-interactivity 2>&1 |
        Select-Object -Last 2
}
Write-Host ""

# ---------- 4. Office sin nube ----------
Write-Host "  [4 de 4] Office guarda en tu disco, no en la nube ..." -ForegroundColor White
$base = 'HKCU:\Software\Policies\Microsoft\office\16.0'
New-Item -Path "$base\common\general" -Force | Out-Null
Set-ItemProperty -Path "$base\common\general" -Name 'PreferCloudSaveLocations' -Value 0 -Type DWord
Set-ItemProperty -Path "$base\common\general" -Name 'SkyDriveSignInOption'     -Value 0 -Type DWord
New-Item -Path "$base\common\internet" -Force | Out-Null
Set-ItemProperty -Path "$base\common\internet" -Name 'UseOnlineContent' -Value 0 -Type DWord
New-Item -Path "$base\common\officecopilot" -Force | Out-Null
Set-ItemProperty -Path "$base\common\officecopilot" -Name 'DisableCopilot' -Value 1 -Type DWord
Write-Host "           listo: sin nube y sin Copilot" -ForegroundColor Green

# ---------- Resultado ----------
Write-Host ""
Write-Host "  ===========================================================" -ForegroundColor Cyan
Write-Host "    Como quedo" -ForegroundColor Cyan
Write-Host "  ===========================================================" -ForegroundColor Cyan
$chequeos = @(
    @{ Q = 'Office instalado';  P = { Test-Path 'C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE' }; Esperado = $true }
    @{ Q = 'Adobe';             P = { Test-Path 'C:\Program Files\Adobe\Adobe Creative Cloud' };                 Esperado = $false }
    @{ Q = 'OneDrive corriendo';P = { [bool](Get-Process OneDrive -ErrorAction SilentlyContinue) };              Esperado = $false }
)
foreach ($c in $chequeos) {
    $hay = & $c.P
    $bien = ($hay -eq $c.Esperado)
    $texto = if ($hay) { 'SI' } else { 'no' }
    Write-Host ("  {0,-22} {1}" -f $c.Q, $texto) -ForegroundColor $(if ($bien) { 'Green' } else { 'Yellow' })
}

Write-Host ""
Write-Host "  QUE SIGUE:" -ForegroundColor White
Write-Host "   1. Abri Word una vez y logueate con la cuenta que pago la suscripcion."
Write-Host "      Es la unica vez. No habilita OneDrive: quedo bloqueado."
Write-Host "   2. Abri un .docx tuyo y fijate que se vea bien."
Write-Host "   3. Recien ahi avisale a Claude para sacar LibreOffice."
Write-Host ""
Read-Host "  (enter para cerrar)"
