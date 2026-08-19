# Inventario de la máquina — 2026-08-18

Foto del estado real, medida hoy contra el diseño que declara `SISTEMA.md`.
No es un diseño: es lo que la máquina **efectivamente** tiene. Cuando los dos no
coinciden, esta discrepancia es el trabajo pendiente.

Cómo se hizo: `inventario.ps1` (que lee `stack.json`) para programas y piezas
propias, más un recorrido de repositorios git y carpetas hecho a mano.

---

## 1. Programas — todo el stack declarado está instalado

Ningún faltante. `inventario.ps1` da **ok** en los once:

Chrome · Google Drive · Git · GitHub CLI · Python 3.12.10 · Node.js · Zed ·
Tesseract-OCR · Zoom · Claude · Microsoft 365

## 2. Piezas propias — las siete presentes

Marker · `llama-server` · `spa.traineddata` · Ingesta NOÉSIS ·
faster-whisper (small) · ffmpeg · `para_notebooklm`

Son las que no salen de ningún instalador: si se pierden, no hay de dónde
bajarlas de nuevo.

## 3. Prohibidos — limpio

Cero coincidencias. **Adobe Creative Cloud y TeamViewer ya no están**, lo que
cierra un pendiente que `SISTEMA.md` todavía da por abierto.

## 4. Hardware

| | |
|---|---|
| CPU | Intel i7-8665U |
| RAM | 16 GB |
| Video | Intel UHD 620 integrada — **sin placa dedicada** |

Sin cambios. Sigue vigente la regla: lo que pida placa de video, no va.

---

## 5. Mapa de repositorios — lo que este inventario agrega

Cada componente con dueño propio en GitHub, según la decisión de un repo por
componente:

| Carpeta | Repo | Rama | Sin commitear |
|---|---|---|---|
| `C:\Noesis\00_sistema` | `noesis-sistema` | main | **3** |
| `C:\Noesis\00_nucleo` | `noesis` | main | 0 |
| `C:\Noesis\01_cerebro` | `noesis-legal` | main | 0 |
| `C:\Noesis\10_ingesta` | `noesis-ingesta` | main | 0 |
| `C:\Users\M01\Documents\GitHub\LEGALENGINE-CONCURSOS-QUIEBRAS` | `LEGALENGINE-CONCURSOS-QUIEBRAS` | — | — |

Y lo que **no** está en ningún repositorio:

| Carpeta | Situación |
|---|---|
| `C:\Noesis` (raíz) | **correcto y decidido**: contiene enlaces a papeles de clientes |
| `C:\Noesis\99_experimentos` | motores pesados (varios GB). Sin versionar y **sin declarar por qué** |
| `C:\Noesis\02_marketplace` | 1 archivo. Sin repo y sin dueño declarado |
| `C:\Users\M01\.claude` | **la configuración de Claude Code no está respaldada en ningún lado** |

---

## 6. Discrepancias contra `SISTEMA.md`

Esto es lo accionable. Cuatro cosas, en orden de importancia:

### a) ~~`~/.claude` sin respaldo~~ — resuelto el 2026-08-18

De las ocho cosas que hay adentro de `~/.claude`, sólo dos eran configuración hecha a
mano y no se regeneraban solas: `settings.json` y `CLAUDE.md`. Las demás —`plugins`,
`session-env`, `shell-snapshots`— son cache de trabajo, y `projects`/`sessions` son las
**transcripciones completas de las conversaciones**, con nombres de clientes adentro:
justo lo que P10 prohíbe versionar. Y `.credentials.json` / `mcp-needs-auth-cache.json`
son secretos, nunca entran a git.

Se copiaron los dos archivos reales a `claude_config\`, que sí se versiona, con
`respaldar_claude.ps1` para resincronizar cuando cambien. El detalle completo —qué
entra, qué no, y cómo restaurar en una máquina nueva— está en `claude_config\LEEME.md`.

### b) `SISTEMA.md` se contradice a sí mismo sobre Office

El texto de la regla operativa dice —corregido el 2026-08-18— *"Cero nube de
Microsoft. Office de escritorio sí"*. Pero la tabla de **Prohibidos**, más
abajo en el mismo archivo, todavía dice *"Microsoft 365 (Word, Excel) — la
cubre Google"*. `stack.json` ya está del lado nuevo: por eso el inventario da
Office como **ok** y no como **SOBRA**.

Un archivo que es fuente única no puede decir dos cosas. Hay que borrar esa
fila de Prohibidos.

### c) Siete carpetas vacías y sin dueño en `C:\Noesis`

Confirmadas hoy, **cero archivos** en cada una:
`00_inbox` · `05_audio` · `10_fuentes_md` · `20_fichas` · `30_patrones` ·
`99_procesados` · `_logs`

Ninguna figura en la tabla de carpetas de `SISTEMA.md`. Por cada una: borrarla,
o declararla con su función.

### d) Tres archivos sin commitear en `00_sistema`

`SISTEMA.md` (modificado) · `panel.py` (modificado) · `CLAUDE.md` (nuevo, nunca
versionado).

---

## 7. Sobre `C:\dev`

No existe, y no debería crearse. Los repos ya viven junto al componente que
versionan, con un dueño cada uno. Una segunda carpeta de repos sería el doble
dueño que prohíbe el principio rector de `SISTEMA.md`.

La portabilidad a otra máquina ya está resuelta por esa vía: `git clone` de los
cinco repos. Lo único que falta es el punto **6.a**.
