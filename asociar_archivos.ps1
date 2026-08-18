# ============================================================
#  NOESIS - Devolverle a Windows con que abrir cada archivo
#
#  Al desinstalar Office, Windows se quedo sin aplicacion asociada
#  para PDF, Word, Excel, PowerPoint y hasta .txt. Esto lo arregla.
#
#      powershell -ExecutionPolicy Bypass -File asociar_archivos.ps1
#
#  No necesita administrador: escribe solo en tu perfil de usuario.
#  Para ver como quedo, sin tocar nada:  -Ver
# ============================================================
param([switch]$Ver)

$ErrorActionPreference = 'Continue'

$CHROME = @("$env:ProgramFiles\Google\Chrome\Application\chrome.exe",
            "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe",
            "$env:LOCALAPPDATA\Google\Chrome\Application\chrome.exe"
           ) | Where-Object { Test-Path $_ } | Select-Object -First 1

$ZED = @("$env:LOCALAPPDATA\Programs\Zed\Zed.exe",
         "$env:ProgramFiles\Zed\Zed.exe"
        ) | Where-Object { Test-Path $_ } | Select-Object -First 1

$NOTEPAD = "$env:SystemRoot\system32\notepad.exe"

# Documentos: manda Office si esta; si no, LibreOffice. Nunca los dos:
# el que gana es el que se declara primero (ver SISTEMA.md, un dueño por funcion).
$OFF = 'C:\Program Files\Microsoft Office\root\Office16'
$WORD  = Join-Path $OFF 'WINWORD.EXE'
$EXCEL = Join-Path $OFF 'EXCEL.EXE'
$PPT   = Join-Path $OFF 'POWERPNT.EXE'

$LIBRE = @("$env:ProgramFiles\LibreOffice\program\soffice.exe",
           "${env:ProgramFiles(x86)}\LibreOffice\program\soffice.exe"
          ) | Where-Object { Test-Path $_ } | Select-Object -First 1

$DOC  = if (Test-Path $WORD)  { $WORD }  else { $LIBRE }
$HOJA = if (Test-Path $EXCEL) { $EXCEL } else { $LIBRE }
$PRES = if (Test-Path $PPT)   { $PPT }   else { $LIBRE }

$reglas = @(
    @{ Ext = '.pdf';  Prog = 'Noesis.pdf';   App = $CHROME;  Nombre = 'Documento PDF' }
    @{ Ext = '.txt';  Prog = 'Noesis.txt';   App = $NOTEPAD; Nombre = 'Texto' }
    @{ Ext = '.log';  Prog = 'Noesis.txt';   App = $NOTEPAD; Nombre = 'Texto' }
    @{ Ext = '.md';   Prog = 'Noesis.code';  App = $ZED;     Nombre = 'Markdown' }
    @{ Ext = '.json'; Prog = 'Noesis.code';  App = $ZED;     Nombre = 'JSON' }
    @{ Ext = '.py';   Prog = 'Noesis.code';  App = $ZED;     Nombre = 'Python' }
    @{ Ext = '.html'; Prog = 'Noesis.web';   App = $CHROME;  Nombre = 'Pagina web' }
    @{ Ext = '.csv';  Prog = 'Noesis.hoja';  App = $HOJA;    Nombre = 'Planilla CSV' }
    @{ Ext = '.docx'; Prog = 'Noesis.doc';   App = $DOC;     Nombre = 'Documento Word' }
    @{ Ext = '.doc';  Prog = 'Noesis.doc';   App = $DOC;     Nombre = 'Documento Word' }
    @{ Ext = '.xlsx'; Prog = 'Noesis.hoja';  App = $HOJA;    Nombre = 'Planilla Excel' }
    @{ Ext = '.xls';  Prog = 'Noesis.hoja';  App = $HOJA;    Nombre = 'Planilla Excel' }
    @{ Ext = '.pptx'; Prog = 'Noesis.pres';  App = $PRES;    Nombre = 'Presentacion' }
    @{ Ext = '.ppt';  Prog = 'Noesis.pres';  App = $PRES;    Nombre = 'Presentacion' }
)

if ($Ver) {
    Write-Host ""
    Write-Host "=== Con que se abre cada archivo hoy ===" -ForegroundColor Cyan
    foreach ($r in ($reglas | Sort-Object Ext -Unique)) {
        $p = (Get-ItemProperty "HKCU:\Software\Classes\$($r.Ext)" -ErrorAction SilentlyContinue).'(default)'
        $estado = if ($p) { $p } else { 'SIN ASOCIAR' }
        Write-Host ("  {0,-7} {1}" -f $r.Ext, $estado)
    }
    Write-Host ""
    exit 0
}

Write-Host ""
Write-Host "=== Devolviendo las asociaciones ===" -ForegroundColor Cyan
Write-Host ""

$sinApp = @()
foreach ($r in $reglas) {
    if (-not $r.App) { $sinApp += $r.Ext; continue }

    # ProgID propio: asi no dependemos de que otro programa lo defina
    $base = "HKCU:\Software\Classes\$($r.Prog)"
    New-Item -Path "$base\shell\open\command" -Force | Out-Null
    Set-ItemProperty -Path $base -Name '(default)' -Value $r.Nombre
    Set-ItemProperty -Path "$base\shell\open\command" -Name '(default)' -Value ('"{0}" "%1"' -f $r.App)

    New-Item -Path "HKCU:\Software\Classes\$($r.Ext)" -Force | Out-Null
    Set-ItemProperty -Path "HKCU:\Software\Classes\$($r.Ext)" -Name '(default)' -Value $r.Prog

    Write-Host ("  {0,-7} -> {1}" -f $r.Ext, (Split-Path $r.App -Leaf)) -ForegroundColor Green
}

if ($sinApp) {
    Write-Host ""
    Write-Host "  Sin programa que los abra todavia:" -ForegroundColor Yellow
    Write-Host ("     " + ($sinApp -join '  ')) -ForegroundColor Yellow
    Write-Host "  Son los de Office. Instalar LibreOffice y volver a correr esto:" -ForegroundColor DarkGray
    Write-Host "     winget install TheDocumentFoundation.LibreOffice" -ForegroundColor DarkGray
}

Write-Host ""
Write-Host "  Listo. Si el Explorador sigue mostrando el icono viejo, reinicialo." -ForegroundColor White
Write-Host ""
