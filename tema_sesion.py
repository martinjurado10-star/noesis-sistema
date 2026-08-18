#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
NOESIS - Que tema es esta sesion, segun la carpeta que abriste.

Lo corre Claude Code solo, al abrir cada sesion (hook SessionStart).
Mira la carpeta de trabajo y le dice a Claude cuatro cosas:
  - de que tema se habla en esta sesion
  - donde se guarda lo que se produzca
  - que NO corresponde hacer aca
  - si el pedido es de otro lado, con que comando exacto se va

POR QUE EXISTE
    La carpeta que abris ES la declaracion del tema. Una sesion con tres
    temas adentro relee los tres en cada turno; ese fue el gasto grande.
    No lo causa el historial viejo -Claude no lo lee- sino la sesion larga.

La salida sale en ASCII puro a proposito: la consola de Windows rompe
los acentos y el hook tiene que llegar entero.

No falla nunca a proposito: ante cualquier error se calla y deja pasar.
"""
import os, sys, json


def tema(cwd):
    """Devuelve (titulo, donde_guardar, que_no_va) segun la carpeta."""
    c = cwd.replace("/", "\\").rstrip("\\").lower()

    # --- casos: eso es Cowork, no Code ---
    if "01_casos_activos" in c or "02_casos_archivados" in c:
        return ("UN CASO — y no se trabaja acá",
                "no se produce nada acá",
                "Redactar sobre un expediente es de **Cowork**, no de Claude "
                "Code. Frenalo en una línea y mandalo a la superficie que "
                "corresponde. Acá solo se construye el motor.")

    # --- el motor legal: skills, Capa 2 ---
    if "01_cerebro" in c:
        return ("SKILLS JURÍDICAS (Capa 2 — dominio)",
                r"C:\Noesis\01_cerebro (repo noesis-legal)",
                "Nada de configurar la máquina ni instalar: eso es Capa 3 y va "
                r"en C:\Noesis\00_sistema. No mezclar capas.")

    # --- la constitucion, Capa 1 ---
    if "00_nucleo" in c:
        return ("LA CONSTITUCIÓN (Capa 1 — método)",
                r"C:\Noesis\00_nucleo (repo noesis)",
                "Ni skills de derecho ni instalaciones. Solo método, "
                "epistemología y ADR.")

    # --- papeles a texto ---
    if "10_ingesta" in c:
        return ("INGESTA — papeles a texto",
                r"C:\Noesis\10_ingesta (repo noesis-ingesta)",
                "Si el pedido es instalar o configurar la máquina, eso va en "
                r"C:\Noesis\00_sistema.")

    # --- la maquina: raiz de los discos, o la carpeta de sistema ---
    if "00_sistema" in c or c.endswith(":"):
        return ("EL SISTEMA — programar la máquina, instalar, configurar",
                r"C:\Noesis\00_sistema — TODO lo que se produzca va acá",
                "Nada de derecho: ni skills jurídicas ni escritos. Si el pedido "
                "es de un caso, frenalo y mandalo a Cowork.")

    return (None, None, None)


# Cuando el pedido no es de esta sesion, no alcanza con decirle que no:
# hay que darle el comando escrito para que copie y pegue.
DERIVAR = """SI EL PEDIDO NO ES DE ESTE TEMA, FRENALO Y DALE EL COMANDO YA ESCRITO.
No expliques la teoría: una línea de por qué, y abajo el comando en un
bloque bash para que lo copie. El mapa:

  Programar la máquina, instalar, configurar
      cd C:\\Noesis\\00_sistema  (y abrir Claude Code ahí)
  Skills jurídicas (concursos, liquidar, contratos)
      cd C:\\Noesis\\01_cerebro
  Papeles a texto, Marker, audios
      cd C:\\Noesis\\10_ingesta
  Método, constitución, ADR
      cd C:\\Noesis\\00_nucleo

  Escribir sobre un caso real, un escrito, una demanda
      No es Claude Code. Es **Cowork** (claude.ai/cowork).
  Pensar en voz alta, discutir una estrategia, borradores
      No es Claude Code. Es **Claude Chat** (claude.ai).
  Mapear un PDF largo o muchos documentos de un caso
      No es Claude Code. Es **NotebookLM**, y el material sale de
      G:\\Mi unidad\\ESTUDIO JURIDICO NOESIS\\04_Contexto\\material_convertido
"""

CIERRE = """AL CERRAR LA SESIÓN: si aprendimos una regla que sirva para la próxima,
sumala a C:\\Noesis\\00_sistema\\PROTOCOLO.md antes de terminar. El protocolo
crece con el uso; una regla que no queda escrita se pierde."""


def main():
    try:
        cwd = os.getcwd()
        try:
            entrada = sys.stdin.read()
            if entrada.strip():
                d = json.loads(entrada)
                cwd = d.get("cwd") or d.get("workspace") or cwd
        except Exception:
            pass

        titulo, donde, prohibido = tema(cwd)
        if not titulo:
            texto = (
                f"La carpeta abierta ({cwd}) no es ninguna de las declaradas.\n"
                "Antes de trabajar, preguntale a MJM de qué tema es esta sesión "
                "y dónde se guarda lo que se produzca.\n\n" + DERIVAR
            )
            salida = {"hookSpecificOutput": {
                "hookEventName": "SessionStart", "additionalContext": texto}}
        else:
            texto = (
                f"TEMA DE ESTA SESIÓN, según la carpeta abierta ({cwd}):\n"
                f"  {titulo}\n\n"
                f"DÓNDE SE GUARDA LO QUE SE PRODUZCA:\n  {donde}\n\n"
                f"QUÉ NO CORRESPONDE ACÁ:\n  {prohibido}\n\n"
                "Regla de MJM: una sesión, un tema.\n\n"
                + DERIVAR + "\n" + CIERRE
            )
            salida = {
                "systemMessage": f"Sesion: {titulo}",
                "hookSpecificOutput": {
                    "hookEventName": "SessionStart",
                    "additionalContext": texto},
            }
        # ensure_ascii=True: los acentos viajan como \uXXXX y no se rompen
        print(json.dumps(salida))
    except Exception:
        pass   # un hook que rompe la sesion es peor que no tener hook


if __name__ == "__main__":
    main()
