---
description: Ritual de cierre de sesión (HANDOFF §6 / regla 10) — los cinco pasos, siempre en el mismo orden.
---

Ejecutá el cierre de sesión, en este orden exacto, sin saltear ni reordenar pasos:

1. **Verificar anonimato.** Repasar los cambios de la sesión (`git diff` / `git status`)
   y confirmar que no hay nombre de cliente, número de expediente ni matrícula en nada
   de lo que se va a commitear.
2. **Commitear y hacer `push`, sin que haga falta pedirlo.** Sobre el/los repo(s)
   tocados en la sesión.
3. **Informar el costo.** Correr `python costo.py` (desde `C:\Noesis\00_sistema`) y
   mostrar el resultado tal cual sale.
4. **Sumar a `PROTOCOLO.md` la regla que haya dejado la sesión, si dejó alguna.** Solo
   si algo costó —un error repetido, plata que se fue, una sesión que hubo que rehacer.
   No agregar buenas intenciones.
5. **Reescribir el `HANDOFF.md`** de la carpeta de trabajo actual con el estado presente
   (no acumula historia, se pisa a sí mismo) y entregarlo por chat como archivo adjunto.

No agregues resumen ni texto de cortesía fuera de estos cinco pasos.
