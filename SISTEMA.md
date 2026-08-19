# Diseño del sistema — máquina MJM

Este archivo es **la fuente única** de cómo está armada esta computadora: qué hay
instalado, por qué, y qué está prohibido. Si algo se instala, se declara acá primero.

Última revisión: **2026-08-18**

---

> ## ⚠ Qué sale de esta máquina y qué no
>
> | | |
> |---|---|
> | **Esta carpeta** (`SISTEMA.md` y los `.ps1`) | **se versiona y puede publicarse.** No nombra ningún cliente ni expediente |
> | **`_PRIVADO\`** | **nunca sale.** Excluida por `.gitignore` |
>
> **La regla, una sola:** si nombra un cliente, un expediente o una matrícula, va en
> `_PRIVADO\`. Afuera queda la referencia genérica.
>
> Es la constitución §6 aplicada acá. Antes de cada commit: si un archivo de afuera
> nombra un expediente, estaba en el lugar equivocado.

---

---

## Principio rector: convergencia arquitectónica

> **Una sola fuente de verdad. Un solo responsable por componente.**

| Componente | Único responsable |
|---|---|
| Sistema operativo | **Windows** |
| Nube | **Google Drive** |
| Documentos de escritorio | **Office**, y solo local |
| Código | **Git** |
| Papeles a texto | **`10_ingesta`** |
| Diseño de la máquina | **`00_sistema`** |
| Datos del stack | **`stack.json`** |

Y la consecuencia operativa, que es la que hay que aplicar cuando algo se pone confuso:

> **Ante cualquier duda, la pregunta no es "¿dónde lo guardo?" sino "¿quién es el dueño
> de esto?".** Si la respuesta son dos, hay que matar uno. Un componente con dos dueños
> no está duplicado: está roto, porque nadie sabe cuál de los dos es el que vale.

### Dobles dueños — auditoría del 2026-08-17

| Componente | Dueños | Resolución |
|---|---|---|
| Lista del stack | 3 → **1** | ✔ `instalar.ps1` e `inventario.ps1` ya leen `stack.json`; borradas sus copias |
| Papeles a texto | 3 | `10_ingesta` manda. Jubilar `99_experimentos\marker_pdfs` y `Downloads\Noesis` |
| Panel | 2 | El generador manda. El `Panel Noesis.html` de Drive es una foto vieja: borrar |
| Carpetas de casos | 2 | **Drive manda** (es la única nube). Cotejar y unificar — detalle en `_PRIVADO` |
| Documentos | 2 | Office manda. Sacar LibreOffice cuando Office esté andando |

---

## La regla operativa

> **Una herramienta para cada cosa. Una sola.**

Y el corolario, corregido el 2026-08-18 después de probarlo en la práctica:

> **Cero nube de Microsoft. Office de escritorio sí.**

La primera versión de esta regla decía "cero Microsoft en la capa de documentos" y se
sacó Office entero. Duró unas horas: **el problema nunca fue Word, fue OneDrive.** Office
es mejor herramienta para lo que hace MJM —escritos con control de cambios, formato
armado, lo que le mandan colegas y tribunales— y la suscripción ya estaba paga.

La línea correcta es la nube, no el programa:

| | |
|---|---|
| **Office de escritorio** | **sí** — guardando en disco, sin Copilot |
| **OneDrive** | **no**, y bloqueado por política para que no vuelva |
| GitHub | sí — es infraestructura, y es de Microsoft desde 2018 |

Ese bloqueo es lo que hace segura la puerta abierta: Office puede reinstalarse cuantas
veces haga falta sin que OneDrive vuelva con él.

**Se habita en tres lugares y nada más: Google, GitHub y local.**

### La sesión de Windows va con cuenta local

Verificado el 2026-08-17: el inicio de sesión de esta máquina es **cuenta local**
(`MJ\USUARIO`), no cuenta Microsoft. **Que siga así.** Iniciar sesión con una cuenta
Microsoft reactiva OneDrive y vuelve a traer todo lo que se sacó.

No hay riesgo en mantenerlo así: Windows está activado con **licencia OEM**, ligada a la
placa de la notebook y no a ninguna cuenta.

### Por qué

No es una preferencia estética ni una cuestión de licencias. Cada herramienta extra no es
una opción más: es un lugar más donde buscar algo, otra cuenta, otro flujo. Ese es el
costo que el TDAH no puede pagar. Es la misma raíz de "pocas carpetas, una cosa por vez".

---

## El hardware manda

| | |
|---|---|
| Procesador | Intel i7-8665U (4 núcleos, portátil) |
| Memoria | 16 GB |
| Placa de video | **ninguna dedicada** — Intel UHD 620 integrada |

**Esa última línea decide cosas.** Todo lo que necesite una placa de video (modelos de
visión, OCR con inteligencia artificial, modelos de lenguaje locales grandes) es
inviable acá. Medido el 2026-08-17: Marker con OCR tardó **más de 20 minutos en una sola
página**; Tesseract hizo la misma en **5,4 segundos**.

Regla que sale de ahí: **antes de proponer una herramienta con modelos, preguntarse si
pide placa de video.** Si la pide, no va.

### Motores medidos en esta máquina (2026-08-18)

Ninguno se adopta por lo que promete el folleto. Se mide contra material real de MJM:

| Motor | Qué pasó | Veredicto |
|---|---|---|
| **Extracción directa** (pdftext, mammoth, openpyxl) | PDF de 1 pág en **1,2 s** · XLSX en **0,1 s** | **es el motor de todos los días** |
| **Tesseract** + castellano | una página escaneada en **5,4 s** | **el OCR de todos los días** |
| **faster-whisper** (small) | **31 min de audio en 4 min 27 s** — 7× más rápido que escucharlo | **adoptado**: los audios son prueba |
| **Pandoc** | sin modelos, instantáneo | adoptado para HTML, RTF, ODT, EPUB |
| **Marker** | **más de 14 min** con un PDF de **una** página, sin OCR | solo a pedido, con `--marker` |
| **Docling** | **falló las dos veces**, incluso apagándole los modelos: pide un compilador C++ que Windows no trae. 209 s y 171 s para terminar en error | **descartado** |

Sobre Docling: para usarlo habría que instalar las herramientas de compilación de Visual
Studio (varios GB) y ni así hay garantía sin placa de video. Se deja instalado, no se
borra: comparte librerías con Marker y desinstalarlo lo rompería.

---

## El stack, por función

Una función, una herramienta. Si aparece una segunda para lo mismo, sobra una.

**El detalle vive en `stack.json`, que es la fuente única** — lo leen el panel, el
instalador y el inventario. Acá va el mapa; ahí, los datos.

Son **tres listas**, porque son tres cosas distintas y se verifican distinto:

### 1. Programas — se instalan con un comando y se verifican solos

| Función | Herramienta |
|---|---|
| Sistema operativo | Windows 11 |
| Navegador | Google Chrome |
| Nube de archivos | Google Drive (`G:\Mi unidad`) |
| Control de versiones | Git · GitHub CLI · GitHub Desktop |
| Lenguaje principal | Python 3.12 |
| Lenguaje web | Node.js |
| Editor de código | Zed |
| OCR de todos los días | Tesseract 5.4 |
| Videollamadas | Zoom |
| Asistente de IA | Claude |

### 2. Piezas propias — puestas a mano o construidas acá

No salen de ningún instalador, y si se pierden no hay dónde volver a bajarlas: **son las
que justifican tener este repositorio.**

| Función | Pieza |
|---|---|
| PDF complejo, a pedido | Marker (`99_experimentos\marker-env`) |
| Motor de OCR de Marker | `llama-server` — sin esto Marker no hace OCR |
| Castellano del OCR | `spa.traineddata` — sin esto Tesseract lee como si fuera inglés |
| Papeles a texto | Ingesta NOÉSIS (`10_ingesta`) |
| Web a texto | `web_a_md.py` (`10_ingesta`) — motor: trafilatura |
| Navegación web por Claude | `playwright-mcp` (MCP, npm global) |
| Chrome manejable (puente) | `chrome_debug.bat` (`00_sistema`) |
| Liquidaciones | Motor de `liquidar-ar` |

### 3. Servicios — viven en la nube, no se instalan

No se verifican (no hay cómo), pero **se declaran igual: si no están acá, hay funciones
del día sin dueño y el diseño miente.**

| Función | Servicio |
|---|---|
| Correo | Gmail |
| Agenda | Google Calendar |
| Documentos y planillas | Google Docs / Sheets |
| Repositorio remoto | GitHub |
| Diseño gráfico | Canva |
| Lectura de material | NotebookLM — lee los `.md` convertidos, no los PDF |

### Prohibidos

| Qué | Por qué |
|---|---|
| OneDrive | capa de documentos — la cubre Drive |
| Copilot | duplica a Claude |
| WSL / Linux | segundo sistema; no acelera nada de lo que se hace acá |
| Adobe Creative Cloud | app suelta por tarea; la cubre Canva |
| Notion | duplica notas y documentos con Google Docs y Drive |
| TeamViewer | sin uso; y un acceso remoto sin usar es una puerta abierta |
| iLovePDF, CamScanner y similares | **lo hace la propia máquina** desde el 2026-08-17 |
| Un segundo intérprete de Python | fuente de "¿con cuál corre esto?" |

Office **no** está en esta tabla — dejó de estarlo el 2026-08-18: ver "La regla
operativa" más arriba, que es donde vive la decisión y el porqué.

Lo de iLovePDF y CamScanner es lo más importante de esa tabla: no son programas
instalados, son **hábitos**. Convertir, escanear y sacar texto ya lo hace `10_ingesta`
sin subir el documento a ningún sitio web.

---

> **Deuda de nombre — `99_experimentos`.** El nombre miente: ahí no hay experimentos,
> viven los motores pesados y son pieza estructural (están declarados en `stack.json`).
> No se renombra todavía porque el entorno de Python que tiene adentro guarda rutas
> absolutas: cambiarle el nombre a la carpeta rompe Marker y obliga a reinstalarlo, que
> son varios gigas de descarga. **Se renombra el día que haya que tocar Marker por otro
> motivo**, así la descarga no es un costo extra. Decidido el 2026-08-18.

---

## Dónde se hace cada cosa

| Superficie | Alcance | Para qué |
|---|---|---|
| **Chat** (claude.ai) | sin archivos | pensar, dudas sueltas — y **la mesa de diseño**, cuya instrucción es `MESA_DISENO.md` |
| **Cowork** | carpetas locales, un proyecto por caso | **producir escritos** sobre un expediente |
| **Claude Code** | disco + git | **construir**: el motor legal, la máquina, los programas |

**La máquina es siempre de Claude Code.** Instalar o sacar programas, conectores, motores,
tareas de Windows, tocar el registro, versionar: **solo acá**. No es que convenga más —
Chat y Cowork directamente no pueden.

Y al revés: redactar un escrito sobre un expediente es de Cowork, no de acá.

> **Nota que ahorra tiempo:** en Claude Code, Claude lee `G:\Mi unidad` **directo del
> disco** — más acceso que Gemini o ChatGPT, no menos. No hace falta subir nada. Lo que
> es difícil es en **claude.ai**, donde hay que subir archivos o conectar Drive.

---

## Las carpetas

| Carpeta | Qué gobierna |
|---|---|
| `C:\Noesis\00_sistema` | **este diseño** y la instalación de todo |
| `C:\Noesis\00_sistema\claude_config` | el respaldo versionado de `~/.claude` — qué y por qué, en su `LEEME.md` |
| `C:\Noesis\_contexto` | perfil de MJM y manual de uso |
| `C:\Noesis\01_cerebro` | las skills, versionadas en git |
| `C:\Noesis\10_ingesta` | la conversión automática a Markdown |
| `C:\Noesis\99_experimentos` | **los motores pesados**: Marker, `llama-server`, el entorno de Python |
| `G:\Mi unidad` | los papeles: casos, contable, personal |

---

## Cómo se instala algo

No a mano y no de apuro. Se declara en `instalar.ps1` y se corre desde ahí, para que
dentro de seis meses siga existiendo el registro de qué se puso y por qué.

```
powershell -ExecutionPolicy Bypass -File C:\Noesis\00_sistema\instalar.ps1
```

Para ver cómo está la máquina contra este diseño —qué falta y qué sobra—:

```
powershell -ExecutionPolicy Bypass -File C:\Noesis\00_sistema\inventario.ps1
```

## Cómo se saca algo

Lo que Windows deja desinstalar sin permisos especiales sale con `winget uninstall`.
Lo que exige administrador está en `terminar_sistema.ps1`, que se corre así (Windows
pide confirmación):

```
Start-Process powershell -Verb RunAs -ArgumentList '-ExecutionPolicy','Bypass','-File','C:\Noesis\00_sistema\terminar_sistema.ps1'
```

---

## Historial de decisiones

| Fecha | Qué | Por qué |
|---|---|---|
| 2026-08-16 | Marker instalado | convertir PDF a texto sin subirlo a la nube |
| 2026-08-17 | Ingesta automática (`10_ingesta`) | que todo papel pase a texto solo |
| 2026-08-17 | Tesseract + castellano | OCR viable sin placa de video (5 s vs 20 min) |
| 2026-08-17 | Escritorio y Documentos fuera de OneDrive | tenían adentro los repos git y los casos |
| 2026-08-17 | Fuera: Copilot, WSL + Ubuntu, Python 3.14 | una herramienta por función |
| 2026-08-17 | Fuera con administrador: **Microsoft 365, OneDrive, Notion** | la regla |
| 2026-08-17 | Zed como editor | hacía falta editor; VS Code es Microsoft |
| 2026-08-17 | Fuera también: Notion y TeamViewer | duplicaba notas / acceso remoto sin uso |
| 2026-08-18 | `10_ingesta` con repo propio (`noesis-ingesta`) | un repo por componente: un solo dueño, y `C:\Noesis` tiene adentro enlaces a papeles de clientes |
| 2026-08-18 | Office de escritorio vuelve a estar permitido; sale de Prohibidos | el problema nunca fue Word, fue OneDrive — que sigue bloqueado |
| 2026-08-18 | `~/.claude` respaldada en `claude_config\` (sólo `settings.json` y `CLAUDE.md`) | el resto es cache que se regenera o transcripciones con nombres de clientes que P10 prohíbe versionar |

---

## Lo próximo: agenda y panel dominical

Decidido el 2026-08-17. **Dos piezas con propósitos distintos, y no se pisan:**

| | Para qué | Cuándo |
|---|---|---|
| **Google Calendar** | **alertar.** Los vencimientos suenan en el celular sin depender de abrir nada | siempre |
| **Panel dominical** | **planear.** Qué venció, qué se tocó, cómo está el sistema | domingo a la tarde |

Un vencimiento no puede depender de que uno se acuerde de abrir algo: por eso alertar es
del Calendar y no del panel.

**El panel no usa IA ni tiene costo.** Es Python leyendo archivos del disco: no consulta a
ningún modelo, no manda nada a internet, funciona sin conexión. Y **no acumula archivos**:
`panel.html` se pisa a sí mismo, siempre es uno solo, y no se versiona (el repo guarda el
generador, no el resultado).

Semanal y no diario a propósito: lo diario no cuesta plata pero cuesta atención — un panel
que casi siempre dice lo mismo se vuelve paisaje.

**Para construirlo falta:** unificar `panel.py` (que ya existe y anda) con los vencimientos,
que salen de un archivo en `_PRIVADO` porque llevan nombres de expedientes; y programarlo
para el domingo. Gmail y Calendar en vivo quedan para cuando se conecten esos servicios,
que pide autorización en el navegador.

## El pipeline de ingesta

```
MUNDO EXTERIOR   PDF · DOCX · XLSX · PPTX · ZIP · fotos · escaneos
       |
   01 ENTRADA    el original, donde este. NUNCA se mueve ni se toca.
       |
  NORMALIZADOR   10_ingesta — automatico cada 10 min, o un clic
       |
  02 PROCESADO   el .md, con metadatos.  estado: sin_validar
       |
  03 VALIDADO    el MISMO .md.           estado: validado + quien y cuando
       |
        IA       Claude · NotebookLM · lo que venga
```

**Las etapas son estados, no carpetas.** Si fueran carpetas, el mismo documento viviria
en tres lugares a la vez: es el doble dueño que prohibe el principio rector, y termina
en "cual de las tres copias es la buena". El campo `estado` del encabezado de cada `.md`
**es** la etapa; el documento no se muda, cambia de estado.

Estado al 2026-08-17: **la etapa 03 no existe todavia.** 31 archivos dicen
`sin_validar` y no hay nada que lo cambie. Falta definir —es criterio de MJM, no
tecnico— que significa validar: leerlo, cotejarlo contra el original, confirmar que el
OCR no se comio nada.

## Pendientes

- ~~`C:\Noesis\10_ingesta` no está en ningún repositorio~~ — **resuelto el 2026-08-18.**
  Tiene repo propio y privado: `noesis-ingesta`. La decisión abierta se cerró por repo
  propio y no por mover el repo un nivel arriba, porque `C:\Noesis` contiene los enlaces
  `_biblioteca` y `_contexto` que apuntan a papeles de clientes en Drive, más otros tres
  repos adentro: un repo ahí arriba ponía el anonimato a un descuido de distancia.

- **Cuatro carpetas de trabajo duplicadas** entre `C:\Users\M01\Desktop` y
  `G:\...\01_Casos_Activos`, con distinta cantidad de archivos y distinta fecha en cada
  lado. Cotejar una por una, empezando por la más chica. El detalle con nombres está
  fuera del repo, en `_local_pendientes.md` (excluido por `.gitignore`).
- ~~Desinstalar Adobe Creative Cloud y TeamViewer~~ — **resuelto.** `INVENTARIO.md`
  confirmó el 2026-08-18 que ya no están: cero coincidencias contra la tabla de
  Prohibidos.
- ~~Dar de baja la suscripción de Microsoft 365~~ — **no hay nada que hacer.** Verificado
  el 2026-08-17: la facturación periódica ya estaba desactivada. Está pagada hasta el
  16 de abril de 2027 y ahí se apaga sola. **No activar la renovación** aunque Microsoft
  la ofrezca con un mes gratis: sería comprometerse a otro año de algo desinstalado.
- **Ficha de adaptador de Marker**: pasó a ser pieza estructural y la constitución (§8)
  la exige.
- Circuitos viejos de conversión sin jubilar: `99_experimentos\marker_pdfs` y
  `Downloads\Noesis`.
- ~~7 carpetas vacías y sin dueño en `C:\Noesis`~~ — **resuelto el 2026-08-18.** El panel
  las detectó (sección "Mapa de carpetas") comparando el disco contra esta tabla:
  `00_inbox`, `05_audio`, `10_fuentes_md`, `20_fichas`, `30_patrones`, `99_procesados`,
  `_logs`. Ninguna estaba vigilada por `10_ingesta\noesis_ingesta.py` ni referenciada en
  ningún código — eran resto del diseño viejo por carpetas, ya reemplazado por "las
  etapas son estados, no carpetas". MJM decidió borrar las siete en vez de declararlas.
  Si el circuito de audio llega a necesitar una carpeta propia, se crea entonces, con
  dueño declarado desde el día uno.
