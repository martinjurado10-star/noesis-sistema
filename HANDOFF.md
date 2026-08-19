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
| **`HANDOFF.md`** (este) | **dónde quedamos** | **al abrir una sesión nueva — y en el proyecto de claude.ai donde se idea (regla 11)** |

Este archivo se pisa a sí mismo: lo reescribe la sesión que cierra. No acumula historia
—esa está en los commits— sino el estado presente.

---

## 1. Conclusión primero

**La Fase 1 completa está cerrada y en GitHub.** `noesis-sistema` sincronizado, sin nada
pendiente de commitear ni de subir. Lo que sigue es la Fase 2 (abajo, §4). Y de esta
sesión salió un circuito nuevo: **cómo llevar el estado del sistema a un lugar donde
pensar sin estar en Code** — ver §5, es la primera vez que se prueba.

---

## 2. Qué se hizo en esta jornada

Reconstruido de los commits y del disco, en orden. Los puntos nuevos de hoy están al
final.

**El gasto — lo más importante que se aprendió.** Se midió de dónde sale la plata y
resultó que no sale del trabajo: sale del **piso** (todo lo que se carga antes de que MJM
escriba una palabra, y se relee en cada turno) y de los **turnos** (una sesión larga
relee todo lo anterior cada vez). El piso era de **70.458 fichas y sólo el 6% era de
MJM**; el resto, catálogos de plugins que nunca se usan. MJM desconectó lo innecesario y
**el piso bajó a ~54.500**: unas 16.000 fichas menos en cada turno de cada sesión, para
siempre, sin perder ninguna herramienta que se use. Quedó como **regla 9** de
`PROTOCOLO.md`.

**`10_ingesta` pasó a tener repo propio** (`noesis-ingesta`, privado). Se la encontró con
seis commits y **sin remoto**, mientras `SISTEMA.md` la daba por no versionada. De ahí
salió la **regla 8 — versionado no es respaldado**: un repo sin remoto se muere con el
disco.

**Auditoría de la configuración de Claude Code**: 9 de 10 en orden. El único hueco
—ninguna carpeta de proyecto tenía su propio `CLAUDE.md`— se cerró creando el `CLAUDE.md`
de `00_sistema`, que nombra a `SISTEMA.md` y `PROTOCOLO.md` sin `@import`.

**El panel creció** (`panel.py` → `panel.html`): mapa de carpetas con dueño, carpetas
sueltas, skills locales y marketplace. Ese mapa detectó las siete carpetas vacías de
más abajo.

**Se frenó un plan que venía de otra IA**, que proponía `C:\dev` y un repo `infra` —
arquitectura paralela a la que ya funciona, y mandaba abrir un archivo que no existe en
esta máquina. Rechazado entero salvo un punto real: el respaldo de `~/.claude`.

**`INVENTARIO.md`**: la foto real de la máquina. Once programas y siete piezas propias
instalados, prohibidos limpio, y el mapa de los cinco repos por primera vez.

**Se rechazó instalar Copilot** cuando GitHub lo ofreció al crear un repo.

**Cierre de la Fase 1** (ya en el commit `39f20f5` y sucesivos):

- **Office salió de la tabla de Prohibidos de `SISTEMA.md`** — se contradecía con la
  regla operativa, que ya lo permitía desde el día anterior.
- **Las siete carpetas vacías se borraron** (`00_inbox`, `05_audio`, `10_fuentes_md`,
  `20_fichas`, `30_patrones`, `99_procesados`, `_logs`), verificado antes contra
  `10_ingesta\noesis_ingesta.py`: ninguna estaba vigilada ni referenciada — resto de un
  diseño por carpetas ya reemplazado por "las etapas son estados, no carpetas".
- **`~/.claude` se respaldó**, y resultó ser más chico de lo que se pensaba: de ocho
  cosas adentro, sólo `settings.json` y el `CLAUDE.md` global eran configuración hecha a
  mano. El resto es cache que se regenera sola, o —`projects`/`sessions`— son las
  transcripciones completas de las conversaciones, con nombres de clientes: nunca debían
  respaldarse enteras, P10 lo prohíbe. Quedó en `claude_config\`, con
  `respaldar_claude.ps1` para resincronizar y `claude_config\LEEME.md` con el detalle.
- De paso, se cerró un pendiente que ya estaba resuelto pero `SISTEMA.md` no lo sabía
  (Adobe/TeamViewer), y se agregó `__pycache__/` a `.gitignore`.
- **Regla 10 de `PROTOCOLO.md`**: el handoff se escribe antes de cerrar.

**Lo nuevo de este tramo — el circuito de dónde se idea:**

MJM tenía un proyecto de **Cowork** para pensar comandos de `00_sistema` y traerlos acá.
No funcionaba: Cowork no tiene forma técnica de leer `C:\Noesis` (no es Drive, no es un
archivo subido, no es un repo conectado), y además —esto ya estaba decidido en
`SISTEMA.md`— Cowork es para producir escritos de un caso, no para tocar la máquina.

La solución no es darle acceso a Cowork: es usar un **proyecto normal de claude.ai** para
pensar (el rol que `SISTEMA.md` ya le da a Chat), y mantenerlo al día pegando este mismo
`HANDOFF.md` cada vez que se cierra una sesión acá. Quedó como **regla 11** de
`PROTOCOLO.md`, con los pasos concretos: al cerrar, el archivo ya está escrito en su ruta
fija y además se entrega por chat como adjunto; en el proyecto, se borra el HANDOFF
viejo antes de pegar el nuevo (mismo error que costó caro con `stack.json` — dos copias
de la misma verdad); título fijo "HANDOFF" para encontrarlo rápido.

**Esta sesión es la primera vez que se prueba el circuito completo.**

---

## 3. Estado real de la estructura

### Los repositorios: cinco, cada uno con dueño y remoto

Verificado al cierre de esta jornada.

| Carpeta | Repo en GitHub (privado) | Sin commitear | Sincronizado con `origin` |
|---|---|---|---|
| `C:\Noesis\00_sistema` | `noesis-sistema` | 0 | **sí** — `git push` confirmado este cierre |
| `C:\Noesis\00_nucleo` | `noesis` | 0 | sí |
| `C:\Noesis\01_cerebro` | `noesis-legal` | 0 | sí |
| `C:\Noesis\10_ingesta` | `noesis-ingesta` | 0 | sí |
| `C:\Users\M01\Documents\GitHub\LEGALENGINE-CONCURSOS-QUIEBRAS` | mismo nombre | prototipo, sin revisar | — |

Los cinco tienen remoto y ninguno está adelantado. Antes de cerrar cualquier sesión que
toque código, correr:

```bash
for d in 00_nucleo 00_sistema 01_cerebro 10_ingesta; do cd "/c/Noesis/$d" && echo "$d: $(git remote | head -1 || echo SIN-REMOTO) $(git status -sb | head -1)"; done
```

### Lo que a propósito no se versiona

| Carpeta | Por qué |
|---|---|
| `C:\Noesis` (raíz) | tiene adentro los enlaces `_biblioteca` y `_contexto`, que apuntan a papeles de clientes en Drive |
| `00_sistema\_PRIVADO\` | nombres de expedientes; excluida por `.gitignore` |
| `99_experimentos` | motores pesados, varios GB. **Sin declarar por qué** — deuda menor |
| `02_marketplace` | un archivo, sin dueño declarado todavía |

### `~/.claude` — respaldada, con criterio

`claude_config\` (adentro de `00_sistema`) tiene la copia versionada de `settings.json`
y el `CLAUDE.md` global — los dos únicos archivos hechos a mano de las ocho cosas que
viven en `C:\Users\M01\.claude`. El resto es cache que se regenera sola, o
transcripciones con datos de clientes que nunca debían salir de la máquina. Detalle
completo en `claude_config\LEEME.md`.

### Las carpetas de `C:\Noesis`

Con dueño y contenido: `00_sistema` (con `claude_config\` adentro) · `00_nucleo` ·
`01_cerebro` · `10_ingesta` · `99_experimentos` · `02_marketplace` (un archivo) · los
enlaces `_biblioteca` y `_contexto`.

Las siete que estaban vacías y sin dueño se borraron el 2026-08-18. Confirmado con el
panel (`carpetas_sueltas()`): disco limpio, no queda ninguna huérfana.

---

## 4. Pendientes, en orden

Las fases de acá abajo son **del sistema**, no las del plan maestro jurídico
(`G:\Mi unidad\ESTUDIO JURIDICO NOESIS\04_Contexto\NOESIS_plan_maestro.md`, donde Fase 3
es el agente Societario). Son dos numeraciones distintas y no se mezclan.

### Fase 1 — cerrada

Los cuatro puntos que tenía (commitear, respaldar `~/.claude`, Office fuera de
Prohibidos, las siete carpetas vacías) están resueltos y en GitHub. Nada vivo acá.

### Fase 2 — lo que sigue (con esto arranca la próxima sesión de trabajo real)

1. **Panel dominical**: unir `panel.py` con los vencimientos —que salen de `_PRIVADO`
   porque llevan nombres de expedientes— y programarlo para el domingo a la tarde.
   Los vencimientos que *alertan* siguen siendo de Google Calendar; el panel *planea*.

2. **Etapa 03 VALIDADO de la ingesta**: hoy 31 archivos dicen `sin_validar` y no hay nada
   que lo cambie. Falta definir qué significa validar. Es criterio de MJM.

3. **Jubilar los circuitos viejos de conversión**: `99_experimentos\marker_pdfs` y
   `Downloads\Noesis`. `10_ingesta` es el único dueño de papeles a texto.

4. **Cotejar las cuatro carpetas de trabajo duplicadas** entre Escritorio y Drive
   (distinta cantidad de archivos y distinta fecha en cada lado). Drive manda. El detalle
   con nombres está fuera del repo, en `_local_pendientes.md`.

5. **Ficha del adaptador de Marker**: pasó a ser pieza estructural y la constitución (§8)
   la exige.

6. **Revisar el prototipo `LEGALENGINE-CONCURSOS-QUIEBRAS`** y quedarse sólo con la
   lógica que sirva (tiene metadatos de una legaltech anterior, que se ignoran). **Ojo:
   eso es contenido jurídico** → se trabaja en una sesión de `C:\Noesis\01_cerebro`,
   no acá.

7. **Probar de nuevo el circuito del §5** (el proyecto de claude.ai con el HANDOFF
   pegado) la próxima vez que haga falta idear un comando fuera de Code, y confirmar
   que funciona antes de darlo por asentado del todo.

### Fase 3 — más adelante

8. **MCP local propio en Python para cálculos determinísticos.**

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

9. **Renombrar `99_experimentos`** — el nombre miente, ahí viven los motores. Se hace
   **el día que haya que tocar Marker por otro motivo**, porque el entorno de Python que
   tiene adentro guarda rutas absolutas y renombrarlo obliga a reinstalar varios GB.

---

## 5. El circuito de dónde se idea — nuevo, sin probar todavía en la práctica

**Qué es.** Un proyecto normal de claude.ai (no Cowork) donde pensar comandos de
`00_sistema` sin necesidad de tener Code abierto. Se mantiene al día pegando este mismo
archivo cada vez que se cierra una sesión acá.

**Por qué no Cowork.** Cowork no tiene forma técnica de leer `C:\Noesis` — no es una
carpeta de Drive, no es un archivo subido, no es un repo conectado. Y aunque pudiera,
`SISTEMA.md` ya decidió que Cowork es para producir escritos de un caso, no para tocar la
máquina.

**Los pasos, siempre en este orden:**

1. Al cerrar acá, `HANDOFF.md` ya queda escrito en su ruta fija y se entrega también por
   chat como adjunto.
2. En el proyecto de claude.ai: **borrar primero** el HANDOFF que había quedado pegado.
3. Agregar el nuevo con **título fijo "HANDOFF"** — arrastrando el adjunto o pegando el
   texto copiado del archivo.

**Estado: recién diseñado, esta es la primera entrega real.** Falta confirmar en la
próxima sesión de ideación que el paso 2-3 sale sin fricción y que el proyecto queda
efectivamente actualizado — si algo no encaja, se ajusta la regla 11 de `PROTOCOLO.md`,
no se improvisa un método distinto.

---

## 6. Decisiones tomadas — no se discuten de nuevo

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
| **`~/.claude` se respalda parcial, no entera** | sólo lo hecho a mano (`settings.json`, `CLAUDE.md`); el resto es cache o transcripciones con datos de clientes |
| **Cowork es para escritos de caso, no para pensar sobre la máquina** | no tiene ni necesita acceso a `C:\Noesis`; para idear sin Code, el lugar es un proyecto normal de claude.ai con el HANDOFF pegado |
| **Commit y `push` automáticos al cerrar, sin pedirlo** | la conexión a GitHub es de la máquina (Git Credential Manager), no de la sesión de chat; dejar el push a que alguien se acuerde de pedirlo es el mismo riesgo que ya costó con `10_ingesta` (regla 8) |

---

## 7. Cómo arranca la próxima sesión

Abrir la carpeta según el tema (`C:\Noesis\00_sistema` para seguir con esto), leer este
archivo y, si la sesión toca código, chequear los cuatro repos antes de cerrar (comando
en §3).

Y al cerrar, el cierre de cinco pasos que es uno solo (regla 10, ampliada el
2026-08-18): verificar anonimato (regla 7) → **commitear y hacer `push` sin que haga
falta pedirlo** — la conexión a GitHub es de la máquina, no de la sesión de chat, ya
verificado con un push real → informar el costo (`python costo.py`) → sumar a
`PROTOCOLO.md` la regla que haya dejado la sesión → **reescribir este archivo**, que
además se entrega por chat como adjunto (regla 11).

_Escrito el 2026-08-18. Reconstruido de los commits, del disco y de las sesiones del día._
