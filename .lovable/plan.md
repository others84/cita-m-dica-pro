# Citas públicas solo en horas completas

Cuando una paciente agenda desde la página pública, solo podrá elegir horas en punto (8:00, 9:00, 11:00...). La cita durará 1 hora: si elige 11:00, el sistema pondrá 12:00 como hora de término. Si por cualquier vía llega una hora con minutos (11:15, 11:30), el sistema recorta los minutos y la deja en 11:00.

## Qué cambia para la paciente

- El calendario muestra bloques de 1 hora; al tocar un bloque se toma la hora en punto.
- El campo "Hora inicio" solo acepta horas completas (paso de 60 minutos) y se ajusta solo si se escribe algo intermedio.
- El resumen dirá, por ejemplo: "Tu cita: lunes 31 de agosto de 2026 de 11:00 a 12:00 hrs".
- Texto de ayuda actualizado: la consulta dura 1 hora (hoy dice 30 minutos).

## Archivos a modificar (por prioridad)

1. `php-app/app/views/citapublica/index.php` — calendario y formulario público:
   - Opciones del calendario: `slotDuration: '01:00:00'`, `slotLabelInterval: '01:00:00'`, `snapDuration`/selección por hora.
   - En `tomar(start, end)`: normalizar minutos/segundos a `00` y calcular fin = inicio + 60 min (ignorando el `end` que devuelva la selección).
   - En el bloque de cálculo de hora fin: cambiar de +30 a +60 y forzar minutos `00`.
   - Input `hora_inicio`: `step="3600"` y ajuste automático a hora en punto al cambiar.
   - Actualizar textos de ayuda y el resumen para mostrar rango "de HH:00 a HH:00".

2. `php-app/app/controllers/CitapublicaController.php` — validación del lado servidor (no se puede confiar solo en el navegador):
   - En `agendar()`: normalizar `hora_inicio` a `HH:00:00` y recalcular `hora_fin` = inicio + 1 hora, ignorando lo enviado.
   - Rechazar con mensaje sencillo si la hora queda fuera del horario permitido; el resto de validaciones (traslape, fecha pasada, médico de la clínica) sigue igual y se evalúa con la hora ya normalizada.

No hay cambios en base de datos ni en la agenda interna de médicos/asistentes: esto aplica únicamente a la cita pública.
