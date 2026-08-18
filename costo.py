#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
NOESIS - Cuanto consumio cada sesion de Claude Code.

Claude Code deja el detalle de cada sesion en disco. Esto lo suma y lo
traduce a plata.

    python costo.py            resumen: hoy, este mes, historico
    python costo.py --detalle  sesion por sesion

OJO CON EL NUMERO
    Si trabajas con plan de suscripcion (Pro / Max), NO pagas por token:
    pagas la cuota fija. El monto de abajo es "cuanto habria costado por
    API" — sirve para dimensionar el uso, no es lo que se te cobra.
    Con credito de API, si es lo que se cobra.
"""
import sys, json, datetime, collections
from pathlib import Path

PROYECTOS = Path.home() / ".claude" / "projects"

# Precios de Claude Opus 5, por millon de tokens (verificados 2026-08-18)
USD_ENTRADA      = 5.00
USD_SALIDA       = 25.00
USD_CACHE_LEER   = 0.50    # 0.1x de la entrada
USD_CACHE_ESCRIBIR_5M = 6.25   # 1.25x
USD_CACHE_ESCRIBIR_1H = 10.00  # 2x — es el que usa esta sesion

DOLAR = None   # se completa a mano si se quiere ver en pesos


def leer_sesiones():
    """Cada .jsonl es una sesion. Devuelve tokens y fecha de cada una."""
    sesiones = []
    for f in PROYECTOS.rglob("*.jsonl"):
        t = collections.Counter()
        ultimo = None
        try:
            with open(f, encoding="utf-8", errors="replace") as fh:
                for linea in fh:
                    if '"usage"' not in linea:
                        continue
                    try:
                        d = json.loads(linea)
                    except Exception:
                        continue
                    u = (d.get("message") or {}).get("usage") or d.get("usage")
                    if not isinstance(u, dict):
                        continue
                    for k in ("input_tokens", "output_tokens",
                              "cache_creation_input_tokens",
                              "cache_read_input_tokens"):
                        t[k] += u.get(k) or 0
                    ultimo = d.get("timestamp") or ultimo
        except OSError:
            continue
        if not t:
            continue
        cuando = None
        if ultimo:
            try:
                cuando = datetime.datetime.fromisoformat(
                    ultimo.replace("Z", "+00:00")).date()
            except Exception:
                pass
        if cuando is None:
            cuando = datetime.date.fromtimestamp(f.stat().st_mtime)
        sesiones.append({"archivo": f.name[:8], "fecha": cuando, "tokens": t,
                         "proyecto": f.parent.name})
    return sorted(sesiones, key=lambda s: s["fecha"])


def costo(t, cache_1h=True):
    escribir = USD_CACHE_ESCRIBIR_1H if cache_1h else USD_CACHE_ESCRIBIR_5M
    return (t["input_tokens"]                 / 1e6 * USD_ENTRADA
            + t["output_tokens"]              / 1e6 * USD_SALIDA
            + t["cache_creation_input_tokens"] / 1e6 * escribir
            + t["cache_read_input_tokens"]     / 1e6 * USD_CACHE_LEER)


def plata(u):
    return f"USD {u:,.2f}" + (f"  (${u * DOLAR:,.0f})" if DOLAR else "")


def mostrar(titulo, ses):
    if not ses:
        return
    t = collections.Counter()
    for s in ses:
        t.update(s["tokens"])
    total = sum(t.values())
    print(f"\n  {titulo}")
    print(f"  {'-' * 58}")
    print(f"    sesiones           {len(ses):>14,}")
    print(f"    tokens totales     {total:>14,}")
    print(f"      entrada          {t['input_tokens']:>14,}")
    print(f"      salida           {t['output_tokens']:>14,}")
    print(f"      cache escrito    {t['cache_creation_input_tokens']:>14,}")
    print(f"      cache leido      {t['cache_read_input_tokens']:>14,}")
    print(f"    COSTO              {plata(costo(t)):>14}")


if __name__ == "__main__":
    ses = leer_sesiones()
    if not ses:
        print("\n  No encontre registros de sesiones en", PROYECTOS, "\n")
        sys.exit(0)

    hoy = datetime.date.today()
    print("\n  " + "=" * 58)
    print("   CUANTO CONSUMISTE — Claude Opus 5")
    print("  " + "=" * 58)

    mostrar("HOY", [s for s in ses if s["fecha"] == hoy])
    mostrar("ESTE MES", [s for s in ses if s["fecha"].year == hoy.year
                         and s["fecha"].month == hoy.month])
    mostrar("TODO", ses)

    if "--detalle" in sys.argv:
        print(f"\n  SESION POR SESION")
        print(f"  {'-' * 58}")
        for s in ses:
            tot = sum(s["tokens"].values())
            print(f"    {s['fecha']}  {s['archivo']}  "
                  f"{tot:>12,} tok   {plata(costo(s['tokens']))}")

    print(f"\n  {'-' * 58}")
    print("   Con plan de suscripcion NO pagas esto: pagas la cuota fija.")
    print("   El numero dimensiona el uso; no es lo que se te cobra.")
    print("   Precios Opus 5 por millon: entrada USD 5, salida USD 25,")
    print("   cache escrito USD 10 (TTL 1 hora), cache leido USD 0,50.")
    print()
