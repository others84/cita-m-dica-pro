# Texto de notificación de WhatsApp por médico

## Qué se agrega

Hoy el mensaje de WhatsApp es un texto fijo igual para todos. Se agrega una pantalla **Texto de notificación** donde cada médico tiene su propio mensaje editable, con variables que el sistema sustituye al momento de enviar.

Pueden editarlo: el médico (solo el suyo), la asistente y el administrador de clínica (los médicos de sus clínicas).

## Variables disponibles

Se escriben con el prefijo `@@` dentro del texto y se sustituyen por los datos de cada cita:

- `@@CLINICA`
- `@@MEDICO`
- `@@PACIENTE`
- `@@ESPECIALIDAD`
- `@@CONSULTORIO`
- `@@FECHA` (dd/mm/aaaa)
- `@@HORA` (hh:mm)

En la pantalla aparece la lista de variables con un botón para insertarlas en el texto, más una vista previa con datos de ejemplo.

## Texto por omisión

Si un médico no ha definido su texto, se usa el actual:

> Estimado @@PACIENTE, su cita en la clinica @@CLINICA con el medico @@MEDICO con la especialidad @@ESPECIALIDAD el dia @@FECHA a la hora @@HORA. Favor de confirmar por este medio

## Dónde aplica

El texto personalizado del médico de la cita se usa en el botón WhatsApp de **Citas**, en **Citas mañana** (individual y envío masivo) y en el enlace de correo de recordatorio.

## Detalles técnicos

- Nuevo parche `php-app/sql/patches/2026-09-16_mensaje_whatsapp_medico.sql`: tabla `citas.MENSAJE_MEDICO` (`id_MENSAJE_MEDICO`, `id_USUARIOS` único, `plantilla VARCHAR(1000)`, auditoría), SP `spRegresaMensajeMedico` (uno o todos) y `spGuardaMensajeMedico` (upsert + renglón en `citas.LOG`), con `GRANT EXECUTE` a `citasadmin`. Mismo patrón que `HORARIO_MEDICO`. Se refleja también en `php-app/sql/schema.sql`.
- Nuevo `php-app/app/models/MensajeMedicoModel.php`: `todos()`, `porMedico($id)`, `guardar()`, `porDefecto()`.
- Nuevo `php-app/app/controllers/MensajesController.php` (`index`, `guardar`), roles `medico`, `asistente`, `administrador`; reutiliza `resolveClinicaContext()` y `UsuarioModel::listarMedicos()`, filtra al médico autenticado cuando el rol es `medico` y valida que el médico editado esté en la lista visible (igual que `HorariosController`). Límite 1000 caracteres y CSRF.
- Nueva vista `php-app/app/views/mensajes/index.php`: tabla de médicos con su texto y formulario de edición con botones de inserción de variables y vista previa en JavaScript.
- `php-app/app/core/App.php`: `wa_mensaje($c)` deja de armar el texto fijo; toma la plantilla del médico de la cita (`id_MEDICO`) vía `MensajeMedicoModel`, con caché estático por petición, y sustituye las variables `@@...` (las no reconocidas se dejan tal cual). `wa_link()` y `mail_link()` no cambian.
- `php-app/app/views/layout/header.php`: opción `mensajes` "Texto de notificación" en Configuración para Médico, Asistente y Administrador de clínica.
- `php-app/app/controllers/FiltroController.php`: agregar `mensajes` a los destinos válidos del filtro de clínica.

## Archivos a crear/actualizar (por prioridad)

1. `php-app/sql/patches/2026-09-16_mensaje_whatsapp_medico.sql` (nuevo) — ejecutarlo en el servidor.
2. `php-app/app/models/MensajeMedicoModel.php` (nuevo)
3. `php-app/app/controllers/MensajesController.php` (nuevo)
4. `php-app/app/views/mensajes/index.php` (nuevo)
5. `php-app/app/core/App.php` — sustitución de variables en `wa_mensaje()`
6. `php-app/app/views/layout/header.php` — opción de menú
7. `php-app/app/controllers/FiltroController.php` — destino del filtro de clínica
8. `php-app/sql/schema.sql` — tabla y SPs nuevos
