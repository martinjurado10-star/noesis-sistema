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
| `MESA_DISENO.md` | la instrucción de la mesa de diseño: cómo se piensa una orden antes de llegar a la terminal | antes de abrir una mesa — proyecto de claude.ai, gem o GPT |
| **`HANDOFF.md`** (este) | **dónde quedamos** | **al abrir una sesión nueva — y en el proyecto de claude.ai donde se idea (regla 11)** |

Este archivo se pisa a sí mismo: lo reescribe la sesión que cierra. No acumula historia
—esa está en los commits— sino el estado presente.

---

## 1. Conclusión primero

**El sistema pasó a operar en modo Dual-Track: Operación (Vía 1) y Destilación (Vía 2).**
La regla es una sola y es dura — *no abstract agent design without case-driven
distillation*: nada se construye "porque haría falta", todo nace de un caso real y
después se empaqueta. Quedó escrita en `PROTOCOLO.md` §14 y en el `CLAUDE.md` global,
con el paso de **Post-Mortem obligatorio antes de archivar** cualquier caso.

**Y se cerró la puerta de entrada** (`PROTOCOLO.md` §15): **Code ejecuta y mapea, no
idea.** Un pedido de construcción entra sólo con **objetivo funcional + rutas exactas +
criterio de validación**; si falta alguna, se aborta antes de escribir una línea y se
deriva a la Mesa de Diseño o al caso activo en `G:`. **Con una excepción escrita en la
misma regla —Modo Piloto—**: leer el disco, reportar repos y herramientas y proponer el
próximo paso de este archivo no necesitan directiva previa, porque no construyen nada.

Las dos reglas son la misma idea por los dos extremos: la 15 filtra lo que entra, la 14
obliga a que lo que sale deje pieza.

**Lo importante: no se creó ninguna topología nueva.** El árbol que pedía la directiva
(`casos\` + `knowledge\` + `skills\` + `agents\` en la raíz de `C:\Noesis`) ya existía
casi entero, con otro nombre y del lado correcto del disco. De siete piezas pedidas
faltaban dos: `modelos\` y el ritual de destilación. Se hicieron esas dos.

La capa web sigue como estaba: **falta un clic de MJM por cada extensión de Chrome** (§4).

---

## 2. Qué se hizo en esta jornada

### Bloque A — Capa de ingestión y navegación web (primera sesión)

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
  Detalle que importa: la búsqueda extensiva de fechas **se inventó una fecha**
  (`2026-01-01` en un html sin fecha declarada) — quedó apagada.
- **`NOESIS_CHROME_STACK.md`**: las cuatro extensiones (Extensity · PageMarkdown ·
  SingleFile · JSON Formatter), el circuito página→`.md`, y cómo navega Claude.
- Registrado en `stack.json` (revisión 2026-08-19) y `SISTEMA.md`; regla técnica nueva
  en `PROTOCOLO.md` (Git Bash convierte `/c` en `C:/`).

### Bloque B — Modelo Dual-Track (esta sesión)

Llegó una directiva —formato de tablero, de otra IA— para crear en la raíz de
`C:\Noesis` un árbol `casos\` + `knowledge\` + `skills\` + `agents\`. **Se frenó antes
de escribir** (regla: lo que llega de otra IA entra como borrador y se contrasta contra
el disco). El mapeo pieza por pieza:

| Pedido en `C:\Noesis\` | Dueño real ya existente | Veredicto |
|---|---|---|
| `casos/inbox/` | `G:\...\0_ENTRADA` (buzón vigilado por la ingesta) | ya existe |
| `casos/activos/<id>/` | `G:\...\01_Casos_Activos\` — **9 casos vivos** | ya existe |
| `casos/cerrados/<id>/` | `G:\...\02_Casos_Archivados\` (vacía, esperando) | ya existe |
| `knowledge/reglas/` | `skills\<área>\references\` + `scripts\` | ya existe |
| `knowledge/precedentes/` | `skills\<área>\references\doctrina_*.md` | ya existe |
| `knowledge/modelos/` | — | **faltaba: creado** |
| `skills/` en la raíz | `01_cerebro\skills` | ya existe, **y no se duplica** |
| `agents/` | las skills de área **son** los agentes | ya existe |
| paso de destilación | — | **faltaba: creado** |

**Por qué no se duplicó `skills\`:** `~/.claude/skills` es un *junction* (atajo a nivel
de disco) que apunta a `C:\Noesis\01_cerebro\skills`. Una segunda carpeta `skills\` en la
raíz habría quedado invisible para Claude, y la mitad del trabajo habría ido a parar a
una carpeta muerta. Verificado en disco antes de decidir.

Lo que efectivamente se escribió:

- **`modelos\` en las tres skills de área** (`concursos-ar`, `liquidar-ar`,
  `revision-contratos-ar`), cada una con su `LEEME.md`. Cuarta pieza junto a `SKILL.md` /
  `references\` / `scripts\`. Guarda **plantillas de escritos ya presentados**,
  parametrizadas con `{{VARIABLES}}` y sin un solo dato de cliente. Las tres están
  **vacías a propósito**: se llenan por destilación, no de antemano.
- **`PROTOCOLO.md` §14 — Dual-track: ningún caso se archiva sin destilar.** Las dos vías
  con su herramienta y su carpeta, la regla anti-abstracción, el **Post-Mortem de cinco
  preguntas** obligatorio antes de mover un caso a archivados, y los flujos `nuevo_caso` /
  `destilar_caso` explicados en lenguaje simple.
- **`CLAUDE.md` global** (`~/.claude/CLAUDE.md`, respaldado en `claude_config\`): sección
  Dual-Track con la regla en inglés tal como se pidió, la tabla de las dos vías, los dos
  flujos, y la cuarta pieza `modelos\` sumada a MEICL. Se corrigió además el "siguiente:
  agente Societario" del bloque Estado — ahora dice explícitamente que **no se arma hasta
  que haya casos societarios cerrados que lo pidan**.

### Bloque C — Compuerta de ejecución (misma sesión)

- **`PROTOCOLO.md` §15 — Code ejecuta y mapea, no idea.** Un pedido de construcción entra
  sólo con las tres cosas: **objetivo funcional · rutas exactas · criterio de validación**.
  Si falta cualquiera —o es debate doctrinario, lluvia de ideas, consulta jurídica
  abstracta o desarrollo sin caso real que lo justifique— se aborta antes de generar
  código, módulos o abstracciones, y se responden dos líneas fijas que derivan a la Mesa
  de Diseño (Chat Noesis) o al caso activo en `G:`. Va también en el `CLAUDE.md` global,
  como primera sección de lo específico de Code: rige en toda carpeta.
- **La excepción, escrita en la misma regla: Modo Piloto.** Sin directiva previa y siempre
  permitido, porque es de **sola lectura** y no altera el disco: inspección de estado
  (`git status`, `git diff`, `git log`) · mapeo de herramientas (`claude mcp list`) ·
  exploración de directorios y lectura de archivos · **reportar estado y proponer el
  siguiente paso del `HANDOFF.md`**. La compuerta cierra la puerta de **escribir**, no la
  de **mirar y orientar**. Sin esto, Claude no podría decir en qué estado está la máquina
  ni cuál es el próximo paso, y el estado del sistema volvería a la cabeza de MJM — justo
  lo que este archivo existe para evitar.
- **Tablero de límites físicos y de arquitectura**, cuatro, en la misma §15 y también en el
  `CLAUDE.md` global: casos sólo en `G:` · skills y agentes sólo en
  `01_cerebro\skills\` · contenido pesado al scratchpad antes de copiar · anonimato
  estricto antes de commitear. **Ninguno nace ahí:** los cuatro ya tenían dueño y el
  tablero remite a cada uno en vez de copiarlo, para no repetir el error de `stack.json`
  —dos copias de la misma verdad— que la regla 3 existe para impedir.
- **Por qué la excepción está desde el día uno.** La primera redacción de la §15 sólo
  tenía la parte que rechaza. Con ese texto, la directiva que originó el bloque B —sin
  rutas exactas ni criterio de validación— habría rebotado en dos líneas, y no existirían
  ni el Post-Mortem ni `modelos\`. El rol quedó entonces declarado con sus dos mitades:
  **ejecutor técnico terminal y mapeador de disco**.
- **Regla técnica nueva:** un `.md` abierto en **Word** bloquea la escritura (`EPERM` /
  `Device or resource busy`). Pasó con este mismo archivo. De ahí el corolario que quedó
  escrito: **el contenido se redacta primero en el scratchpad y después se copia**, así un
  bloqueo cuesta un `cp` y no volver a redactar.

---

## 3. Estado real de la estructura

### El Dual-Track en disco, de un vistazo

```
VÍA 1 — OPERACIÓN (papeles, Drive)        VÍA 2 — DESTILACIÓN (motor, C:)
G:\Mi unidad\ESTUDIO JURIDICO NOESIS\     C:\Noesis\01_cerebro\skills\<área>\
├── 0_ENTRADA\          ← material crudo  ├── SKILL.md      ← razonamiento
├── 01_Casos_Activos\   ← 9 casos vivos   ├── references\   ← fichas con pinpoint
│     (se trabaja en Cowork)              ├── scripts\      ← cálculo determinístico
└── 02_Casos_Archivados\ ← vacía          └── modelos\      ← plantillas (NUEVO, vacío)
        ↑                                         ↑
        └──── el Post-Mortem cruza de una vía a la otra ────┘
              (PROTOCOLO.md §14 — antes de archivar)
```

Las tres skills de área tienen la misma anatomía. Hay además **una skill de caso** con
prefijo `caso-`: fuera de git por patrón, no participa de esto y no se nombra acá (P10).

### Los repositorios: cinco, cada uno con dueño y remoto

| Carpeta | Repo en GitHub (privado) | Estado al cierre |
|---|---|---|
| `C:\Noesis\00_sistema` | `noesis-sistema` | sincronizado este cierre |
| `C:\Noesis\00_nucleo` | `noesis` | sin tocar en esta jornada |
| `C:\Noesis\01_cerebro` | `noesis-legal` | **tocado y SIN commitear — ver §4.1** |
| `C:\Noesis\10_ingesta` | `noesis-ingesta` | sincronizado en el bloque A |
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
El `CLAUDE.md` global con la sección Dual-Track ya quedó respaldado en esta sesión.

---

## 4. Pendientes, en orden

### 4.1 Inmediato — queda de esta sesión

1. **Commitear `01_cerebro`** (`noesis-legal`): las tres carpetas `modelos\` con sus
   `LEEME.md`. No se hizo acá porque es otro repo y otro tema (regla 1: una sesión, un
   tema). Verificar anonimato primero — los tres `LEEME.md` no nombran ningún caso, pero
   se chequea igual (regla 7).
2. **Ratificar `modelos\` en `MEICL-v2.md`.** Hoy la forma del archivo (frontmatter de
   madurez, variables `{{ASI}}`) vive en `skills\concursos-ar\modelos\LEEME.md`, que hace
   de referencia provisoria. Su dueño definitivo es el estándar (regla 3). Sesión de
   `01_cerebro`.

### 4.2 Inmediato — un clic de MJM cada uno

3. **Instalar las cuatro extensiones de Chrome** desde los links de
   `NOESIS_CHROME_STACK.md` (Extensity · PageMarkdown · SingleFile · JSON Formatter).
   Claude no instala extensiones: el clic es de MJM.
4. **Probar el MCP en una sesión nueva** de Claude Code: pedirle que navegue a una
   página y la resuma. Si conecta y navega, la capa queda estrenada.

### 4.3 El primer Post-Mortem — la prueba real del Dual-Track

5. **Estrenar `destilar_caso` con el primer caso que cierre.** Hay 9 casos activos en
   Drive y `02_Casos_Archivados` está vacía: ninguno pasó todavía por el paso nuevo.
   Hasta que uno lo haga, la regla 14 es doctrina sin rodaje —y `modelos\` sigue vacía.
   **Este es el pendiente que desbloquea todo lo demás de la Vía 2.**

### 4.4 Fase 2

6. **Panel dominical**: unir `panel.py` con los vencimientos (salen de `_PRIVADO`)
   y programarlo para el domingo a la tarde.
7. **Etapa 03 VALIDADO de la ingesta**: definir qué significa validar. Criterio de MJM.
8. **Jubilar los circuitos viejos de conversión**: `99_experimentos\marker_pdfs` y
   `Downloads\Noesis`.
9. **Cotejar las cuatro carpetas duplicadas** Escritorio ↔ Drive. Drive manda.
   Detalle fuera del repo, en `_local_pendientes.md`.
10. **Ficha del adaptador de Marker** (constitución §8). Ahora también la pide
    trafilatura si se consolida como pieza estructural.
11. **Revisar el prototipo `LEGALENGINE-CONCURSOS-QUIEBRAS`** — contenido jurídico:
    sesión de `01_cerebro`, no acá.
12. **Confirmar el circuito de ideación** (proyecto de claude.ai con este HANDOFF
    pegado) la próxima vez que se use.

### 4.5 Fase 3

13. **MCP local propio en Python para cálculos determinísticos** (liquidar, intereses,
    plazos). Antes de la primera línea: definir dueño (`00_sistema` o `01_cerebro`) y
    declararlo en `SISTEMA.md`. Local, sin nube, sin placa de video.
14. **Renombrar `99_experimentos`** — el día que haya que tocar Marker por otro motivo.

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
| **Code ejecuta y mapea, no idea** (2026-08-19) | sin objetivo + rutas exactas + criterio de validación, el pedido no tiene forma de terminar: es la sesión de 939 turnos vista desde su causa |
| **El Modo Piloto no necesita directiva** (2026-08-19) | leer disco, `git status`, `claude mcp list` y proponer el próximo paso no construyen nada; la compuerta cierra la puerta de escribir, no la de mirar |
| **Los `.md` se redactan en el scratchpad y se copian** (2026-08-19) | Word los bloquea en exclusiva; así un bloqueo cuesta un `cp` y no volver a redactar |

---

## 6. Cómo arranca la próxima sesión

Abrir la carpeta según el tema (`C:\Noesis\00_sistema` para seguir con esto, o
`C:\Noesis\01_cerebro` para los dos pendientes de §4.1), leer este archivo, y si es la
primera sesión después de este cierre: commitear `01_cerebro` (§4.1) y los dos clics de
§4.2.

Al cerrar, el cierre de cinco pasos que es uno solo (regla 10): verificar anonimato →
**commitear y hacer `push` sin que haga falta pedirlo** → informar el costo
(`python costo.py`) → sumar a `PROTOCOLO.md` la regla que haya dejado la sesión →
**reescribir este archivo** y entregarlo por chat como adjunto (regla 11).

_Escrito el 2026-08-19 al cierre de la sesión que instaló el modelo Dual-Track._
