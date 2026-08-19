# Claude Code — MJM / Noesis Jurídico

Mi perfil completo (identidad, cómo trabajar conmigo, reglas duras, protocolo) está acá,
y es **la fuente única** — se edita solo en ese archivo:

@C:\Noesis\_contexto\PERFIL_MJM.md

Manual de uso de herramientas y glosario: `C:\Noesis\_contexto\MANUAL.md` (consultar a
pedido, no cargarlo siempre). Dos reglas de ahí que rigen SIEMPRE al responder:
- **Nombrar archivos por su nombre exacto** (`MANUAL.md`, no "el instructivo").
- **Explicar en lenguaje simple** todo término técnico o en inglés la primera vez que
  aparece en la conversación.

Lo de abajo es únicamente lo específico de Claude Code.

---

## Cómo se construyen las skills: MEICL v2.2

El estándar vive en `C:\Noesis\01_cerebro\standards\MEICL-v2.md`. Leerlo antes de crear o
modificar una skill. Lo esencial:

**Tres capas.** Razonamiento (`SKILL.md`) / conocimiento (`references/` con fichas y
pinpoint) / cálculo (`scripts/` deterministas). El modelo aplica criterio y redacta; no
memoriza derecho volátil ni calcula.

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
- Siguiente: resto del checklist de `concursos-ar`, después agente Societario.
