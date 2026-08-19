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

**Por qué el push es automático y no a pedido.** La conexión a GitHub no es
"de la sesión de chat": la tiene la máquina, vía Git Credential Manager, y
sigue andando igual en cualquier sesión nueva — verificado el 2026-08-18 con
un push real. Lo único que fallaba era que Claude sólo commitea cuando se lo
piden, y una sesión que termina sin que nadie lo pida deja el trabajo **en el
disco pero no en GitHub** — el mismo riesgo que la regla 8 ya encontró en
`10_ingesta`. Acá, en `00_sistema`, no hay datos de cliente en juego (P10 ya lo
garantiza con el chequeo del primer paso), así que no hace falta ese freno.

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
- **Git Bash convierte `/c` en `C:/`.** Al registrar un comando que lleva `cmd /c`
  (un servidor MCP, por ejemplo), anteponer `MSYS_NO_PATHCONV=1` y verificar el
  resultado (`claude mcp list`). Costó un registro roto el 2026-08-19. Y el
  nombre del binario se verifica en la carpeta de npm, no se adivina: el paquete
  `@playwright/mcp` instala `playwright-mcp`, no `mcp-server-playwright`.

---

## Cómo se suma una regla

Se agrega cuando algo **costó**: un error que se repitió, plata que se fue, una
sesión que hubo que rehacer. No se agregan buenas intenciones. Formato: qué se
hace, y abajo **por qué** — el por qué es lo que evita que alguien la deshaga
dentro de seis meses.

_Última regla sumada: 2026-08-18 (regla 12: lo que se usa seguido va al Escritorio)._
