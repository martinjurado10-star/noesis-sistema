# HANDOFF — dónde estamos

Cierre de la jornada del **2026-08-18**.

**Para qué sirve este archivo.** Una sesión nueva de Claude Code, sin historial, se lee
esto primero y sabe exactamente dónde está parado el sistema: qué se hizo, qué hay en
disco, qué falta y en qué orden, y qué ya se decidió y no se vuelve a discutir.

**Lugar en la pila de documentos de esta carpeta** (regla 3: un solo dueño por cosa):

| Archivo | Qué gobierna | Cuándo se lee |
|---|---|---|
| `SISTEMA.md` | el diseño: qué hay instalado y por qué | antes de instalar o cambiar algo |
| `PROTOCOLO.md` | cómo se trabaja con Claude acá | ante dudas de flujo |
| `INVENTARIO.md` | la foto de la máquina medida el 2026-08-18 | para cotejar diseño contra realidad |
| **`HANDOFF.md`** (este) | **dónde quedamos** | **al abrir una sesión nueva** |

Este archivo se pisa a sí mismo: lo reescribe la sesión que cierra. No acumula historia
—esa está en los commits— sino el estado presente.

---

## 1. Conclusión primero

La máquina está sana y el diseño está escrito. **La Fase 1 se cerró casi entera en esta
misma sesión**: el respaldo de `~/.claude`, la contradicción de Office en `SISTEMA.md`,
las siete carpetas vacías, y el commit de todo lo anterior. **Queda un solo paso
manual**: subir ese commit a GitHub — el `push` lo bloqueó el modo automático de la
sesión. Después de eso, lo que sigue es la Fase 2.

---

## 2. Qué se hizo en esta jornada

Reconstruido de los commits y del disco, en orden.

**El gasto — lo más importante que se aprendió.** Se midió de dónde sale la plata y
resultó que no sale del trabajo: sale del **piso** (todo lo que se carga antes de que MJM
escriba una palabra, y se relee en cada turno) y de los **turnos** (una sesión larga
relee todo lo anterior cada vez). El piso era de **70.458 fichas y sólo el 6% era de
MJM**; el resto, catálogos de plugins que nunca se usan. MJM desconectó lo innecesario y
**el piso bajó a ~54.500**: unas 16.000 fichas menos en cada turno de cada sesión, para
siempre, sin perder ninguna herramienta que se use. Quedó como **regla 9** de
`PROTOCOLO.md`, con el diagnóstico adentro del propio medidor (`python costo.py --piso`).

**`10_ingesta` pasó a tener repo propio** (`noesis-ingesta`, privado). Se la encontró con
seis commits y **sin remoto**, mientras `SISTEMA.md` la daba por no versionada: las dos
mitades estaban mal. De ahí salió la **regla 8 — versionado no es respaldado**: un repo
sin remoto se muere con el disco.

**Auditoría de la configuración de Claude Code** contra las prácticas recomendadas: 9 de
10 en orden. El único hueco real —ninguna carpeta de proyecto tenía su propio
`CLAUDE.md`— se cerró creando `CLAUDE.md` en `00_sistema`, que nombra a `SISTEMA.md` y
`PROTOCOLO.md` **sin `@import`**, para no pagar 24 KB de carga en cada sesión que no los
usa.

**El panel creció** (`panel.py` → `panel.html`): ahora muestra el mapa de carpetas con su
dueño, las carpetas sueltas que no están declaradas, las skills locales y el marketplace.
Ese mapa fue el que **detectó las siete carpetas vacías** que hoy son pendiente.

**Se frenó un plan que venía de otra IA.** Proponía una carpeta `C:\dev` con un repo
`infra` y arrancaba mandando abrir un archivo que **no existe en esta máquina**. Era una
arquitectura paralela a la que ya funciona. Se rechazó entero salvo **un punto, que sí
era cierto y quedó como pendiente: `~/.claude` no está respaldada en ningún lado.**

**`INVENTARIO.md`**: la foto real de la máquina contra el diseño. Los once programas
declarados están instalados, las siete piezas propias también, la lista de prohibidos da
limpio (**Adobe Creative Cloud y TeamViewer ya salieron**) y por primera vez está el
**mapa de los cinco repos**.

**Se rechazó instalar Copilot** (`winget install GitHub.Copilot`), que GitHub ofrece al
crear un repo: duplica a Claude y está en la tabla de Prohibidos.

**Quedó interrumpida** la revisión del prototipo `LEGALENGINE-CONCURSOS-QUIEBRAS` — ver
Fase 2, punto 10.

**Y de cerrar esta jornada salió la regla 10 de `PROTOCOLO.md`**: el handoff se escribe
antes de cerrar. Reconstruir esta sesión desde los commits, el disco y los registros del
día funcionó, pero se pagó dos veces —una al hacer el trabajo y otra al averiguar qué se
había hecho—. Escribirlo cuesta una vez.

**Después de escrito este archivo, la misma sesión siguió y cerró el resto de la Fase 1:**

- **Se sacó Office de la tabla de Prohibidos de `SISTEMA.md`.** Se contradecía con la
  regla operativa, que ya lo permitía desde el día anterior. Quedó una nota corta donde
  estaba la fila, apuntando a dónde vive la decisión real, y una fila nueva en el
  Historial de decisiones.
- **Las siete carpetas vacías se borraron**, con decisión explícita de MJM. Se verificó
  antes contra el código real de `10_ingesta\noesis_ingesta.py`: ninguna estaba vigilada
  ni referenciada — eran resto de un diseño por carpetas ya reemplazado por "las etapas
  son estados, no carpetas". El panel (`carpetas_sueltas()`) confirma disco limpio: solo
  queda `_biblioteca`, que es el enlace a Drive y está bien que esté.
- **De paso, se encontró y se cerró un pendiente que ya estaba resuelto pero `SISTEMA.md`
  no lo sabía**: Adobe Creative Cloud y TeamViewer, que `INVENTARIO.md` ya daba por
  desinstalados. Y se agregó `__pycache__/` a `.gitignore`, que no estaba cubierto y
  ensuciaba el `git status`.
- **`~/.claude` se respaldó — y resultó ser más chico de lo que se pensaba.** De las
  ocho cosas que tiene adentro, sólo dos eran configuración hecha a mano:
  `settings.json` y el `CLAUDE.md` global. El resto es cache que se regenera sola, o —
  `projects`/`sessions`— son las transcripciones completas de las conversaciones, con
  nombres de clientes adentro: nunca debían respaldarse enteras, P10 lo prohíbe. Se
  copiaron los dos archivos reales a `claude_config\` dentro de `00_sistema` (viaja con
  el mismo repo), con `respaldar_claude.ps1` para resincronizar cuando cambien y
  `claude_config\LEEME.md` con el detalle y los pasos para restaurar en una máquina
  nueva.

Con esto, la Fase 1 quedó completa salvo el commit, que se hizo al cierre de esta misma
sesión — ver el estado de repos en §3 y el historial de decisiones de `SISTEMA.md`.

---

## 3. Estado real de la estructura

### Los repositorios: cinco, cada uno con dueño y remoto

Verificado al cierre de esta jornada.

| Carpeta | Repo en GitHub (privado) | Sin commitear |
|---|---|---|
| `C:\Noesis\00_sistema` | `noesis-sistema` | **0, pero 1 commit adelante de `origin/main`** — falta el `push`, ver Fase 1 punto 1 |
| `C:\Noesis\00_nucleo` | `noesis` | 0, sincronizado |
| `C:\Noesis\01_cerebro` | `noesis-legal` | 0, sincronizado |
| `C:\Noesis\10_ingesta` | `noesis-ingesta` | 0, sincronizado |
| `C:\Users\M01\Documents\GitHub\LEGALENGINE-CONCURSOS-QUIEBRAS` | mismo nombre | prototipo, sin revisar |

Los cinco tienen remoto. **Ninguno está en un solo lugar.**

### Lo que a propósito no se versiona

| Carpeta | Por qué |
|---|---|
| `C:\Noesis` (raíz) | tiene adentro los enlaces `_biblioteca` y `_contexto`, que apuntan a papeles de clientes en Drive |
| `00_sistema\_PRIVADO\` | nombres de expedientes; excluida por `.gitignore` |
| `99_experimentos` | motores pesados, varios GB. **Sin declarar por qué** — deuda menor |
| `02_marketplace` | un archivo, sin dueño declarado todavía |

### `~/.claude` — resuelto en este mismo cierre

De las ocho cosas que hay adentro de `C:\Users\M01\.claude`, sólo dos eran configuración
hecha a mano y no se regeneraban solas: `settings.json` y el `CLAUDE.md` global. El resto
—`plugins`, `session-env`, `shell-snapshots`— es cache que se regenera sola, y
`projects`/`sessions` son las **transcripciones completas de las conversaciones**, con
nombres de clientes adentro: exactamente lo que P10 prohíbe versionar. Nunca debían
respaldarse enteras.

Se copiaron los dos archivos reales a `claude_config\` (adentro de `00_sistema`, así que
viaja con el mismo repo), con `respaldar_claude.ps1` para resincronizar cuando cambien.
El detalle completo —qué entra, qué no y cómo restaurar en una máquina nueva— está en
`claude_config\LEEME.md`. El *junction* de `skills` no hacía falta respaldarlo: ya
apunta a `01_cerebro\skills`, que tiene repo propio.

### Las carpetas de `C:\Noesis`

Con dueño y contenido: `00_sistema` · `00_nucleo` · `01_cerebro` · `10_ingesta` ·
`99_experimentos` · `02_marketplace` (un archivo) · los enlaces `_biblioteca` y
`_contexto`.

Las siete que estaban vacías y sin dueño (`00_inbox`, `05_audio`, `10_fuentes_md`,
`20_fichas`, `30_patrones`, `99_procesados`, `_logs`) **se borraron el 2026-08-18**:
ninguna estaba vigilada por `10_ingesta` ni referenciada en código. Ver §5.

---

## 4. Pendientes, en orden

Las fases de acá abajo son **del sistema**, no las del plan maestro jurídico
(`G:\Mi unidad\ESTUDIO JURIDICO NOESIS\04_Contexto\NOESIS_plan_maestro.md`, donde Fase 3
es el agente Societario). Son dos numeraciones distintas y no se mezclan.

### Fase 1 — cerrar lo abierto (con esto arranca la próxima sesión)

1. **Subir el commit `b61d6aa` a GitHub.** El commit se hizo — verificado sin nombres de
   cliente antes (regla 7) — pero `git push` lo bloqueó el clasificador de permisos del
   modo automático de esta sesión. **Es el único paso que sigue vivo de toda la Fase 1**
   y hay que correrlo a mano:
   ```bash
   cd C:\Noesis\00_sistema && git push origin main
   ```
   Hasta que esto corra, `noesis-sistema` está adelantado a `origin/main` — regla 8:
   un commit sin push no es un respaldo real.

~~2. Respaldar `~/.claude`~~ — **resuelto: `claude_config\` con los dos archivos reales,
   nada de secretos ni transcripciones.** Ver §3.

~~3. Sacar la fila de Office de la tabla de Prohibidos de `SISTEMA.md`~~ — **resuelto.**

~~4. Decidir las siete carpetas vacías~~ — **resuelto: se borraron las siete.**

**La Fase 1 completa queda en un solo paso: commitear (punto 1).**

### Fase 2 — lo que sigue

5. **Panel dominical**: unir `panel.py` con los vencimientos —que salen de `_PRIVADO`
   porque llevan nombres de expedientes— y programarlo para el domingo a la tarde.
   Los vencimientos que *alertan* siguen siendo de Google Calendar; el panel *planea*.

6. **Etapa 03 VALIDADO de la ingesta**: hoy 31 archivos dicen `sin_validar` y no hay nada
   que lo cambie. Falta definir qué significa validar. Es criterio de MJM.

7. **Jubilar los circuitos viejos de conversión**: `99_experimentos\marker_pdfs` y
   `Downloads\Noesis`. `10_ingesta` es el único dueño de papeles a texto.

8. **Cotejar las cuatro carpetas de trabajo duplicadas** entre Escritorio y Drive
   (distinta cantidad de archivos y distinta fecha en cada lado). Drive manda. El detalle
   con nombres está fuera del repo, en `_local_pendientes.md`.

9. **Ficha del adaptador de Marker**: pasó a ser pieza estructural y la constitución (§8)
   la exige.

10. **Revisar el prototipo `LEGALENGINE-CONCURSOS-QUIEBRAS`** y quedarse sólo con la
    lógica que sirva (tiene metadatos de una legaltech anterior, que se ignoran). **Ojo:
    eso es contenido jurídico** → se trabaja en una sesión de `C:\Noesis\01_cerebro`,
    no acá.

### Fase 3 — más adelante

11. **MCP local propio en Python para cálculos determinísticos.**

    *Qué es un MCP:* Model Context Protocol, la forma estándar de conectarle a Claude una
    herramienta propia. *Determinístico* quiere decir que con los mismos datos da siempre
    exactamente el mismo número, sin margen de interpretación.

    *Qué sería acá:* un programa en Python corriendo en **esta** máquina, que Claude llama
    como herramienta fija para liquidar, computar intereses y contar plazos — y devuelve
    el número **calculado**, no estimado. Hoy eso vive en scripts que hay que invocar a
    mano cada vez.

    *Antes de escribir la primera línea, dos cosas:*
    - **Definir el dueño** (regla 3). Si es infraestructura, es de `00_sistema`; si es
      motor jurídico, es de `01_cerebro`. Decisión de MJM: sin eso, nace con dos dueños.
    - **Declararlo en `SISTEMA.md`** antes de instalarlo, como todo lo demás.

    *No negociable:* local, sin nube, sin placa de video (el hardware manda).

12. **Renombrar `99_experimentos`** — el nombre miente, ahí viven los motores. Se hace
    **el día que haya que tocar Marker por otro motivo**, porque el entorno de Python que
    tiene adentro guarda rutas absolutas y renombrarlo obliga a reinstalar varios GB.

---

## 5. Decisiones tomadas — no se discuten de nuevo

Si una sesión nueva propone lo contrario de algo de esta lista, la respuesta ya está dada.

| Decisión | Por qué, en una línea |
|---|---|
| **Cero nube de Microsoft. Office de escritorio sí** | el problema nunca fue Word, fue OneDrive — y OneDrive está bloqueado por política |
| **La sesión de Windows sigue siendo cuenta local** | entrar con cuenta Microsoft reactiva OneDrive. Windows está activado con licencia OEM, no depende de ninguna cuenta |
| **Un repo por componente. Nada de `C:\dev` ni repo `infra`** | los repos viven junto a lo que versionan. Una segunda carpeta de repos es el doble dueño que prohíbe el principio rector |
| **`C:\Noesis` raíz no se versiona** | contiene enlaces a papeles de clientes: un repo ahí pone el anonimato a un descuido de distancia |
| **`99_experimentos` no se renombra todavía** | rompe Marker y obliga a rebajar varios GB. Se hace cuando haya que tocarlo igual |
| **Docling descartado; Marker sólo a pedido** | medido: Docling falló dos veces, Marker tardó 14 min en una página. Tesseract hace lo mismo en 5,4 s |
| **Copilot no se instala** | duplica a Claude, aunque GitHub lo ofrezca al crear un repo |
| **Las etapas de la ingesta son estados, no carpetas** | si fueran carpetas, el mismo documento viviría en tres lugares a la vez |
| **El panel es semanal, sin IA y sin costo** | `panel.html` se pisa a sí mismo y no se versiona: el repo guarda el generador, no el resultado |
| **Nada de cliente en lo versionado** | nombre, expediente o matrícula → `_PRIVADO\` o skill con prefijo `caso-`. Se verifica **antes** de commitear |
| **Una sesión, un tema; la carpeta lo declara** | `tema_sesion.py` lo lee al arrancar. Se cierra la sesión cuando el tema termina |
| **`CLAUDE.md` de `00_sistema` nombra, no importa** | un `@import` carga 24 KB en cada sesión aunque no se usen. Nombrarlo tiene la misma fricción y cuesta cero |
| **La credencial la pone MJM** | Claude deja todo listo hasta la puerta; el clic y la contraseña son de MJM |
| **Lo que llega de otra IA entra como borrador** | se contrasta contra el disco antes de ejecutar nada. El plan de `C:\dev` mandaba abrir un archivo inexistente |

---

## 6. Cómo arranca la próxima sesión

Abrir la carpeta según el tema (`C:\Noesis\00_sistema` para seguir con esto), leer este
archivo y, si la sesión toca código, chequear los cuatro repos antes de cerrar:

```bash
for d in 00_nucleo 00_sistema 01_cerebro 10_ingesta; do cd "/c/Noesis/$d" && echo "$d: $(git remote | head -1 || echo SIN-REMOTO) $(git status -sb | head -1)"; done
```

Lo que se busca ahí es `SIN-REMOTO` o `ahead`: las dos formas de tener trabajo que existe
en un solo lugar.

Y al cerrar, los tres pasos que son uno solo (regla 10): informar el costo
(`python costo.py`), sumar a `PROTOCOLO.md` la regla que haya dejado la sesión, y
**reescribir este archivo**.

_Escrito el 2026-08-18. Reconstruido de los commits, del disco y de las sesiones del día._
