# Mapa de carpetas — qué es cada una

No son los nombres técnicos explicados otra vez: es la pregunta "¿qué hago si
me pierdo acá?" contestada en una línea por carpeta.

## Las seis de arriba de `C:\Noesis`

| Carpeta | Qué es |
|---|---|
| `00_nucleo` | El método. Las reglas base de Noesis (la "constitución"). Casi nunca se toca. |
| `00_sistema` | La máquina. Acá se instala, se configura, se programa el entorno — nada de Derecho. |
| `01_cerebro` | Las skills jurídicas. Lo que Claude sabe hacer en un caso (concursos, liquidaciones, contratos). |
| `02_marketplace` | Lo publicable. Solo material ya anonimizado, listo para compartir afuera. |
| `10_ingesta` | El conversor de papeles a texto. El motor que convierte todo a `.md` automáticamente. |
| `99_experimentos` | El nombre miente: acá viven motores en uso real (Marker, llama-server). Se renombra el día que haya que tocar Marker — ver la deuda de nombre en `SISTEMA.md`. |

## Adentro de `00_sistema`

| Carpeta | Qué es |
|---|---|
| `_PRIVADO` | Lo que nunca sale de esta máquina. Fuera de git, no se sube a ningún lado. |
| `_herramientas` | Instaladores y ejecutables sueltos del sistema operativo (no de Claude). |
| `claude_config` | La configuración de Claude Code que rige en esta carpeta. |

## Adentro de `10_ingesta`

| Carpeta | Qué es |
|---|---|
| `_estado` | El registro de qué ya se convirtió (para no repetirlo). |
| `_logs` | Qué se convirtió y qué falló, un archivo por mes. |
| `_tmp` | Archivos de trabajo del motor mientras convierte. Se puede vaciar sin miedo. |
| `tessdata` | El diccionario en castellano que usa el OCR para leer los escaneos. |

## Las que aparecen sueltas por todo el Drive

| Carpeta | Qué es |
|---|---|
| `_md` (al lado de cada documento) | Ahí vive el texto ya convertido de ese documento — lo que le das a la IA. |
| `_contexto` (atajo desde `C:\Noesis`) | Apunta a `04_Contexto` en el Drive: el perfil de MJM, el manual, y el depósito de todo lo convertido desde Descargas. |

---

**Por qué este archivo y no un cambio de nombres.** Renombrar las carpetas de
verdad rompe cosas que ya andan solas: el hook de `settings.json` apunta a
`00_sistema\tema_sesion.py` por ruta fija, `~/.claude/skills` es un *junction*
a `01_cerebro\skills`, `_contexto` es un atajo (*symlink*) al Drive, y
`noesis_ingesta.py` tiene rutas propias adentro. Cualquiera de esos cuatro se
corta si la carpeta cambia de nombre sin rehacer el enlace o editar el script.
Este mapa da la misma claridad sin tocar nada de eso. Si más adelante se
decide renombrar igual, es un trabajo aparte — no algo para resolver al cierre
de una sesión.
