# HANDOFF — dónde estamos

Cierre de la jornada del **2026-08-19**.

**Para qué sirve este archivo.** Una sesión nueva de Claude Code, sin historial, se lee
esto primero y sabe exactamente dónde está parado el sistema: qué se hizo, qué hay en
disco, qué falta y en qué orden, y qué ya se decidió y no se vuelve a discutir.

**Lugar en la pila de documentos de esta carpeta** (regla 3: un solo dueño por cosa):

| Archivo | Qué gobierna | Cuándo se lee |
|---|---|---|
| `SISTEMA.md` | el diseño: qué hay instalado y por qué | antes de instalar o cambiar algo |
| `PROTOCOLO.md` | cómo se trabaja con Claude acá | ante dudas de flujo |
| `INVENTARIO.md` | la foto de la máquina medida el 2026-08-18 | para cotejar diseño contra realidad |
| `NOESIS_CHROME_STACK.md` | la capa web: extensiones, circuito de ingesta web, navegación por Claude | al tocar Chrome o la ingesta web |
| **`HANDOFF.md`** (este) | **dónde quedamos** | **al abrir una sesión nueva — y en el proyecto de claude.ai donde se idea (regla 11)** |

Este archivo se pisa a sí mismo: lo reescribe la sesión que cierra. No acumula historia
—esa está en los commits— sino el estado presente.

---

## 1. Conclusión primero

**La capa web quedó armada y probada**: Claude ya puede navegar por sí solo desde
cualquier sesión de Code (MCP `playwright`), hay un puente para manejarle un Chrome
visible (`chrome_debug.bat`, acceso **CHROME PARA CLAUDE** en el Escritorio), y toda
página web se convierte a `.md` limpio con `web_a_md.py`. **Lo único que falta es un
clic de MJM por cada una de las cuatro extensiones** — los links están en
`NOESIS_CHROME_STACK.md`. La Fase 2 del sistema sigue intacta más abajo (§4).

---

## 2. Qué se hizo en esta jornada

**Capa de ingestión y navegación web** — todo gratuito, todo bajo demanda (apagado no
gasta RAM):

- **MCP `playwright`** registrado en la configuración de usuario de Claude Code
  (sirve en cualquier carpeta; verificar con `claude mcp list` → Connected ✔).
  Instalado global con npm (`playwright-mcp`). Maneja el **Chrome ya instalado**,
  no baja otro navegador. Se eligió Playwright y no Puppeteer porque el MCP de
  Puppeteer está archivado, sin mantenimiento.
- **`chrome_debug.bat`** (en `00_sistema`, acceso directo **CHROME PARA CLAUDE** en el
  Escritorio): abre un Chrome visible con el puerto de depuración 9222 y un **perfil
  aparte** en `%LOCALAPPDATA%\Noesis\chrome_debug` — el perfil personal no se toca, y
  Chrome moderno además lo exige. Probado en vivo: el puerto respondió (Chrome 151).
- **`web_a_md.py`** (en `10_ingesta`, mismo dueño que `noesis_ingesta.py`): URL o
  `.html` capturado → `.md` limpio con fecha de captura. Motor: **trafilatura** (pip).
  Probado con página real: estructura conservada, frontmatter correcto. Detalle que
  importa: la búsqueda extensiva de fechas **se inventó una fecha** en la prueba
  (`2026-01-01` en un html sin fecha declarada) — quedó apagada; mejor sin fecha que
  con una inventada.
- **`NOESIS_CHROME_STACK.md`**: las cuatro extensiones (Extensity · PageMarkdown ·
  SingleFile · JSON Formatter), el circuito página→`.md`, y cómo navega Claude.
  La elegida original para web→Markdown era MarkDownload, pero la tienda la marcó
  de baja el mismo día (Manifest V2, sin actualizaciones) y se reemplazó por
  PageMarkdown — el porqué quedó escrito en el propio `NOESIS_CHROME_STACK.md`.
- Registrado todo en `stack.json` (revisión 2026-08-19) y `SISTEMA.md`; regla técnica
  nueva en `PROTOCOLO.md` (Git Bash convierte `/c` en `C:/` — costó un registro MCP roto).

---

## 3. Estado real de la estructura

### Los repositorios: cinco, cada uno con dueño y remoto

| Carpeta | Repo en GitHub (privado) | Estado al cierre |
|---|---|---|
| `C:\Noesis\00_sistema` | `noesis-sistema` | sincronizado este cierre |
| `C:\Noesis\00_nucleo` | `noesis` | sin tocar en esta jornada |
| `C:\Noesis\01_cerebro` | `noesis-legal` | sin tocar en esta jornada |
| `C:\Noesis\10_ingesta` | `noesis-ingesta` | sincronizado este cierre (`web_a_md.py`) |
| `...\GitHub\LEGALENGINE-CONCURSOS-QUIEBRAS` | mismo nombre | prototipo, sin revisar |

Chequeo de los cuatro antes de cerrar una sesión que toque código:

```bash
for d in 00_nucleo 00_sistema 01_cerebro 10_ingesta; do cd "/c/Noesis/$d" && echo "$d: $(git remote | head -1 || echo SIN-REMOTO) $(git status -sb | head -1)"; done
```

### Lo que a propósito no se versiona

`C:\Noesis` raíz (enlaces a papeles de clientes) · `00_sistema\_PRIVADO\` ·
`99_experimentos` (motores pesados) · `02_marketplace` (sin dueño declarado) ·
el perfil `%LOCALAPPDATA%\Noesis\chrome_debug` (cookies y sesiones: nunca a un repo).

### `~/.claude` — respaldada, con criterio

`claude_config\` (en `00_sistema`) versiona solo lo hecho a mano (`settings.json`,
`CLAUDE.md` global). El resto es cache o transcripciones con datos de clientes.
Detalle en `claude_config\LEEME.md`. **Nuevo de hoy:** la config de usuario de Claude
(`~/.claude.json`) ahora lleva el registro del MCP `playwright`.

---

## 4. Pendientes, en orden

### Inmediato — un clic de MJM cada uno

1. **Instalar las cuatro extensiones de Chrome** desde los links de
   `NOESIS_CHROME_STACK.md` (Extensity · PageMarkdown · SingleFile · JSON Formatter).
   Claude no instala extensiones: el clic es de MJM.
2. **Probar el MCP en una sesión nueva** de Claude Code: pedirle que navegue a una
   página y la resuma. Si conecta y navega, la capa queda estrenada.

### Fase 2 — lo que sigue (igual que ayer, nada se cerró hoy)

3. **Panel dominical**: unir `panel.py` con los vencimientos (salen de `_PRIVADO`)
   y programarlo para el domingo a la tarde.
4. **Etapa 03 VALIDADO de la ingesta**: definir qué significa validar. Criterio de MJM.
5. **Jubilar los circuitos viejos de conversión**: `99_experimentos\marker_pdfs` y
   `Downloads\Noesis`.
6. **Cotejar las cuatro carpetas duplicadas** Escritorio ↔ Drive. Drive manda.
   Detalle fuera del repo, en `_local_pendientes.md`.
7. **Ficha del adaptador de Marker** (constitución §8). Ahora también la pide
   trafilatura si se consolida como pieza estructural.
8. **Revisar el prototipo `LEGALENGINE-CONCURSOS-QUIEBRAS`** — contenido jurídico:
   sesión de `01_cerebro`, no acá.
9. **Confirmar el circuito de ideación** (proyecto de claude.ai con este HANDOFF
   pegado) la próxima vez que se use.

### Fase 3 — más adelante

10. **MCP local propio en Python para cálculos determinísticos** (liquidar, intereses,
    plazos). Antes de la primera línea: definir dueño (`00_sistema` o `01_cerebro`) y
    declararlo en `SISTEMA.md`. Local, sin nube, sin placa de video.
11. **Renombrar `99_experimentos`** — el día que haya que tocar Marker por otro motivo.

---

## 5. Decisiones tomadas — no se discuten de nuevo

Si una sesión nueva propone lo contrario de algo de esta lista, la respuesta ya está dada.

| Decisión | Por qué, en una línea |
|---|---|
| **Cero nube de Microsoft. Office de escritorio sí** | el problema nunca fue Word, fue OneDrive — bloqueado por política |
| **La sesión de Windows sigue siendo cuenta local** | cuenta Microsoft reactiva OneDrive; la licencia OEM no depende de ninguna cuenta |
| **Un repo por componente. Nada de `C:\dev` ni repo `infra`** | los repos viven junto a lo que versionan |
| **`C:\Noesis` raíz no se versiona** | contiene enlaces a papeles de clientes |
| **`99_experimentos` no se renombra todavía** | rompe Marker; se hace cuando haya que tocarlo igual |
| **Docling descartado; Marker sólo a pedido** | medido: Tesseract hace en 5,4 s lo que Marker en 14-20 min |
| **Copilot no se instala** | duplica a Claude |
| **Las etapas de la ingesta son estados, no carpetas** | si no, el mismo documento viviría en tres lugares |
| **El panel es semanal, sin IA y sin costo** | el repo guarda el generador, no el resultado |
| **Nada de cliente en lo versionado** | se verifica **antes** de commitear |
| **Una sesión, un tema; la carpeta lo declara** | `tema_sesion.py` lo lee al arrancar |
| **La credencial la pone MJM** | Claude deja todo hasta la puerta; el clic es de MJM |
| **Lo que llega de otra IA entra como borrador** | se contrasta contra el disco antes de ejecutar |
| **`~/.claude` se respalda parcial, no entera** | sólo lo hecho a mano; el resto es cache o transcripciones |
| **Cowork es para escritos de caso** | para idear sin Code: proyecto normal de claude.ai con el HANDOFF pegado |
| **Commit y `push` automáticos al cerrar** | la conexión a GitHub es de la máquina, no de la sesión |
| **Playwright, no Puppeteer** (2026-08-19) | el MCP de Puppeteer está archivado; el de Playwright es el vigente y usa el Chrome ya instalado |
| **El conversor web vive en `10_ingesta`** (2026-08-19) | la conversión a texto tiene un solo dueño: la ingesta. `00_sistema` guarda el puente y el doc del stack |
| **La fecha de publicación no se inventa** (2026-08-19) | la búsqueda extensiva de trafilatura fabricó un `2026-01-01`; quedó apagada — mejor sin fecha que con una falsa |
| **El perfil de depuración de Chrome va aparte y fuera de repo** (2026-08-19) | Chrome moderno lo exige, y un perfil lleva cookies y sesiones |

---

## 6. Cómo arranca la próxima sesión

Abrir la carpeta según el tema (`C:\Noesis\00_sistema` para seguir con esto), leer este
archivo, y si es la primera sesión después de este cierre: los dos clics del §4
(extensiones y prueba del MCP).

Al cerrar, el cierre de cinco pasos que es uno solo (regla 10): verificar anonimato →
**commitear y hacer `push` sin que haga falta pedirlo** → informar el costo
(`python costo.py`) → sumar a `PROTOCOLO.md` la regla que haya dejado la sesión →
**reescribir este archivo** y entregarlo por chat como adjunto (regla 11).

_Escrito el 2026-08-19 al cierre de la sesión que armó la capa web._
