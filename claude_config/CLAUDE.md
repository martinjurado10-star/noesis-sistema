# Claude Code — MJM / Noesis Jurídico

Mi perfil completo (identidad, cómo trabajar conmigo, reglas duras, protocolo) está acá,
y es **la fuente única** — se edita solo en ese archivo:

@C:\Noesis\00_sistema\_PRIVADO\PERFIL_MJM.md

Vive en `C:` y no en Drive por la regla de oro: **`G:` = papeles, `C:\Noesis` = motor.**
El perfil son instrucciones, no un papel. Desde `G:` no cargaba cuando Drive estaba
desmontado — pasó el 2026-08-19 y Claude arrancó sin saber quién es MJM.

Manual de uso de herramientas y glosario: `C:\Noesis\_contexto\MANUAL.md` (consultar a
pedido, no cargarlo siempre). Dos reglas de ahí que rigen SIEMPRE al responder:
- **Nombrar archivos por su nombre exacto** (`MANUAL.md`, no "el instructivo").
- **Explicar en lenguaje simple** todo término técnico o en inglés la primera vez que
  aparece en la conversación.

Lo de abajo es únicamente lo específico de Claude Code.

---

## Compuerta de entrada: Code ejecuta y mapea, no idea (2026-08-19)

**Claude Code es un ejecutor técnico terminal y un mapeador de disco.** No es mesa de
ideación conceptual ni consultorio jurídico abstracto. Un pedido de construcción entra
sólo si trae las tres cosas: **objetivo funcional** · **restricciones y límites (rutas
exactas)** · **criterio de validación**.

Se aborta —**antes de escribir una sola línea de código o crear un archivo**— ante: una
consulta jurídica abstracta o debate doctrinario · una lluvia de ideas o propuesta
arquitectónica sin esquema resuelto · una skill o agente pedido "por si acaso", sin caso
real de origen · una instrucción ambigua, sin rutas explícitas ni criterio de prueba. La
respuesta es exactamente ésta, sin agregar nada:

```
Pedido no maduro para ejecución técnica (falta objetivo, rutas o criterio de validación).
Por favor derivar a la Mesa de Diseño (Chat Noesis) o estructurar sobre un caso activo en G:\
```

**Excepción — Modo Piloto.** Sin directiva previa y siempre permitido, porque es de sola
lectura y no altera el disco: **inspección de estado** (`git status`, `git diff`,
`git log`) · **mapeo de herramientas** (`claude mcp list`) · **exploración de directorios
y lectura de archivos** · **reportar estado y proponer el siguiente paso del
`HANDOFF.md`**. La compuerta cierra la puerta de **escribir**, no la de **mirar y
orientar**.

**El otro límite:** las dos líneas son para lo que **no se puede ejecutar**, no para lo
que **se puede ejecutar distinto**. Si el pedido es ejecutable pero su topología choca con
lo que ya hay en disco, corresponde el mapeo pieza por pieza y después ejecutar lo que
falta — no el rechazo. Detalle en `00_sistema\PROTOCOLO.md` §15.

### Límites físicos que no se negocian en ninguna sesión

| Límite | En una línea |
|---|---|
| **Casos y expedientes** | viven **sólo** en `G:\...`; prohibido crear o mover carpetas de casos a `C:\` |
| **Skills y agentes** | único contenedor: `C:\Noesis\01_cerebro\skills\` (junction desde `~/.claude/skills`). Prohibido crear `skills\`, `agents\` o `knowledge\` en la raíz de `C:\` |
| **Anti-bloqueo (`EPERM`)** | contenido pesado se redacta en el scratchpad y **después** se copia a disco (Word bloquea los `.md`) |
| **Anonimato estricto** | jamás commitear datos de clientes a un repo — se verifica **antes**, no después |

---

## Cómo se construyen las skills: MEICL v2.2

El estándar vive en `C:\Noesis\01_cerebro\standards\MEICL-v2.md`. Leerlo antes de crear o
modificar una skill. Lo esencial:

**Tres capas.** Razonamiento (`SKILL.md`) / conocimiento (`references/` con fichas y
pinpoint) / cálculo (`scripts/` deterministas). El modelo aplica criterio y redacta; no
memoriza derecho volátil ni calcula.

**Cuarta pieza: `modelos/`** (desde 2026-08-19) — plantillas de escritos ya presentados,
parametrizadas y sin datos de cliente. Entra por destilación, nunca redactada en abstracto.
Forma del archivo en `skills\concursos-ar\modelos\LEEME.md`; pendiente ratificarla en
`MEICL-v2.md`.

**Escalera de madurez.** Toda pieza nace en `borrador` y sube usándose:
`borrador → estrenada (1 caso real) → rodada (3+) → consolidada`.
La validación no es un paso aparte: **el caso facturable es el evento de validación**.

- Una ficha en `borrador` **sí puede usarse en un caso real** — lo que la hace segura no es
  el nivel sino que todo dato de fuente lleve pinpoint o `[a verificar]`.
- Los **valores volátiles nunca suben de nivel 0**: runtime siempre.
- **Nada sube de nivel por su origen.** Un plugin, un repo ajeno o un autor de prestigio
  entran en `borrador` como cualquier ficha. **El prestigio del autor no es un pinpoint.**

**Compuerta según origen.** Un dato contrastable contra fuente oficial se valida cotejando
el pinpoint (segundos). El **criterio** —qué se omite, qué riesgo se toma— conserva
compuerta plena de MJM y no tiene atajo.

---

## Dual-track: nada abstracto (2026-08-19)

**No abstract agent design without case-driven distillation.** Ninguna skill, ficha,
modelo, script ni agente temático se crea "porque haría falta". Toda pieza nace como
solución a una tarea concreta de un caso real y **después** se empaqueta. Si Claude
propone construir una estructura para un área sin casos detrás, la respuesta ya está dada:
no. Una carpeta de área vacía sólo genera la ilusión de que el área existe.

**Las dos vías, y dónde vive cada una:**

| Vía 1 — Operación | Vía 2 — Destilación |
|---|---|
| resolver el caso que factura | convertir lo resuelto en pieza reutilizable |
| `G:\...\01_Casos_Activos\<caso>\` | `C:\Noesis\01_cerebro\skills\<área>\` |
| **Cowork** (escritos) · NotebookLM | **Claude Code**, sesión de `01_cerebro` |

**`nuevo_caso <id>`** — abrir. Carpeta en `G:\...\01_Casos_Activos\<id>\`; el material
crudo entra por el buzón `G:\...\0_ENTRADA`, que la ingesta convierte a `.md`. **No se
crea nada en `C:\Noesis`** — papeles a `G:`, motor en `C:`.

**`destilar_caso <id>`** — cerrar. Sesión en `01_cerebro`, las cinco preguntas del
Post-Mortem (`00_sistema\PROTOCOLO.md` §14), la madurez de cada pieza sube un escalón, y
recién ahí el caso pasa a `02_Casos_Archivados`. **Ningún caso se archiva sin destilar.**

---

## Anonimato por diseño (P10)

**Todo lo versionado debe poder publicarse sin anonimizar nada.**

- Skills de **área** (anónimas) → versionadas. Skills de **caso** → prefijo `caso-`,
  excluidas por patrón en `.gitignore`. Nunca salen de la máquina.
- Si una pieza necesita anonimizarse antes de subir, **estaba en el lugar equivocado**.
- Al marketplace solo va material anonimizado y reutilizable.
- Antes de commitear en `01_cerebro`: verificar que no haya nombres de clientes,
  expedientes ni matrículas.

---

## El repo manda (anti-bifurcación)

Las skills pueden existir en dos lugares que **no se sincronizan**: claude.ai / Cowork
(sin versionado) y `01_cerebro\skills\` (git).

- **La fuente de verdad es el repo.** claude.ai es borrador.
- Cuando algo se estabiliza allá, baja al repo y la copia de la nube se deja morir.
- Si hay divergencia, **avisar antes de escribir** — no fusionar por cuenta propia.

`~/.claude/skills` es un *junction* a `01_cerebro\skills`. Al renombrar carpetas hay que
rehacerlo: `cmd /c rmdir` y después `mklink /J` (`Remove-Item` no puede en modo no interactivo).

---

## Fuentes verificadas (2026-08-14)

✅ **InfoLEG** (leyes + notas de reforma) · **SAIJ** (jurisprudencia, sumarios, doctrina) ·
**Boletín Oficial** (por fecha) · **datos.gob.ar** (API CKAN, sin claves)

⚠ CSJN/CIJ: viva, detrás de redirects · IGJ: la URL probada dio 404 · universidades y
colegios: **sin verificar, no citar** · La Ley / elDial: de pago, fuera de alcance.

**Alcanzar la fuente ≠ que esté al día.** Fecha de captura en toda ficha.

---

## Estado (2026-08-14)

- `01_cerebro` publicado en GitHub como **repo privado** `martinjurado10-star/noesis-legal`.
- Skills de área: `concursos-ar`, `liquidar-ar` (patrón completo con motor),
  `revision-contratos-ar`. Una skill de caso, local y fuera de git.
- **Pendiente de MJM:** confirmar la discrepancia del art. 32 LCQ — la ficha dice
  "quirografarios < 3 SMVM" y la ley no distingue categoría. Ver
  `skills/concursos-ar/references/arancel_art32.md`.
- Las tres skills de área tienen `modelos/` creada y vacía (2026-08-19). Se llena por
  destilación, con el primer caso que cierre.
- Siguiente: resto del checklist de `concursos-ar`. **El agente Societario no se arma
  hasta que haya casos societarios cerrados que lo pidan** — regla dual-track.
