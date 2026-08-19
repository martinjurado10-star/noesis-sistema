@echo off
rem NOESIS - Chrome en modo depuracion remota (puerto 9222).
rem Sirve para que Claude (u otra herramienta) se conecte a UN Chrome visible
rem y lo maneje: navegar, extraer, inspeccionar. Ver NOESIS_CHROME_STACK.md.
rem
rem Chrome moderno (136+) exige un perfil SEPARADO para aceptar la depuracion
rem remota. Ese perfil vive fuera de los repos, con sus cookies y sesiones:
set PERFIL=%LOCALAPPDATA%\Noesis\chrome_debug

if not exist "%PERFIL%" mkdir "%PERFIL%"

start "" "C:\Program Files\Google\Chrome\Application\chrome.exe" ^
  --remote-debugging-port=9222 ^
  --user-data-dir="%PERFIL%" ^
  --no-first-run --no-default-browser-check

echo.
echo Chrome lanzado con puerto de depuracion 9222 (perfil aparte, no el tuyo).
echo Para que el MCP maneje ESTE Chrome en vez de abrir uno propio:
echo    playwright-mcp --cdp-endpoint http://127.0.0.1:9222
echo.
