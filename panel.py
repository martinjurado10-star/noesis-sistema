#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
NOESIS - Panel del sistema.

Mira el estado real de la maquina y lo muestra en una pagina que se abre
en el navegador. No instala ni desinstala nada: solo mira.

    python panel.py            genera y abre el panel
    python panel.py --solo     lo genera sin abrirlo

Los datos del stack salen de stack.json. El por que de cada decision,
de SISTEMA.md.
"""
import os, re, sys, json, socket, datetime, subprocess, webbrowser, winreg
from pathlib import Path

BASE    = Path(__file__).parent
INGESTA = Path(r"C:\Noesis\10_ingesta")
SALIDA  = BASE / "panel.html"


# ============================================================
#  Recoleccion de datos
# ============================================================
def programas_instalados():
    """Lee el registro de Windows: que hay instalado en esta maquina."""
    nombres, ramas = set(), [
        (winreg.HKEY_LOCAL_MACHINE, r"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"),
        (winreg.HKEY_LOCAL_MACHINE, r"SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall"),
        (winreg.HKEY_CURRENT_USER,  r"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"),
    ]
    for raiz, ruta in ramas:
        try:
            with winreg.OpenKey(raiz, ruta) as k:
                for i in range(winreg.QueryInfoKey(k)[0]):
                    try:
                        with winreg.OpenKey(k, winreg.EnumKey(k, i)) as sk:
                            nombres.add(winreg.QueryValueEx(sk, "DisplayName")[0])
                    except OSError:
                        pass
        except OSError:
            pass
    return nombres


def _ps(comando, timeout=90):
    try:
        r = subprocess.run(["powershell", "-NoProfile", "-Command", comando],
                           capture_output=True, text=True, encoding="utf-8",
                           errors="replace", timeout=timeout)
        return r.stdout.strip()
    except Exception:
        return ""


def esta_de_verdad(item, instalados):
    """El registro de Windows deja entradas muertas: un programa desinstalado
    sigue figurando ahi. Por eso, cuando hay forma de mirar el programa real
    (una ruta, la lista de apps, las distros de Linux), se mira eso."""
    if "ruta" in item:
        return Path(os.path.expandvars(item["ruta"])).exists()

    modo = item.get("comprobar")
    if modo == "appx":
        salida = _ps(f"(Get-AppxPackage -Name '*{item['detectar']}*').Name")
        return bool(salida)
    if modo == "wsl":
        salida = _ps("wsl.exe --list --quiet").replace("\x00", "").strip()
        return bool(salida)   # wsl.exe viene con Windows: lo que cuenta es si hay distros

    clave = item.get("detectar", item["nombre"])
    return any(clave.lower() in n.lower() for n in instalados)


def hardware():
    ps = ("$g=Get-CimInstance Win32_VideoController|Select-Object -First 1;"
          "$c=Get-CimInstance Win32_Processor|Select-Object -First 1;"
          "@{gpu=$g.Name;cpu=$c.Name;nucleos=$c.NumberOfCores;"
          "ram=[math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory/1GB,0)}"
          "|ConvertTo-Json -Compress")
    try:
        r = subprocess.run(["powershell", "-NoProfile", "-Command", ps],
                           capture_output=True, text=True, encoding="utf-8",
                           errors="replace", timeout=60)
        return json.loads(r.stdout)
    except Exception:
        return {}


def ingesta():
    """Cuanto convirtio el circuito de ingesta y que quedo esperando."""
    d = {"total": 0, "pendientes": 0, "ultimo": None, "cuando": None, "activo": False}
    f = INGESTA / "_estado" / "hechos.json"
    if f.exists():
        try:
            h = json.loads(f.read_text(encoding="utf-8"))
            d["total"] = len(h)
            d["pendientes"] = sum(1 for v in h.values() if v.get("pendiente_ocr"))
            if h:
                u = max(h.values(), key=lambda v: v.get("fecha", ""))
                d["ultimo"] = u.get("archivo")
                d["cuando"] = (u.get("fecha") or "")[:16].replace("T", " ")
        except Exception:
            pass
    try:
        r = subprocess.run(["powershell", "-NoProfile", "-Command",
                            "(Get-ScheduledTask -TaskName 'Noesis-Ingesta' "
                            "-ErrorAction SilentlyContinue).State"],
                           capture_output=True, text=True, timeout=60)
        d["activo"] = "Ready" in r.stdout or "Running" in r.stdout
    except Exception:
        pass
    return d


def pendientes():
    """Saca la lista de pendientes de SISTEMA.md, sin duplicarla aca."""
    f = BASE / "SISTEMA.md"
    if not f.exists():
        return []
    txt = f.read_text(encoding="utf-8")
    m = re.search(r"##\s*Pendientes\s*\n(.+?)(?=\n##\s|\Z)", txt, re.S)
    if not m:
        return []
    items, actual = [], ""
    for linea in m.group(1).splitlines():
        if linea.startswith("- "):
            if actual:
                items.append(actual.strip())
            actual = linea[2:]
        elif linea.strip() and actual:
            actual += " " + linea.strip()
    if actual:
        items.append(actual.strip())
    # limpieza de marcas de markdown
    return [re.sub(r"[*`~]|\[|\]\(.*?\)", "", i).strip() for i in items]


# ============================================================
#  La pagina
# ============================================================
CSS = """
:root{
  --fondo:#faf9f7; --tarjeta:#ffffff; --borde:#e7e5e4; --texto:#1c1917;
  --suave:#78716c; --ok:#15803d; --ok-f:#f0fdf4; --mal:#b91c1c; --mal-f:#fef2f2;
  --aviso:#b45309; --aviso-f:#fffbeb; --acento:#0f766e;
}
@media (prefers-color-scheme: dark){
  :root:not([data-theme="light"]){
    --fondo:#1c1917; --tarjeta:#292524; --borde:#44403c; --texto:#f5f5f4;
    --suave:#a8a29e; --ok:#4ade80; --ok-f:#14261a; --mal:#f87171; --mal-f:#2a1616;
    --aviso:#fbbf24; --aviso-f:#2a2010; --acento:#5eead4;
  }
}
:root[data-theme="dark"]{
  --fondo:#1c1917; --tarjeta:#292524; --borde:#44403c; --texto:#f5f5f4;
  --suave:#a8a29e; --ok:#4ade80; --ok-f:#14261a; --mal:#f87171; --mal-f:#2a1616;
  --aviso:#fbbf24; --aviso-f:#2a2010; --acento:#5eead4;
}
*{box-sizing:border-box}
body{margin:0;background:var(--fondo);color:var(--texto);
  font:16px/1.55 -apple-system,"Segoe UI",system-ui,sans-serif;padding:32px 20px 64px}
.envoltorio{max-width:1080px;margin:0 auto}
header{margin-bottom:28px}
h1{font-size:30px;margin:0 0 6px;letter-spacing:-.02em}
.sub{color:var(--suave);font-size:14px}
.estado{display:inline-flex;align-items:center;gap:10px;padding:14px 20px;border-radius:12px;
  font-size:17px;font-weight:600;margin:20px 0 28px;width:100%}
.estado.ok{background:var(--ok-f);color:var(--ok);border:1px solid var(--ok)}
.estado.mal{background:var(--mal-f);color:var(--mal);border:1px solid var(--mal)}
.punto{width:11px;height:11px;border-radius:50%;background:currentColor;flex:none}
.grilla{display:grid;grid-template-columns:repeat(auto-fit,minmax(320px,1fr));gap:18px}
.tarjeta{background:var(--tarjeta);border:1px solid var(--borde);border-radius:14px;padding:22px}
.tarjeta h2{font-size:12px;text-transform:uppercase;letter-spacing:.09em;
  color:var(--suave);margin:0 0 16px;font-weight:600}
.fila{display:flex;align-items:baseline;gap:10px;padding:9px 0;border-bottom:1px solid var(--borde)}
.fila:last-child{border-bottom:0}
.marca{font-weight:700;flex:none;width:18px}
.marca.si{color:var(--ok)} .marca.no{color:var(--mal)}
.marca.nube{color:var(--acento);font-size:11px}
.que{font-weight:600} .porque{color:var(--suave);font-size:13px;margin-left:auto;text-align:right}
.numeros{display:flex;gap:32px;flex-wrap:wrap;margin-bottom:14px}
.numero{font-size:38px;font-weight:700;line-height:1;letter-spacing:-.02em}
.etiqueta{font-size:12px;color:var(--suave);text-transform:uppercase;letter-spacing:.06em;margin-top:6px}
.nota{background:var(--aviso-f);color:var(--aviso);border:1px solid var(--aviso);
  border-radius:10px;padding:13px 16px;font-size:14px;margin-top:14px}
ul.pend{margin:0;padding-left:20px} ul.pend li{margin-bottom:11px;font-size:14.5px}
.ancho{grid-column:1/-1}
.flujo{display:flex;align-items:stretch;gap:10px;flex-wrap:wrap}
.paso{flex:1 1 190px;display:flex;gap:11px;align-items:flex-start;
  background:var(--fondo);border:1px solid var(--borde);border-radius:10px;padding:14px}
.paso.destacado{border-color:var(--acento);border-width:2px}
.paso-n{flex:none;width:23px;height:23px;border-radius:50%;background:var(--acento);
  color:var(--tarjeta);font-size:12px;font-weight:700;display:flex;
  align-items:center;justify-content:center}
.ruta{color:var(--suave);font-size:12.5px;line-height:1.45}
.flecha{align-self:center;color:var(--suave);font-size:19px}
@media(max-width:760px){.flecha{display:none}}
footer{margin-top:32px;color:var(--suave);font-size:13px;text-align:center}
code{background:var(--fondo);border:1px solid var(--borde);border-radius:5px;
  padding:2px 6px;font-size:13px}
"""


def html(datos):
    st, loc, srv, pr, hw, ing, pend = (
        datos[k] for k in ("stack", "local", "servicios", "prohibidos", "hw", "ingesta", "pendientes"))
    faltan = [x for x in st if not x["hay"]] + [x for x in loc if not x["hay"]]
    sobran = [x for x in pr if x["hay"]]
    limpio = not faltan and not sobran

    def filas(items):
        return "".join(
            f'<div class="fila"><span class="marca {"si" if x["hay"] else "no"}">'
            f'{"OK" if x["hay"] else "!"}</span>'
            f'<span class="que">{x["nombre"]}</span>'
            f'<span class="porque">{x["funcion"]}</span></div>' for x in items)

    filas_stack = filas(st)
    filas_local = filas(loc)
    filas_srv = "".join(
        f'<div class="fila"><span class="marca nube">&#9679;</span>'
        f'<span class="que">{x["nombre"]}</span>'
        f'<span class="porque">{x["funcion"]}</span></div>' for x in srv)

    if sobran:
        filas_proh = "".join(
            f'<div class="fila"><span class="marca no">!</span>'
            f'<span class="que">{x["nombre"]}</span>'
            f'<span class="porque">{x["motivo"]}</span></div>' for x in sobran)
    else:
        filas_proh = ('<div class="fila"><span class="marca si">OK</span>'
                      '<span class="que">Nada prohibido instalado</span></div>')

    aviso_gpu = ""
    if "Intel" in hw.get("gpu", "") or "UHD" in hw.get("gpu", ""):
        aviso_gpu = ('<div class="nota"><b>Sin placa de video dedicada.</b> Nada que pida '
                     'una placa (modelos de visión, IA local grande). Por eso el OCR de todos '
                     'los días es Tesseract y no Marker: 5 segundos contra 20 minutos por página.</div>')

    aviso_ocr = ""
    if ing["pendientes"]:
        aviso_ocr = (f'<div class="nota">{ing["pendientes"]} documento(s) esperando OCR. '
                     f'Para verlos: <code>python noesis_ingesta.py --pendientes</code></div>')

    lista_pend = "".join(f"<li>{p}</li>" for p in pend) or "<li>Nada pendiente.</li>"

    return f"""<!doctype html>
<html lang="es"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Panel del sistema</title><style>{CSS}</style></head><body>
<div class="envoltorio">
  <header>
    <h1>Panel del sistema</h1>
    <div class="sub">{socket.gethostname()} &middot; {datos['momento']}</div>
  </header>

  <div class="estado {'ok' if limpio else 'mal'}">
    <span class="punto"></span>
    {'Todo en orden: el stack está completo y no hay nada prohibido.'
     if limpio else
     f"Hay {len(faltan) + len(sobran)} cosa(s) para resolver — están marcadas abajo."}
  </div>

  <div class="grilla">
    <div class="tarjeta">
      <h2>Programas &middot; una herramienta por función</h2>
      {filas_stack}
    </div>

    <div class="tarjeta">
      <h2>Piezas propias &middot; puestas a mano, acá adentro</h2>
      {filas_local}
    </div>

    <div class="tarjeta">
      <h2>Servicios &middot; viven en la nube, no se instalan</h2>
      {filas_srv}
    </div>

    <div class="tarjeta">
      <h2>Lo que no debe estar</h2>
      {filas_proh}
    </div>

    <div class="tarjeta">
      <h2>Ingesta &middot; papeles convertidos a texto</h2>
      <div class="numeros">
        <div><div class="numero">{ing['total']}</div><div class="etiqueta">convertidos</div></div>
        <div><div class="numero">{ing['pendientes']}</div><div class="etiqueta">esperando OCR</div></div>
      </div>
      <div class="fila"><span class="que">Vigía automático</span>
        <span class="porque">{'activo, cada 10 min' if ing['activo'] else 'APAGADO'}</span></div>
      {f'<div class="fila"><span class="que">Último</span><span class="porque">{ing["ultimo"]} &middot; {ing["cuando"]}</span></div>' if ing['ultimo'] else ''}
      {aviso_ocr}
    </div>

    <div class="tarjeta">
      <h2>La máquina</h2>
      <div class="fila"><span class="que">Procesador</span><span class="porque">{hw.get('cpu','?')}</span></div>
      <div class="fila"><span class="que">Memoria</span><span class="porque">{hw.get('ram','?')} GB</span></div>
      <div class="fila"><span class="que">Video</span><span class="porque">{hw.get('gpu','?')}</span></div>
      {aviso_gpu}
    </div>

    <div class="tarjeta ancho">
      <h2>El flujo &middot; de dónde entra y a dónde va</h2>
      <div class="flujo">
        <div class="paso">
          <div class="paso-n">1</div>
          <div><b>Entra</b><br><span class="ruta">Descargas · Escritorio · Documentos<br>G:\Mi unidad (todo el Drive)</span></div>
        </div>
        <div class="flecha">&rarr;</div>
        <div class="paso">
          <div class="paso-n">2</div>
          <div><b>Se convierte solo</b><br><span class="ruta">cada 10 minutos<br>PDF, Word, Excel, fotos, ZIP</span></div>
        </div>
        <div class="flecha">&rarr;</div>
        <div class="paso">
          <div class="paso-n">3</div>
          <div><b>Queda el texto</b><br><span class="ruta">en <code>_md</code>, al lado del papel<br>lo de Descargas, en el depósito</span></div>
        </div>
        <div class="flecha">&rarr;</div>
        <div class="paso destacado">
          <div class="paso-n">4</div>
          <div><b>PREPARAR PARA IA</b><br><span class="ruta">un clic en el Escritorio:<br>arma UN archivo y abre la carpeta</span></div>
        </div>
      </div>
      <div class="nota" style="background:var(--ok-f);color:var(--ok);border-color:var(--ok)">
        <b>Para subir a NotebookLM o a un proyecto:</b> el archivo que termina en
        <code>__para_notebooklm.md</code> — es todo junto, con índice.
        NotebookLM admite 50 fuentes por notebook, así que conviene uno solo y no 45 sueltos.
      </div>
    </div>

    <div class="tarjeta ancho">
      <h2>Pendientes</h2>
      <ul class="pend">{lista_pend}</ul>
    </div>
  </div>

  <footer>
    El por qué de cada decisión está en <code>SISTEMA.md</code>.
    Para actualizar este panel, doble clic en <code>panel.bat</code>.
  </footer>
</div></body></html>"""


# ============================================================
def main():
    cfg = json.loads((BASE / "stack.json").read_text(encoding="utf-8"))
    inst = programas_instalados()

    def hay(clave):
        return any(clave.lower() in n.lower() for n in inst)

    datos = {
        "momento": datetime.datetime.now().strftime("%d/%m/%Y %H:%M"),
        "stack": [{**x, "hay": hay(x["detectar"])} for x in cfg["programas"]],
        "local": [{**x, "hay": Path(os.path.expandvars(x["ruta"])).exists()}
                  for x in cfg["local"] if x.get("ruta")],
        "servicios": cfg["servicios"],
        "prohibidos": [{**x, "hay": esta_de_verdad(x, inst)} for x in cfg["prohibidos"]],
        "hw": hardware(),
        "ingesta": ingesta(),
        "pendientes": pendientes(),
    }

    SALIDA.write_text(html(datos), encoding="utf-8")
    print(f"panel generado: {SALIDA}")
    if "--solo" not in sys.argv:
        webbrowser.open(SALIDA.as_uri())


if __name__ == "__main__":
    main()
