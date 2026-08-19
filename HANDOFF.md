# HANDOFF — dónde estamos

Cierre de la jornada del **2026-08-19** (tercera sesión del día en `00_sistema`).

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
| `MESA_DISENO.md` | la instrucción de la mesa de diseño: cómo se piensa una orden antes de llegar a la terminal | antes de abrir una mesa — proyecto de claude.ai, gem o GPT |
| **`HANDOFF.md`** (este) | **dónde quedamos** | **al abrir una sesión nueva — y en el proyecto de claude.ai donde se idea (regla 11)** |

Este archivo se pisa a sí mismo: lo reescribe la sesión que cierra. No acumula historia
—esa está en los commits— sino el estado presente.

---

## 1. Conclusión primero

**Sesión sin cambios en disco — dos hallazgos de proceso, no de sistema.**

1. Llegó una orden para sacar "Microsoft 365 (Word, Excel)" de la tabla de Prohibidos
   de `SISTEMA.md` y commitear `SISTEMA.md` + `panel.py` + `CLAUDE.md`. Verificado
   contra el disco antes de ejecutar (regla 16): ya estaba hecho desde el
   **2026-08-18**, commit `39f20f5`. `git status` daba árbol limpio y sincronizado.
   No se ejecutó nada — no había nada que hacer.
2. Llegó un pedido de navegar `https://example.com` con el MCP de Playwright y
   resumirla. Se frenó por "fuera de tema de la sesión" — pero el pendiente **4.1.2**
   de este mismo archivo (ver más abajo, sin cambios) ya lo declaraba tema de
   `00_sistema`: *"Probar el MCP en una sesión nueva: pedirle que navegue a una
   página y la resuma. Si conecta y navega, la capa queda estrenada."* El freno fue
   un error de proceso, no de criterio — está corregido con la regla 17 de
   `PROTOCOLO.md` (§2 abajo). **El pendiente 4.1.2 sigue sin probarse.**

El resto del estado del sistema — modelo Dual-Track, compuerta de entrada
(`PROTOCOLO.md` §15-17), capa web — sigue exactamente como quedó en el cierre
anterior (ver §3 y §4). Ningún pendiente se movió hoy.

---

## 2. Qué se hizo en esta jornada

- **Verificación contra disco (regla 16)**: la orden de Office/Prohibidos ya estaba
  resuelta desde el 2026-08-18 — se reportó sin ejecutar, cero commits de más.
- **`PROTOCOLO.md` — regla 17 agregada**: *"El pendiente ya declarado no es 'fuera de
  tema' — cotejar contra el `HANDOFF.md` antes de frenar."* Costó un pedido legítimo
  rebotado (el pendiente 4.1.2, probar Playwright MCP, llegó formulado casi palabra
  por palabra y se frenó igual). Commit de este cierre.
- **Costo informado** (`python costo.py`, hoy 2026-08-19): 9 sesiones, 108.513.727
  tokens totales, **USD 120,66** de uso dimensionado hoy (no es lo que se paga: hay
  plan de suscripción con cuota fija). Mes: 19 sesiones, USD 642,61.

---

## 3. Estado real de la estructura

Sin cambios respecto del cierre anterior — no se tocó capa web, Dual-Track, ni
compuerta de entrada esta sesión. Ver el HANDOFF anterior (commit `52ecd41` y previos)
o directamente `SISTEMA.md` / `PROTOCOLO.md` / `MESA_DISENO.md` para el detalle completo:

```
VÍA 1 — OPERACIÓN (papeles, Drive)        VÍA 2 — DESTILACIÓN (motor, C:)
G:\Mi unidad\ESTUDIO JURIDICO NOESIS\     C:\Noesis\01_cerebro\skills\<área>\
├── 0_ENTRADA\          ← material crudo  ├── SKILL.md      ← razonamiento
├── 01_Casos_Activos\   ← 9 casos vivos   ├── references\   ← fichas con pinpoint
│     (se trabaja en Cowork)              ├── scripts\      ← cálculo determinístico
└── 02_Casos_Archivados\ ← vacía          └── modelos\      ← plantillas (vacías, esperando destilación)
        ↑                                         ↑
        └──── el Post-Mortem cruza de una vía a la otra ────┘
              (PROTOCOLO.md §14 — antes de archivar)
```

### Los repositorios: cinco, cada uno con dueño y remoto

| Carpeta | Repo en GitHub (privado) | Estado al cierre |
|---|---|---|
| `C:\Noesis\00_sistema` | `noesis-sistema` | sincronizado este cierre |
| `C:\Noesis\00_nucleo` | `noesis` | sin tocar en esta jornada |
| `C:\Noesis\01_cerebro` | `noesis-legal` | sin tocar en esta jornada (último: `36a79ae`) |
| `C:\Noesis\10_ingesta` | `noesis-ingesta` | sin tocar en esta jornada |
| `...\GitHub\LEGALENGINE-CONCURSOS-QUIEBRAS` | mismo nombre | prototipo, sin revisar |

### Lo que a propósito no se versiona

`C:\Noesis` raíz (enlaces a papeles de clientes) · `00_sistema\_PRIVADO\` ·
`99_experimentos` (motores pesados) · `02_marketplace` (sin dueño declarado) ·
el perfil `%LOCALAPPDATA%\Noesis\chrome_debug` (cookies y sesiones: nunca a un repo).

---

## 4. Pendientes, en orden

Sin cambios: nada de esto se tocó hoy.

### 4.1 Inmediato — un clic de MJM cada uno

1. **Instalar las cuatro extensiones de Chrome** desde los links de
   `NOESIS_CHROME_STACK.md` (Extensity · PageMarkdown · SingleFile · JSON Formatter).
2. **Probar el MCP en una sesión nueva** de Claude Code: pedirle que navegue a una
   página y la resuma. Si conecta y navega, la capa queda estrenada. **Sigue sin
   probarse** — el intento de hoy se frenó por error de proceso (ver §1 y §2).

### 4.2 El primer Post-Mortem — la prueba real del Dual-Track

3. **Estrenar `destilar_caso` con el primer caso que cierre.** Hay 9 casos activos en
   Drive y `02_Casos_Archivados` está vacía: ninguno pasó todavía por el paso nuevo.
   **Este es el pendiente que desbloquea todo lo demás de la Vía 2.**

### 4.3 Fase 2

4. **Panel dominical**: unir `panel.py` con los vencimientos (salen de `_PRIVADO`)
   y programarlo para el domingo a la tarde.
5. **Etapa 03 VALIDADO de la ingesta**: definir qué significa validar. Criterio de MJM.
6. **Jubilar los circuitos viejos de conversión**: `99_experimentos\marker_pdfs` y
   `Downloads\Noesis`.
7. **Cotejar las cuatro carpetas duplicadas** Escritorio ↔ Drive. Drive manda.
8. **Ficha del adaptador de Marker** (constitución §8).
9. **Revisar el prototipo `LEGALENGINE-CONCURSOS-QUIEBRAS`** — sesión de `01_cerebro`.

### 4.4 Fase 3

10. **MCP local propio en Python para cálculos determinísticos.** Antes de la primera
    línea: definir dueño (`00_sistema` o `01_cerebro`) y declararlo en `SISTEMA.md`.
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
| **El conversor web vive en `10_ingesta`** (2026-08-19) | la conversión a texto tiene un solo dueño: la ingesta |
| **La fecha de publicación no se inventa** (2026-08-19) | trafilatura fabricó un `2026-01-01`; mejor sin fecha que con una falsa |
| **El perfil de depuración de Chrome va aparte y fuera de repo** (2026-08-19) | Chrome moderno lo exige, y un perfil lleva cookies y sesiones |
| **Nada abstracto: toda pieza nace de un caso real** (2026-08-19) | *no abstract agent design without case-driven distillation* — una skill sin caso detrás es una hipótesis con formato de certeza |
| **Los casos viven en `G:`, nunca en `C:\Noesis`** (2026-08-19) | regla de oro; y papeles de cliente dentro del motor rompen P10 |
| **No hay segunda carpeta `skills\`** (2026-08-19) | `~/.claude/skills` es un junction a `01_cerebro\skills`; una homónima queda invisible para Claude |
| **Un agente por materia se abre al final, no al principio** (2026-08-19) | primero masa crítica de casos cerrados que destilaron fichas; la carpeta vacía finge que el área existe |
| **Ningún caso se archiva sin Post-Mortem** (2026-08-19) | es el único momento en que el dato del caso y la pieza reutilizable están en la misma mesa |
| **Code ejecuta y mapea, no idea** (2026-08-19) | sin objetivo + rutas exactas + criterio de validación, el pedido no tiene forma de terminar |
| **El Modo Piloto no necesita directiva** (2026-08-19) | leer disco, `git status`, `claude mcp list` y proponer el próximo paso no construyen nada |
| **Los `.md` se redactan en el scratchpad y se copian** (2026-08-19) | Word los bloquea en exclusiva; así un bloqueo cuesta un `cp` y no volver a redactar |
| **Toda orden verifica su criterio de éxito contra el disco antes de ejecutar** (2026-08-19) | la mesa no ve el disco; si el HANDOFF está atrasado, redacta contra la foto vieja |
| **Cierre sin reescritura de HANDOFF es cierre incompleto** (2026-08-19) | corolario de la regla 10: el commit no cuenta como cerrado hasta que el HANDOFF lo refleje |
| **Material sin decir si es crudo o curado se trata como crudo, va a `G:\`** (2026-08-19) | freno #5 de la mesa (Anti-mezcla G/C): el costo de sobrar en `G:\` es bajo, el de ensuciar `C:\Noesis` es alto |
| **Un pendiente ya declarado en el HANDOFF no se frena por "fuera de tema"** (2026-08-19) | regla 17: el pendiente 4.1.2 pedía exactamente "navegar y resumir con el MCP" y se rebotó igual, por no cotejar contra el propio archivo |

---

## 6. Cómo arranca la próxima sesión

Abrir la carpeta según el tema (`C:\Noesis\00_sistema` para seguir con esto, o
`C:\Noesis\01_cerebro` cuando haya un caso para destilar), leer este archivo. Lo único
que sigue pendiente y depende de un clic de MJM: las cuatro extensiones de Chrome y
probar el MCP navegando una página (§4.1) — y esta vez, si el pedido coincide con el
4.1.2, no frenarlo por tema (regla 17).

Al cerrar, el cierre de cinco pasos que es uno solo (regla 10): verificar anonimato →
**commitear y hacer `push` sin que haga falta pedirlo** → informar el costo
(`python costo.py`) → sumar a `PROTOCOLO.md` la regla que haya dejado la sesión
(solo si algo costó) → **reescribir este archivo** y entregarlo por chat como adjunto
(regla 11).

_Escrito el 2026-08-19. Cierre de la tercera sesión del día en `00_sistema`: sin cambios
de sistema; dos hallazgos de proceso — una orden ya resuelta en disco (regla 16) y un
freno indebido a un pendiente ya declarado (regla 17 nueva)._
