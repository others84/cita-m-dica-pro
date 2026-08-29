# Horarios de atención por médico

Cada médico tendrá tres horarios configurables que limitan **solo** el agendado desde la página pública:

1. Hora de inicio de consultas (lunes a viernes)
2. Horario de comida (un bloque: hora inicio / hora fin, igual todos los días)
3. Hora de término de consultas

Los médicos, asistentes y administradores de clínica siguen pudiendo agendar en cualquier horario desde la pantalla interna de Citas: la restricción no aplica ahí.

## Comportamiento

- **Página pública (Generar cita):** al elegir médico, el calendario muestra únicamente el rango de ese médico; el bloque de comida aparece como no disponible y sábado y domingo quedan bloqueados por completo. Si el paciente intenta enviar una hora fuera del horario, el sistema lo rechaza con un mensaje claro ("El médico atiende de 09:00 a 18:00 y come de 14:00 a 15:00").
- **Pantalla de configuración:** nueva vista "Horario de atención" accesible para médico (solo el suyo), asistente y administrador de clínica (los médicos de las clínicas a las que tienen acceso). Campos: hora de inicio, inicio de comida, fin de comida, hora de término, con validación de orden lógico.
- **Valores por defecto:** si un médico no tiene horario capturado, se usa 07:00–21:00 sin comida (el comportamiento actual), para no romper nada existente.

## Archivos a modificar (por prioridad)

1. `php-app/sql/patches/2026-08-29_horario_medico.sql` (nuevo) — tabla `citas.HORARIO_MEDICO` (id_USUARIOS, hora_inicio, comida_inicio, comida_fin, hora_fin, auditoría) más los SP `spRegresaHorarioMedico`, `spGuardaHorarioMedico` y sus permisos de ejecución.
2. `php-app/app/models/HorarioMedicoModel.php` (nuevo) — lectura/guardado vía los SP y método `porDefecto()` con el rango 07:00–21:00.
3. `php-app/app/controllers/CitapublicaController.php` — cargar el horario del médico seleccionado, pasarlo a la vista y validar en `agendar()`: rango permitido, bloque de comida y días lunes a viernes.
4. `php-app/app/views/citapublica/index.php` — usar el horario del médico en `slotMinTime`/`slotMaxTime`, pintar el bloque de comida como ocupado, ocultar sábado y domingo y mostrar el texto de ayuda con el horario real.
5. `php-app/app/controllers/HorariosController.php` (nuevo) — pantalla de captura, con validación de rol y de pertenencia del médico a la clínica del usuario (misma lógica `resolveClinicaContext()` que el resto).
6. `php-app/app/views/horarios/index.php` (nuevo) — listado de médicos de la clínica con sus horarios y formulario de edición (CSRF incluido).
7. `php-app/app/views/layout/header.php` — nueva opción de menú "Horario de atención" para los roles médico, asistente y administrador de clínica.
8. `php-app/sql/schema.sql` — incorporar la tabla y los SP nuevos al script base.

## Notas técnicas

- La validación de horario se hace **en el servidor** dentro de `CitapublicaController::agendar()`; el calendario solo es ayuda visual.
- El bloque de comida se inyecta como evento de fondo por día visible en el calendario público, con el mismo estilo gris de "Ocupado".
- Los cambios de horario se registran en `LOG` con `LogModel::evento()`, indicando usuario, médico y el nuevo horario.
- Ningún cambio afecta a `CitasController.php` ni a `citas/form.php`: el agendado interno queda sin restricciones.
