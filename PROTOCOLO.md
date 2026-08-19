# PROTOCOLO DE TRABAJO CON CLAUDE

Cómo se trabaja, no qué se sabe. El *qué* vive en las skills; el *cómo* vive acá.

**Este archivo crece.** Cada sesión que deja una lección la escribe acá antes de
cerrar. Una regla que no queda escrita se pierde y se vuelve a pagar.

---

## 1. Una sesión, un tema — y la carpeta lo declara

La carpeta que se abre **es** la declaración del tema. No hace falta anunciarlo:
`tema_sesion.py` lo lee al arrancar y le dice a Claude de qué se habla, dónde se
guarda y qué no corresponde.

| Carpeta que abrís | Tema | Dónde se guarda |
|---|---|---|
| `C:\` o `G:\` o `C:\Noesis\00_sistema` | programar la máquina, instalar | `00_sistema` |
| `C:\Noesis\01_cerebro` | skills jurídicas (Capa 2) | `01_cerebro` |
| `C:\Noesis\00_nucleo` | método, constitución (Capa 1) | `00_nucleo` |
| `C:\Noesis\10_ingesta` | papeles a texto | `10_ingesta` |
| una carpeta de caso | **no se trabaja acá** → Cowork | — |

**Por qué.** Una sesión con tres temas adentro relee los tres en cada turno. El
gasto grande no lo hace el historial viejo — Claude no lee sesiones anteriores —
lo hace la sesión larga con todo mezclado.

**Se cierra la sesión cuando se termina el tema.** No se deja abierta "por si".

## 2. Frenar y dar el comando ya escrito

Si el pedido no es de esta sesión, Claude no explica teoría: una línea de por qué
y abajo el comando para copiar. El mapa completo está adentro de
`tema_sesion.py` (constante `DERIVAR`) — se edita ahí, en un solo lugar.

Resumen: **Code** construye el motor · **Cowork** produce el escrito ·
**Chat** piensa en voz alta · **NotebookLM** mapea material largo.

## 3. Un solo dueño por componente

Antes de crear algo, la pregunta no es *¿dónde lo guardo?* sino **¿quién es el
dueño de esto?** Si ya tiene dueño, se edita ahí. Dos copias de la misma verdad
es el error que más caro salió (pasó con `stack.json` y con los scripts).

## 4. Medir antes de opinar

Ningún motor entra por lo que dice su documentación. Entra con el número medido
sobre material propio. Los números viven en `SISTEMA.md`. Un motor descartado se
documenta con el número que lo descartó, no con "no anduvo".

## 5. Nombres que se entienden solos

`00_sistema`, `10_ingesta`, `1 - TIRAR ARCHIVOS ACA`. Si hay que explicar qué
guarda una carpeta, el nombre está mal. Deuda abierta: `99_experimentos`.

## 6. Costo al cerrar

Al terminar la sesión, Claude informa tokens y plata. El medidor es
`costo.py`. Sin el número no se sabe qué salió caro.

## 7. Nada de cliente en lo versionado

Nombre, expediente o matrícula → `_PRIVADO/` o skill con prefijo `caso-`. Se
verifica **antes** de commitear, no después.

## 8. Versionado no es respaldado

Un repo sin remoto **no es un respaldo**: es una carpeta con historial, y se muere
con el disco. Tener commits da una sensación de seguridad que no es real.

**Por qué está escrita.** El 2026-08-18 se encontró `10_ingesta` con seis commits
y sin remoto, mientras `SISTEMA.md` la daba por "no versionada". Las dos mitades
estaban mal: sí estaba versionada, y no estaba a salvo. Justo la carpeta con las
piezas que no se vuelven a bajar de ningún lado.

El chequeo de los cuatro repos, en una línea:

```bash
for d in 00_nucleo 00_sistema 01_cerebro 10_ingesta; do cd "/c/Noesis/$d" && echo "$d: $(git remote | head -1 || echo SIN-REMOTO) $(git status -sb | head -1)"; done
```

Sirve al cerrar una sesión que tocó código. Lo que se busca es `SIN-REMOTO` o
`ahead`: son las dos formas de tener trabajo que existe en un solo lugar.

## 9. El piso y los turnos — lo que gobierna el gasto

Medido el 2026-08-18 sobre las sesiones reales. Dos cosas explican casi todo, y
**ninguna de las dos es el trabajo**:

**El piso.** Lo que ya está cargado antes de que MJM escriba una palabra:
instrucciones, herramientas y **plugins conectados**. Se relee entero en cada
turno. El 2026-08-18 el piso era **70.458 fichas, y sólo 4.100 eran de MJM**
—`CLAUDE.md`, el perfil y el índice de memorias, un 6%—. El otro 94% era el
catálogo de plugins que nunca se usan: Carta, Twilio, Zapier, Adobe, ZoomInfo,
CockroachDB. Y crecía solo: de 56.759 a 70.458 en cuatro días, sin que MJM
agregara nada suyo.

**Los turnos.** El costo **no** crece con la duración: crece mucho más rápido,
porque cada turno relee todo lo anterior. El doble de larga cuesta como cuatro.

| Sesión del 2026-08-18 | Turnos | Costo |
|---|---|---|
| la que se cerró al terminar el tema | 126 | **USD 11,70** |
| la que quedó abierta | **939** | **USD 226,07** |

**Qué se hace.** Desconectar todo plugin que no se use —se paga en cada turno de
cada sesión, para siempre— y cerrar la sesión cuando termina el tema. Las dos
cosas cuestan **cero capacidad**: no sacan ninguna herramienta que se use.

**Qué NO se toca:** `CLAUDE.md`, el perfil y las memorias. Son el 6% del piso y
son justo lo que hace que Claude sepa quién es MJM y cómo trabaja. Recortar ahí
ahorra casi nada y sí hace perder capacidad. El instinto de "achico todo" se
equivoca de blanco.

El diagnóstico está en el medidor, no en un script aparte (regla 3):

```bash
python costo.py --piso
```

## 10. El handoff se escribe antes de cerrar

La sesión que cierra reescribe el `HANDOFF.md` de la carpeta del tema con cuatro
cosas y nada más: **qué se hizo · el estado real · qué queda y en qué orden · las
decisiones que ya no se discuten.** Se pisa a sí mismo: no acumula historia —esa
está en los commits— sino el presente. Y es lo primero que se lee al abrir.

**Por qué está escrita.** Claude no lee sesiones anteriores: cada sesión nueva
arranca sin saber nada de la anterior (regla 1). El 2026-08-18 hubo que
reconstruir la jornada entera desde los commits, el disco y los registros de las
sesiones del día para poder cerrarla. Salió bien, pero se pagó dos veces: una al
hacer el trabajo y otra al averiguar qué se había hecho. **Escribirlo cuesta una
vez; reconstruirlo, cada vez.**

**El cierre completo, decidido el 2026-08-18, es un solo gesto de cinco pasos y
en este orden:** verificar anonimato (regla 7) → **commitear y hacer `git push`
sin que haga falta pedirlo** → informar el costo (regla 6) → sumar la regla
nueva si la hubo → reescribir este archivo y entregarlo por chat (regla 11).

**El atajo, desde el 2026-08-19: `/cerrar`.** Comando de usuario
(`~/.claude/commands/cerrar.md`, respaldado en `claude_config\commands\`) que dispara
siempre el mismo texto de estos cinco pasos, en el mismo orden — así el cierre no
depende de que el modelo interprete igual la palabra suelta "cerrá" cada vez.

**Por qué el push es automático y no a pedido.** La conexión a GitHub no es
"de la sesión de chat": la tiene la máquina, vía Git Credential Manager, y
sigue andando igual en cualquier sesión nueva — verificado el 2026-08-18 con
un push real. Lo único que fallaba era que Claude sólo commitea cuando se lo
piden, y una sesión que termina sin que nadie lo pida deja el trabajo **en el
disco pero no en GitHub** — el mismo riesgo que la regla 8 ya encontró en
`10_ingesta`. Acá, en `00_sistema`, no hay datos de cliente en juego (P10 ya lo
garantiza con el chequeo del primer paso), así que no hace falta ese freno.

**Corolario, sumado el 2026-08-19:** cierre sin reescritura de HANDOFF es cierre incompleto. El commit no se considera cerrado hasta que el HANDOFF lo refleje.

**Por qué.** El cierre que terminó en el commit `36a79ae` no reescribió este
archivo. Dos sesiones después no tenían forma de saber que ese trabajo ya estaba
hecho, y llegaron dos órdenes —"commitear `modelos\`" y "ratificar `modelos\` en
`MEICL-v2.md`"— pidiendo repetir algo que el disco ya tenía resuelto. Se
detectaron a tiempo porque la regla 16 ya estaba en juego, pero el costo de origen
es este: un cierre que no deja el HANDOFF al día obliga a la sesión siguiente a
redactar contra una foto vieja.

## 11. El handoff también viaja a donde se idea

Para pensar comandos de `00_sistema` sin estar en Code, el lugar es un **proyecto
normal de claude.ai, no Cowork** (regla 2: Cowork es para producir escritos de un
caso; no tiene ni necesita acceso a este disco). Ese proyecto se mantiene al día
pegando el `HANDOFF.md` recién escrito en su Conocimiento del proyecto, cada vez
que se cierra una sesión acá.

**Por qué así y no de otra forma.** No existe una sincronización automática entre
un proyecto de claude.ai y este disco — y aunque existiera, la regla **el repo
manda** (la misma que rige las skills: claude.ai es borrador) dice que el sentido
del flujo es de acá hacia afuera, nunca al revés. El `HANDOFF.md` ya se escribe
por la regla 10; pegarlo en el proyecto no es trabajo nuevo, es el mismo archivo
con un segundo destino.

**El circuito completo:** cerrar sesión acá → se escribe/actualiza `HANDOFF.md` →
se pega en el proyecto de claude.ai → ahí se idea con el contexto fresco → el
comando que sirve se trae de vuelta y se corre acá, contra el disco real.

**Cómo, paso a paso — nada de buscar el archivo a mano:**

1. `HANDOFF.md` vive siempre en la misma ruta, `C:\Noesis\00_sistema\HANDOFF.md`,
   y al cerrar la sesión Claude ya lo deja escrito ahí. Además lo entrega en el
   chat como adjunto al cerrar, para no tener que ir a buscarlo.
2. En el proyecto de claude.ai: **borrar primero** el "HANDOFF" que quedó pegado
   la sesión anterior. Es el mismo error que costó caro con `stack.json` (regla
   3) — dos copias de la misma verdad, y no se sabe cuál es la vigente.
3. Agregar el nuevo con **título fijo "HANDOFF"** siempre, para encontrarlo rápido
   la próxima vez. Dos formas, cualquiera sirve: arrastrar el archivo adjunto
   directo al panel de contenido del proyecto, o abrirlo, `Ctrl+A` / `Ctrl+C`, y
   pegarlo como texto.

Escribirlo es del cierre, junto con el costo (regla 6) y la regla nueva si la
hubo. Los tres pasos son uno solo y van en ese orden.

## 12. Lo que se usa seguido va al Escritorio, no a una carpeta técnica

Una herramienta de uso diario (convertir a texto para la IA, por ejemplo)
necesita un clic, no memorizar una ruta. El archivo vive donde tiene que
vivir por dueño (`10_ingesta\PREPARAR PARA IA.bat`, regla 3) — el acceso
directo va al Escritorio, con el mismo nombre en lenguaje simple, para que
cualquiera lo reconozca sin explicación.

**Por qué está escrita.** El 2026-08-18 MJM no sabía cómo convertir un
archivo a mano y pidió una manera visual de hacerlo — y el acceso directo
`PREPARAR PARA IA.lnk` ya estaba en su Escritorio desde antes, apuntando bien.
El problema no era que faltara la herramienta: era que no se veía. **Antes de
construir algo nuevo, revisar el Escritorio.**

---

## Reglas técnicas ganadas a golpes

- **Rutas de Windows: nunca por heredoc de bash.** El shell se come las barras
  (`\U` → error, `\r` → `^M`). Se escribe con la herramienta de archivos.
- **Python: ruta absoluta.** `python` a secas cae en el stub del Microsoft Store.
  El bueno es
  `C:\Users\M01\AppData\Local\Programs\Python\Python312\python.exe`.
- **La salida de un hook va en ASCII puro** (`ensure_ascii=True`). La consola de
  Windows rompe los acentos en el camino.
- **Un script de administrador, uno solo.** `acomodar_sistema.ps1`.
- **Verificar contra el estado real, no contra el registro.** El registro de
  Windows deja entradas muertas: dieron dos falsas alarmas. Y `SISTEMA.md` dio una
  tercera el 2026-08-18: el pendiente decía una cosa y el disco decía otra.
- **Un cartel en pantalla no es un paso.** GitHub ofrece instalar Copilot al crear
  un repo; no hace falta para nada y está en la tabla de Prohibidos. Lo que aparece
  sugiriendo instalar algo se contrasta contra esa tabla antes de tocarlo.
- **La credencial la pone MJM.** Claude no se autentica en cuentas ajenas ni con
  autorización expresa. Cuando algo pide una llave, Claude deja todo preparado
  hasta la puerta y da el camino más corto — el clic es de MJM.
- **Un `.md` abierto en Word bloquea la escritura.** Windows lo toma en exclusiva y
  cualquier intento devuelve `EPERM` al renombrar o `Device or resource busy` al copiar
  — no es un problema de permisos ni de antivirus, y reintentar no sirve. Pasó el
  2026-08-19 con `HANDOFF.md`. **Antes de reescribir un `.md` de esta carpeta, cerrarlo
  en Word.** Diagnóstico en una línea, sin adivinar:
  ```bash
  powershell -NoProfile -Command "Get-Process | Where-Object {$_.Name -match 'WINWORD|Code|notepad'} | Select-Object -ExpandProperty Name -Unique"
  ```
  Y el corolario: **el contenido se escribe primero en el scratchpad y después se copia.**
  Así un bloqueo cuesta un `cp`, no volver a redactar el archivo entero.
- **Git Bash convierte `/c` en `C:/`.** Al registrar un comando que lleva `cmd /c`
  (un servidor MCP, por ejemplo), anteponer `MSYS_NO_PATHCONV=1` y verificar el
  resultado (`claude mcp list`). Costó un registro roto el 2026-08-19. Y el
  nombre del binario se verifica en la carpeta de npm, no se adivina: el paquete
  `@playwright/mcp` instala `playwright-mcp`, no `mcp-server-playwright`.

## 13. Dos correcciones y se frena

Si una instrucción, un script o una corrección **falla dos veces seguidas en la
misma sesión**, se aborta la iteración ahí mismo. Está prohibido seguir
explicando o parchando sobre un contexto ya contaminado.

Lo que se hace en su lugar, obligatorio: **frenar, resumir el bloqueo en tres
líneas** y elegir una de dos salidas — reiniciar el contexto (`/clear`, con el
aprendizaje ya escrito) o plantear una vía alternativa determinística.

**Por qué está escrita.** Cuando un intento falla, el historial queda lleno de
enfoques equivocados, y el intento siguiente los relee todos como si fueran
antecedentes válidos. La tercera corrección no parte de cero: parte de dos
errores. Por eso el gasto sube mientras la probabilidad de acertar baja — es la
regla 9 vista desde adentro de un problema puntual.

**El corolario que ya se pagó una vez:** cuando lo que falta es un dato o un
archivo, frenar y preguntar **no es la salida lenta, es la única**. El
2026-08-19, con Drive desmontado, una instrucción decía "copialo desde su origen
o crealo" — y crear ese archivo habría reemplazado la fuente única por una
invención, dejando la copia falsa gobernando sobre la real. **Un archivo que no
se puede leer no se inventa: se espera o se pregunta.**

## 14. Dual-track: ningún caso se archiva sin destilar

El estudio corre en **dos vías a la vez**, y la segunda no arranca sola: la
dispara el cierre de la primera.

| | Vía 1 — **Operación** | Vía 2 — **Destilación** |
|---|---|---|
| Qué hace | resolver el caso que factura | convertir lo resuelto en pieza reutilizable |
| Dónde vive | `G:\...\01_Casos_Activos\<caso>\` | `C:\Noesis\01_cerebro\skills\<área>\` |
| Con qué herramienta | **Cowork** (escritos) · NotebookLM (material largo) | **Claude Code**, sesión de `01_cerebro` |
| Cuándo | mientras el caso está vivo | **al cerrarlo, antes de archivar** |

**La regla dura: no se diseña en abstracto.** No se crea una skill, una ficha,
un modelo ni un agente temático "porque haría falta". Toda pieza nace como
solución a una tarea concreta de un caso real y **después** se empaqueta. Una
skill sin caso detrás es una hipótesis con formato de certeza.

**Los agentes por materia son el último paso, no el primero.** Un área nueva
(penal, tributario, societario) **no** se abre creando su carpeta: se abre
cuando hay masa crítica de casos cerrados que ya destilaron fichas y modelos, y
esas piezas piden un `SKILL.md` que las gobierne. Antes de eso, la carpeta vacía
sólo genera la ilusión de que el área existe.

### El Post-Mortem, paso obligatorio antes de archivar

Un caso pasa de `01_Casos_Activos` a `02_Casos_Archivados` **únicamente** después
de esto. Cinco preguntas, y lo que sobrevive se escribe:

1. **¿Qué escrito funcionó?** → a `skills\<área>\modelos\`, parametrizado y sin
   un solo dato del cliente.
2. **¿Qué criterio o plazo se aplicó?** → ficha en `skills\<área>\references\`,
   con pinpoint a la fuente oficial o marcado `[a verificar]`.
3. **¿Hubo un cálculo que se repitió a mano?** → a `skills\<área>\scripts\`,
   determinístico y auditable. Nunca cálculo mental.
4. **¿Qué precedente o postura judicial sirvió de verdad?** → ficha de doctrina
   en `references\`, con la cita puntual, no el resumen.
5. **¿Qué salió mal y volvería a salir mal?** → si es de *cómo se trabaja*, es
   una regla y va acá. Si es de *qué se sabe*, va a la skill.

Si las cinco dan "nada", el caso se archiva igual — pero eso se escribe también:
un caso que no dejó nada es un dato sobre el caso, no un permiso para saltear
el paso.

**La madurez sube en este momento y no en otro.** Cada pieza que ya existía y se
volvió a usar avanza un escalón: `borrador` → `estrenada` (1 caso real) →
`rodada` (3+) → `consolidada`. Es MEICL v2.2: *el caso facturable es el evento
de validación*. Los valores volátiles no suben nunca: runtime siempre.

**El anonimato se verifica acá, no al commitear.** Es el único paso donde el
dato del cliente y la pieza reutilizable están en la misma mesa. Si una pieza
necesita anonimizarse *después* de entrar al repo, entró mal (P10, regla 7).

### Los dos flujos, en lenguaje simple

**`nuevo_caso <id>`** — abrir un caso. No es un comando: es un lugar.
`G:\...\01_Casos_Activos\<id>\`, y el material crudo entra por el buzón
`G:\...\0_ENTRADA` que la ingesta ya vigila y convierte a `.md`. **No se crea
nada en `C:\Noesis`**: papeles a `G:`, motor en `C:` (regla de oro). Y el escrito
se produce en Cowork, no acá (regla 2).

**`destilar_caso <id>`** — cerrar un caso. Sesión de Claude Code en
`C:\Noesis\01_cerebro`, con las cinco preguntas de arriba a la vista. Termina
con el caso movido a `02_Casos_Archivados` y un commit en `noesis-legal` que no
contiene un solo nombre propio.

**Por qué está escrita.** El 2026-08-19 llegó una directiva —de otra IA, formato
de tablero— para crear en la raíz de `C:\Noesis` un árbol `casos\` + `knowledge\`
+ `skills\` + `agents\`. Las cuatro carpetas ya existían con otro nombre y del
lado correcto del disco: `casos\` es Drive, `knowledge\` es `references\`,
`skills\` ya está en `01_cerebro` **y tiene un junction desde `~/.claude`** que
una segunda carpeta homónima habría dejado ciego. Crearlas habría duplicado
todo el sistema y puesto papeles de clientes dentro del motor. **La idea de
fondo era correcta y ya era doctrina; lo que fallaba era la topología.** De ahí
la lección: cuando llega una arquitectura entera de afuera, primero se mapea
contra el disco pieza por pieza (regla 3: ¿quién es el dueño de esto?), y recién
después se crea lo que efectivamente falta — que casi siempre es mucho menos de
lo que la directiva pide. Acá faltaban dos cosas de siete: `modelos\` y este
paso de Post-Mortem.

## 15. Compuerta de ejecución: Code ejecuta y mapea, no idea

**Claude Code es un ejecutor técnico terminal y un mapeador de disco.** No es mesa de
ideación conceptual ni consultorio jurídico abstracto. Un pedido de construcción entra
sólo si viene empaquetado con las tres cosas:

| | Qué significa |
|---|---|
| **Objetivo funcional** | qué tiene que quedar andando, no "mejorar" ni "ver si conviene" |
| **Restricciones y límites** | las **rutas exactas** que se tocan, y las que no |
| **Criterio de validación** | cómo se sabe que salió bien, medible antes de empezar |

Si falta cualquiera de las tres —o si el pedido es un debate doctrinario, una lluvia de
ideas, una consulta jurídica abstracta, o desarrollo **sin un caso real que lo
justifique** (regla 14)— **se aborta antes de generar código, módulos o abstracciones**,
y se responde exactamente esto, en dos líneas:

```
Pedido no maduro para ejecución técnica (falta objetivo, rutas o criterio de validación).
Por favor derivar a la Mesa de Diseño (Chat Noesis) o estructurar sobre un caso activo en G:\
```

Cae en el aborto, en concreto: la consulta jurídica abstracta o el debate doctrinario · la
lluvia de ideas o propuesta arquitectónica sin esquema resuelto · la skill o el agente
pedido "por si acaso", sin caso real de origen (regla 14) · la instrucción ambigua, sin
rutas explícitas ni criterio de prueba.

### La excepción: Modo Piloto

**Sin directiva previa, y siempre permitido**, porque es de sola lectura y no altera el
disco:

- **inspección de estado:** `git status`, `git diff`, `git log`
- **mapeo de herramientas:** `claude mcp list`, versiones, qué está instalado
- **exploración de directorios y lectura de archivos**
- **reportar el estado del sistema y proponer el siguiente paso del `HANDOFF.md`**

Ésta es la mitad "mapeador de disco" del rol. La compuerta cierra la puerta de
**escribir**, no la de **mirar y orientar**. Un Claude que no puede decir en qué estado
está la máquina ni cuál es el próximo paso no es más seguro: es sólo más mudo, y obliga a
MJM a llevar el estado del sistema en la cabeza — que es justo lo que el `HANDOFF.md`
existe para evitar.

### Límites físicos y de arquitectura — el tablero

Cuatro cosas que no se negocian en ninguna sesión. **Ninguna nace acá**: cada una tiene su
dueño y su *por qué* en otro lado, y esto es el tablero para tenerlas juntas a la vista
(regla 3 — se corrigen en el dueño, no en esta tabla).

| Límite | En una línea | Dueño |
|---|---|---|
| **Casos y expedientes** | viven **sólo** en `G:\...`; prohibido crear o mover carpetas de casos a `C:\` | regla de oro (`00_LEEME.md`) + §14 |
| **Skills y agentes** | único contenedor válido: `C:\Noesis\01_cerebro\skills\`. Prohibido crear `skills\`, `agents\` o `knowledge\` en la raíz de `C:\` | el junction (`CLAUDE.md` global) |
| **Anti-bloqueo (`EPERM`)** | contenido pesado se redacta en el scratchpad y **después** se copia a disco | reglas técnicas, abajo |
| **Anonimato estricto** | jamás commitear datos de clientes a un repo | regla 7 + P10 |

### Los dos límites que la compuerta no cruza

**Diferencia con la regla 2.** La 2 frena por **tema equivocado** (esto va a Cowork, esto
a `01_cerebro`) y entrega el comando de derivación. La 15 frena por **falta de
especificación**: el tema puede ser el correcto y el pedido igual no entra. La 2 pregunta
*¿dónde va esto?*; la 15 pregunta *¿está listo para ejecutarse?*.

**Rechazar no es ignorar el disco.** Si el pedido es ejecutable pero su topología choca
con el sistema existente, la respuesta no son las dos líneas: es el mapeo pieza por pieza
(regla 3, ¿quién es el dueño de esto?) y después la ejecución de lo que efectivamente
falta. Las dos líneas son para lo que **no se puede ejecutar**, no para lo que **se puede
ejecutar distinto**.

**Por qué está escrita.** Un pedido sin criterio de validación no tiene forma de terminar:
se ejecuta, se muestra, se opina, se vuelve a ejecutar. Eso es exactamente la sesión de
939 turnos de la regla 9 —USD 226 contra USD 11,70— vista desde su causa y no desde su
efecto. La compuerta no ahorra trabajo: ahorra las iteraciones que nunca iban a converger
porque nadie había definido qué era converger.

**Y por qué lleva excepción desde el día uno.** La primera redacción (2026-08-19) sólo
tenía la parte que rechaza. Con ese texto, la directiva que originó la regla 14 —que no
traía rutas exactas ni criterio de validación— habría rebotado en dos líneas, y no
existirían ni el Post-Mortem ni `modelos\`. El Modo Piloto y el mapeo de disco no son
concesiones a la regla: son la mitad del rol que la hace utilizable.

## 16. Verificar antes de ejecutar — el criterio de éxito ya viene escrito

**Toda orden arranca en Modo Piloto verificando su propio criterio de éxito contra el disco. Si ya se cumple, se reporta y no se ejecuta.**

Es determinístico —el criterio de éxito ya viene escrito en la orden, no hay que
inventar cómo comprobarlo— y es barato: casi siempre un `grep` o un `git log`
alcanzan.

**Por qué está escrita.** El 2026-08-19 llegaron dos órdenes seguidas —commitear
`modelos\` y ratificar `modelos\` en `MEICL-v2.md`— para trabajo que un commit
anterior (`36a79ae`) ya había hecho. La corrección obvia parecía pedirle a la mesa
que revisara el disco antes de redactar la siguiente orden, pero la mesa no ve el
disco: trabaja sobre el `HANDOFF.md`, y si el `HANDOFF.md` miente, la mesa siempre
va a redactar contra la foto vieja. El que sí ve el disco es Code, en Modo Piloto,
en el primer paso de cada orden —antes de tocar nada—. La causa de por qué el
`HANDOFF.md` mentía queda en el corolario de la regla 10.

---

## 17. El pendiente ya declarado no es "fuera de tema" — cotejar contra el HANDOFF antes de frenar

**Antes de aplicar la compuerta de "una sesión, un tema" a un pedido, cotejarlo contra
los pendientes ya declarados en `HANDOFF.md` §4. Si coincide con uno, es del tema — no
se frena.**

**Por qué está escrita.** El 2026-08-19 el pendiente 4.1.2 de `HANDOFF.md` decía,
textual: *"Probar el MCP en una sesión nueva de Claude Code: pedirle que navegue a una
página y la resuma. Si conecta y navega, la capa queda estrenada."* Llegó exactamente
ese pedido —navegar con el MCP de Playwright y resumir— y se frenó por "no es tema de
esta sesión", tratándolo como consumo de contenido genérico. El pendiente ya lo había
declarado tema de `00_sistema` (verificar que la capa web instalada funciona) en el
mismo archivo que toda sesión lee primero. El costo: un pedido legítimo, ya anticipado
por el propio sistema, rebotado por no mirar el documento que se supone que se leyó.

---

## Cómo se suma una regla

Se agrega cuando algo **costó**: un error que se repitió, plata que se fue, una
sesión que hubo que rehacer. No se agregan buenas intenciones. Formato: qué se
hace, y abajo **por qué** — el por qué es lo que evita que alguien la deshaga
dentro de seis meses.

_Última regla sumada: 2026-08-19 (regla 17: el pendiente ya declarado no es "fuera de
tema" — cotejar contra el HANDOFF antes de frenar)._
