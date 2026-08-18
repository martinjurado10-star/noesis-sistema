# ============================================================
#  NOESIS - Office de escritorio, sin nube (REQUIERE ADMINISTRADOR)
#
#  Decision del 2026-08-17: Office si, OneDrive nunca.
#  Office es mejor herramienta para escritos con control de cambios
#  y formato; el problema nunca fue Word, fue OneDrive.
#
#  COMO CORRERLO
#      Start-Process powershell -Verb RunAs -ArgumentList '-ExecutionPolicy','Bypass','-File','C:\Noesis\00_sistema\volver_a_office.ps1'
#
#  EL ORDEN IMPORTA: primero se blinda OneDrive, despues se instala
#  Office. Al reves, Office lo trae de vuelta y ya esta adentro.
#
#  LO QUE NO SE PUEDE EVITAR: para activar la suscripcion hay que
#  iniciar sesion UNA vez con la cuenta que la pago. Eso no tiene
#  vuelta. Todo lo demas queda apagado.
# ============================================================
$ErrorActionPreference = "Continue"

$id = [Security.Principal.WindowsIdentity]::GetCurrent()
$pr = New-Object Security.Principal.WindowsPrincipal($id)
if (-not $pr.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host ""
    Write-Host "  Esta ventana NO es de administrador." -ForegroundColor Red
    Write-Host "  Pega esto en PowerShell:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  Start-Process powershell -Verb RunAs -ArgumentList '-ExecutionPolicy','Bypass','-File','C:\Noesis\00_sistema\volver_a_office.ps1'"
    Write-Host ""
    Read-Host "  (enter para cerrar)"
    exit 1
}

# ---------- 1. OneDrive: que no vuelva nunca ----------
Write-Host ""
Write-Host "  [1/3] Blindando contra OneDrive ..." -ForegroundColor White
$k = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive'
New-Item -Path $k -Force | Out-Null
Set-ItemProperty -Path $k -Name 'DisableFileSyncNGSC' -Value 1 -Type DWord
Set-ItemProperty -Path $k -Name 'DisableFileSync'     -Value 1 -Type DWord
Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run' `
                    -Name 'OneDriveSetup' -ErrorAction SilentlyContinue
Get-Process OneDrive -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Write-Host "        bloqueado por politica: aunque algo lo instale, no sincroniza" -ForegroundColor Green

# ---------- 2. Office ----------
Write-Host "  [2/3] Instalando Microsoft 365 (tarda, no cierres) ..." -ForegroundColor White
winget install --id Microsoft.Office --accept-package-agreements --accept-source-agreements --disable-interactivity 2>&1 |
    Select-Object -Last 2

# ---------- 3. Office sin nube ----------
Write-Host "  [3/3] Configurando Office para guardar en tu disco ..." -ForegroundColor White
$base = 'HKCU:\Software\Policies\Microsoft\office\16.0'

# Guardar por defecto en la PC, no en la nube
New-Item -Path "$base\common\general" -Force | Out-Null
Set-ItemProperty -Path "$base\common\general" -Name 'PreferCloudSaveLocations' -Value 0 -Type DWord
Set-ItemProperty -Path "$base\common\general" -Name 'SkyDriveSignInOption'     -Value 0 -Type DWord

# No ofrecer servicios conectados ni contenido online
New-Item -Path "$base\common\internet" -Force | Out-Null
Set-ItemProperty -Path "$base\common\internet" -Name 'UseOnlineContent' -Value 0 -Type DWord

# Que el lugar por defecto sea el Escritorio, no OneDrive
foreach ($app in @('word','excel','powerpoint')) {
    New-Item -Path "$base\$app\options" -Force | Out-Null
    Set-ItemProperty -Path "$base\$app\options" -Name 'DefaultPath' -Value 'C:\Users\M01\Desktop' -ErrorAction SilentlyContinue
}

# Copilot fuera
New-Item -Path "$base\common\officecopilot" -Force | Out-Null
Set-ItemProperty -Path "$base\common\officecopilot" -Name 'DisableCopilot' -Value 1 -Type DWord

Write-Host "        listo" -ForegroundColor Green

Write-Host ""
Write-Host "=== Que sigue ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "  1. Abri Word una vez. Te va a pedir iniciar sesion:" -ForegroundColor White
Write-Host "     usa tinchojurado@hotmail.com — es la cuenta que pago la suscripcion."
Write-Host "     Es la UNICA vez que hace falta. No habilita OneDrive: esta bloqueado."
Write-Host ""
Write-Host "  2. Si te ofrece guardar en la nube, decile que no. Ya quedo" -ForegroundColor White
Write-Host "     configurado para guardar en tu disco."
Write-Host ""
Write-Host "  3. Cuando confirmes que Word y Excel abren bien, avisale a Claude" -ForegroundColor White
Write-Host "     para sacar LibreOffice: dos programas para lo mismo es lo que"
Write-Host "     no queremos."
Write-Host ""
Read-Host "  (enter para cerrar)"
