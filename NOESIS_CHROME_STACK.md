# NOESIS — Stack de Chrome

Capa de ingestión y navegación web: qué tiene el navegador, cómo entra una página
al sistema como `.md`, y cómo navega Claude. Todo gratuito.
Fecha de captura de los links: **2026-08-19**. Si un link muere, buscar el nombre
exacto en `chromewebstore.google.com`.

---

## Las cuatro extensiones

| Extensión | Para qué | Instalar (un clic de MJM) |
|---|---|---|
| **Extensity** | Prender y apagar extensiones en un clic, y armar **perfiles** (grupos): las apagadas no gastan RAM. | [Chrome Web Store](https://chromewebstore.google.com/detail/extensity/jjmflmamggggndanpgfnpelongoepncg) |
| **MarkDownload — Markdown Web Clipper** | La página que estás viendo → **Markdown estructurado**, sin menús ni código basura. Para artículos y notas. | [Chrome Web Store](https://chromewebstore.google.com/detail/markdownload-markdown-web/pcmpcfapbekmbjjkdalcgopdkipoggdi) |
| **SingleFile** | Guarda la página **completa en un solo `.html`** en Descargas: captura offline, prueba de cómo se veía ese día. | [Chrome Web Store](https://chromewebstore.google.com/detail/singlefile/mpiodijhokgodhhofbcjdecpffjipkle) |
| **JSON Formatter** | Al abrir una API o un `.json` en el navegador lo muestra ordenado y plegable. Automático, sin botones. | [Chrome Web Store](https://chromewebstore.google.com/detail/json-formatter/bcjindcccaagfpapjjmafapmmgkkhgoa) |

- La instalación es **un clic de MJM** en cada link — Claude deja todo hasta la puerta
  (regla del `PROTOCOLO.md`: la credencial y el clic son de MJM).
- Atajos de teclado de cada extensión: se configuran en `chrome://extensions/shortcuts`.

## Ahorro de RAM que ya viene de fábrica

Antes que cualquier extensión: `chrome://settings/performance` → activar
**Ahorro de memoria** (duerme las pestañas que no estás usando). Es de Chrome,
no suma ninguna pieza al stack.

---

## El circuito: de la página al `.md`

```
 ver una página en Chrome
    ├─ MarkDownload → baja el .md directo               (artículos, lo rápido)
    ├─ SingleFile   → .html a Descargas
    │                    └─ python web_a_md.py --barrido → material_convertido
    └─ URL suelta   → python web_a_md.py <url>          (sin abrir el navegador)
```

`web_a_md.py` vive en `C:\Noesis\10_ingesta` — mismo dueño que `noesis_ingesta.py`:
aquel convierte papeles, este convierte lo que se ve en el navegador. Motor:
**trafilatura** (biblioteca de Python que extrae el contenido útil y descarta el
resto). Todo `.md` sale con **fecha de captura** en el encabezado.

---

## Navegación por Claude (MCP)

**MCP** (*Model Context Protocol*): el enchufe estándar con el que Claude usa
herramientas externas — acá, un navegador.

- **Servidor registrado:** `playwright-mcp` (instalado global con npm), en la
  configuración de usuario de Claude Code — sirve en cualquier carpeta.
  Verificar: `claude mcp list`. Abre el **Chrome ya instalado** bajo demanda con
  un perfil propio; cuando no se usa, no gasta ni RAM ni nada.
- **Modo puente (Chrome visible):** doble clic en `chrome_debug.bat`
  (acceso directo **CHROME PARA CLAUDE** en el Escritorio). Abre un Chrome con
  el puerto de depuración 9222 y un perfil aparte — el perfil personal no se toca.
  Para que el MCP maneje *ese* Chrome en lugar de abrir uno propio:
  `playwright-mcp --cdp-endpoint http://127.0.0.1:9222`.
- En la app de escritorio de Claude además existe la extensión **Claude in
  Chrome**, que le muestra a Claude el Chrome real con tus sesiones. El MCP no la
  duplica: cubre las sesiones de terminal y la extracción por script.
