# Diseño del sistema — máquina MJM

Este archivo es **la fuente única** de cómo está armada esta computadora: qué hay
instalado, por qué, y qué está prohibido. Si algo se instala, se declara acá primero.

Última revisión: **2026-08-17**

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

## La regla

> **Una herramienta para cada cosa. Una sola.**

Y el corolario, que es el que decide los casos difíciles:

> **Cero Microsoft en la capa de documentos.** Microsoft queda solo como infraestructura
> inevitable: el sistema operativo y GitHub como repositorio remoto.

GitHub es de Microsoft desde 2018 y Windows también: la regla literal "cero Microsoft"
dejaría la máquina sin sistema y sin repositorio. La línea real es **la capa de
documentos** — ahí no entra: ni Word, ni Excel, ni OneDrive.

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
| Microsoft 365 (Word, Excel) | capa de documentos — la cubre Google |
| OneDrive | capa de documentos — la cubre Drive |
| Copilot | duplica a Claude |
| WSL / Linux | segundo sistema; no acelera nada de lo que se hace acá |
| Adobe Creative Cloud | app suelta por tarea; la cubre Canva |
| Notion | duplica notas y documentos con Google Docs y Drive |
| TeamViewer | sin uso; y un acceso remoto sin usar es una puerta abierta |
| iLovePDF, CamScanner y similares | **lo hace la propia máquina** desde el 2026-08-17 |
| Un segundo intérprete de Python | fuente de "¿con cuál corre esto?" |

**Sobre Office, con dato:** en toda la máquina hay **cero archivos con macros** (`.xlsm`,
`.docm`) y cero bases Access — medido el 2026-08-17. Es lo único que Google Sheets no
ejecuta. Sin eso, Office no aporta nada: lo que le mandan a MJM en Word o Excel lo abre
desde Drive igual.

Lo de iLovePDF y CamScanner es lo más importante de esa tabla: no son programas
instalados, son **hábitos**. Convertir, escanear y sacar texto ya lo hace `10_ingesta`
sin subir el documento a ningún sitio web.

---

## Las carpetas

| Carpeta | Qué gobierna |
|---|---|
| `C:\Noesis\00_sistema` | **este diseño** y la instalación de todo |
| `C:\Noesis\_contexto` | perfil de MJM y manual de uso |
| `C:\Noesis\01_cerebro` | las skills, versionadas en git |
| `C:\Noesis\10_ingesta` | la conversión automática a Markdown |
| `C:\Noesis\99_experimentos` | banco de pruebas — nada estructural vive acá |
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

## Pendientes

- **Cuatro carpetas de trabajo duplicadas** entre `C:\Users\M01\Desktop` y
  `G:\...\01_Casos_Activos`, con distinta cantidad de archivos y distinta fecha en cada
  lado. Cotejar una por una, empezando por la más chica. El detalle con nombres está
  fuera del repo, en `_local_pendientes.md` (excluido por `.gitignore`).
- **Desinstalar Adobe Creative Cloud y TeamViewer.** Son los dos que quedan. Correr de
  nuevo `terminar_sistema.ps1` como administrador: los pasos ya hechos se saltean solos.
  **Adobe abre su propia ventana y hay que apretar "Desinstalar" ahí** — no tiene modo
  silencioso.
- ~~Dar de baja la suscripción de Microsoft 365~~ — **no hay nada que hacer.** Verificado
  el 2026-08-17: la facturación periódica ya estaba desactivada. Está pagada hasta el
  16 de abril de 2027 y ahí se apaga sola. **No activar la renovación** aunque Microsoft
  la ofrezca con un mes gratis: sería comprometerse a otro año de algo desinstalado.
- **Ficha de adaptador de Marker**: pasó a ser pieza estructural y la constitución (§8)
  la exige.
- Circuitos viejos de conversión sin jubilar: `99_experimentos\marker_pdfs` y
  `Downloads\Noesis`.
