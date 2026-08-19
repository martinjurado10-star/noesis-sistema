# Respalda la configuracion real de Claude Code (~/.claude) hacia claude_config/,
# que si se versiona. Correr despues de tocar settings.json o el CLAUDE.md global.
#
# No copia todo ~/.claude a proposito: ver claude_config/LEEME.md para el porque.

$origen = "$env:USERPROFILE\.claude"
$destino = "$PSScriptRoot\claude_config"

if (-not (Test-Path $destino)) {
    New-Item -ItemType Directory -Path $destino | Out-Null
}

Copy-Item "$origen\settings.json" "$destino\settings.json" -Force
Copy-Item "$origen\CLAUDE.md" "$destino\CLAUDE.md" -Force

Write-Host "Respaldados: settings.json y CLAUDE.md -> $destino"
Write-Host "Recorda commitear claude_config/ para que el respaldo sea real (regla 8: versionado no es respaldado)."
