# Citas mañana (aviso por WhatsApp)

## Qué se agrega

Una nueva opción de menú **Citas mañana**, visible solo para Asistente y Médico, con una pantalla parecida a "Citas" que lista únicamente las citas **del día siguiente** con estatus **Agendada**, de la clínica seleccionada (y, para el médico, solo las suyas).

Arriba de la tabla habrá un botón **Enviar WhatsApp a todos**. Al presionarlo se abre, una por una, la ventana de WhatsApp con el mensaje ya escrito para cada paciente; el usuario solo presiona Enviar en WhatsApp. Sin costo: se usan enlaces `wa.me`, igual que el botón actual de la pantalla de Citas.

Cada cita enviada queda marcada automáticamente como **Notificado**, para que no se repita el aviso y el contador del menú se actualice.

## Cómo funciona la pantalla

- Encabezado con la fecha de mañana y el total de citas por avisar.
- Tabla con: Hora, Paciente, Médico, Especialidad, Consultorio, Teléfono, Notificado y Acciones.
- En Acciones, cada fila tiene su propio botón **WhatsApp** (envío individual) por si se quiere avisar solo a alguien.
- Botón **Enviar WhatsApp a todos**: abre las conversaciones en secuencia (con una breve pausa entre cada una) y marca cada cita como notificada.
- Si un paciente no tiene teléfono registrado, su botón aparece deshabilitado con el aviso "Sin teléfono" y no se cuenta en el envío masivo ni se marca como notificado.
- Si no hay citas para mañana, se muestra "No hay citas agendadas para mañana".
- Filtro de clínica igual que en la pantalla de Citas.

Nota: los navegadores pueden bloquear la apertura de varias pestañas seguidas; la pantalla avisará al usuario que permita las ventanas emergentes de este sitio la primera vez.

## Detalles técnicos

- Nuevo controlador `CitasmananaController.php`:
  - `index()`: requiere sesión, resuelve el contexto de clínica con `resolveClinicaContext()`, llama `CitaModel::listar(idMedico, mañana, mañana, idClinica)` y filtra por estado "Agendada" (y por médico autenticado cuando el rol es médico). Restringido a los roles `asistente` y `medico`.
  - `marcar()`: endpoint POST (CSRF) que valida pertenencia con `citaPermitida()`, registra el enlace en `app.log` (mismo formato que `WHATSAPP ENLACE GENERADO`) y ejecuta la marca de notificado reutilizando `CitaModel::notifica()`.
- Nueva vista `views/citasmanana/index.php`: reutiliza `_partials/filtro_clinica.php`, las clases `table-responsive`/`data`, `wa_link()` y `wa_numero()` de `core/App.php`. JavaScript mínimo para recorrer la lista, llamar a `marcar()` con `fetch` y abrir cada enlace con `window.open`.
- `views/layout/header.php`: se agrega `nav_link('citasmanana', 'Citas mañana', $__cur)` justo después de "Citas" en los bloques de menú de Asistente y Médico.
- Sin cambios de base de datos ni parches SQL: se usan los procedimientos existentes (`spRegresaCitas`, `spNotificaCita`).

## Archivos a crear/actualizar (por prioridad)

1. `php-app/app/controllers/CitasmananaController.php` (nuevo) — listado de mañana y marca de notificado.
2. `php-app/app/views/citasmanana/index.php` (nuevo) — tabla y botones de WhatsApp.
3. `php-app/app/views/layout/header.php` — opción de menú "Citas mañana" para Asistente y Médico.
