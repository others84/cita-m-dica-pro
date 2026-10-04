# Agendar cita directamente desde el Calendario

## Qué verá el usuario
- En el Calendario (vista Semana o Día), la asistente, el médico o el administrador de clínica dan clic en un espacio vacío (por ejemplo, martes 10:00).
- Se abre de inmediato la pantalla "Agendar cita" con:
  - Fecha ya puesta (el día seleccionado).
  - Hora de inicio ya puesta (la hora del espacio).
  - Hora fin sugerida: 30 minutos después (se puede cambiar).
  - Médico ya seleccionado si el calendario estaba filtrado por un médico (o si es el propio médico).
- En la vista Mes, clic en un día abre la pantalla con solo la fecha puesta.
- No se permite elegir espacios en el pasado: aparece un aviso "No se pueden agendar citas en fechas u horas pasadas".
- El cursor cambia a "mano" al pasar sobre un espacio libre y se agrega una leyenda: "Da clic en un horario libre para agendar una cita".
- Dar clic sobre una cita existente sigue mostrando su detalle, como hoy.
- Al guardar la cita se regresa a la lista de Citas (comportamiento actual).

## Reglas
- Todas las validaciones actuales al guardar se mantienen (permisos de clínica, médico, horarios ocupados). Lo del calendario solo prellena datos.
- Fecha y hora se envían de forma segura (formulario con protección, no en la dirección) y se validan en el servidor (formato correcto y no en el pasado).

## Archivos a modificar (por prioridad)
1. `php-app/app/views/calendario/index.php` — permitir clic en espacio vacío (dateClick), aviso de horario pasado, leyenda y cursor; envía fecha, hora y médico a "Agendar cita".
2. `php-app/app/controllers/CitasController.php` — nueva acción `desdeCalendario` que valida y guarda la fecha/hora/médico preseleccionados y abre el formulario de nueva cita.
3. `php-app/app/views/citas/form.php` — usar esos valores preseleccionados cuando es una cita nueva.
4. `php-app/public/assets/css/style.css` — estilo de la leyenda y del cursor sobre espacios libres.

## Detalles técnicos
- EventCalendar: `dateClick(info)` → `info.date`, `info.allDay`. Construye un form POST oculto con `_csrf`, `fecha`, `hora`, `id_medico` (valor de `fMedico`) hacia `citas/desdeCalendario`.
- Controlador: valida `Y-m-d` / `H:i`, rechaza pasado comparando con `CitaModel::ahoraSql()`, guarda en `$_SESSION['ui']['citas']['prefill']`, hace `clearState('id')` y redirige a `citas/nueva`; `form()` consume y limpia el prefill.
- Vista: si no hay `$editRow`, toma `$f/$hi/$hf` y médico del prefill; hora fin = inicio + 30 min.
- Sin cambios en base de datos.
