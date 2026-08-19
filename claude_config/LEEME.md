# Respaldo de la configuración de Claude Code

Copia versionada de lo que hay en `C:\Users\M01\.claude`, para que esta configuración
sobreviva aunque la notebook muera. Se actualiza corriendo `respaldar_claude.ps1` desde
`00_sistema` después de tocar cualquiera de los dos archivos.

## Qué se respalda y por qué es esto y no toda la carpeta

`~/.claude` tiene ocho cosas adentro. Sólo dos son configuración hecha a mano; el resto
se regenera solo o no debe salir de esta máquina:

| Qué | Se respalda | Por qué |
|---|---|---|
| `settings.json` | **sí** | permisos, hooks — hecho a mano, no se regenera |
| `CLAUDE.md` (global) | **sí** | perfil e instrucciones — hecho a mano, no se regenera |
| `skills` | no hace falta | ya es un *junction* a `01_cerebro\skills`, que tiene repo propio |
| `.claude.json` (en `C:\Users\M01`, no adentro de `.claude`) | **no** | cache de sesión: feature flags, cuenta, rutas de proyectos abiertos. Se reconstruye solo al iniciar sesión de nuevo |
| `.credentials.json` | **no, nunca** | secreto — token de autenticación |
| `mcp-needs-auth-cache.json` | **no, nunca** | secreto — igual que arriba |
| `projects/`, `sessions/` | **no, nunca** | son las **transcripciones completas de las conversaciones**. Ahí adentro hay nombres de clientes y expedientes discutidos en sesión — exactamente lo que P10 prohíbe versionar |
| `plugins/`, `session-env/`, `shell-snapshots/` | no hace falta | cache de trabajo, se regenera solo |

## Cómo se restaura en una máquina nueva

1. `git clone` de `noesis-sistema` (este repo).
2. Copiar `claude_config\settings.json` → `C:\Users\M01\.claude\settings.json`.
3. Copiar `claude_config\CLAUDE.md` → `C:\Users\M01\.claude\CLAUDE.md`.
4. Rehacer el *junction* de skills: `mklink /J C:\Users\M01\.claude\skills C:\Noesis\01_cerebro\skills`.
5. Iniciar sesión de nuevo en Claude Code — reconecta cuenta, plugins y MCP; no se
   restauran de archivo, son de la cuenta.

Si la ruta de usuario cambia (otro nombre que no sea `M01`), `settings.json` tiene rutas
absolutas (`additionalDirectories`, el comando del hook) que hay que ajustar a mano.
