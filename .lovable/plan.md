# Citas mañana (aviso por WhatsApp)

## Qué se agrega

Una nueva opción de menú **Citas mañana**, visible solo para Asistente y Médico, con una pantalla parecida a "Citas" que lista únicamente las citas **del día siguiente** con estatus **Agendada**, de la clínica seleccionada (y, para el médico, solo las suyas).

Arriba de la tabla habrá un botón **Enviar WhatsApp a todos**. Al presionarlo se abre, una por una, la ventana de WhatsApp con el mensaje ya escrito para cada paciente; el usuario solo presiona Enviar en WhatsApp. Sin costo: se usan enlaces `wa.me`, igual que el botón actual de la pantalla de Citas.

Cada cita enviada queda marcada automáticamente como **Notificado**, para que no se repita el aviso y el contador del menú se actualice.

## Cómo funciona la pantalla

- Encabezado con la fecha de mañana y el total de citas por avisar.
- Tabla con: Hora, Paciente, Médico, Especialidad, Consultorio, Teléfono, Notificado y Acciones.
- En Acciones, cada fila tiene su propio enlace **WhatsApp** (un enlace real, no una ventana emergente), que en el celular abre directamente la app de WhatsApp y en computadora abre WhatsApp Web en otra pestaña. Este es el camino más confiable en teléfonos.
- Botón **Enviar WhatsApp a todos**: abre los chats en secuencia usando los mismos enlaces. En celular conviene usar los enlaces fila por fila, porque el sistema operativo solo deja abrir una conversación a la vez.
- Al abrir cada enlace, la cita se marca como **Notificado** en segundo plano.
- Si un paciente no tiene teléfono registrado, su enlace aparece deshabilitado con el aviso "Sin teléfono" y no se cuenta en el envío masivo ni se marca como notificado.
- Si no hay citas para mañana, se muestra "No hay citas agendadas para mañana".
- Filtro de clínica igual que en la pantalla de Citas.

Nota: en computadora, el navegador puede pedir permiso para abrir varias pestañas seguidas; la pantalla lo avisa la primera vez. En celular, el envío es de una conversación a la vez.

## Detalles técnicos

- Nuevo controlador `CitasmananaController.php`:
  - `index()`: requiere sesión, resuelve el contexto de clínica con `resolveClinicaContext()`, llama `CitaModel::listar(idMedico, mañana, mañana, idClinica)` y filtra por estado "Agendada" (y por médico autenticado cuando el rol es médico). Restringido a los roles `asistente` y `medico`.
  - `marcar()`: endpoint POST (CSRF) que valida pertenencia con `citaPermitida()`, registra el enlace en `app.log` (mismo formato que `WHATSAPP ENLACE GENERADO`) y ejecuta la marca de notificado reutilizando `CitaModel::notifica()`.
- Nueva vista `views/citasmanana/index.php`: reutiliza `_partials/filtro_clinica.php`, las clases `table-responsive`/`data`, `wa_link()` y `wa_numero()` de `core/App.php`. Cada fila usa una etiqueta `<a href="https://wa.me/...?text=..." target="_blank" rel="noopener">` construida en el servidor (sin `window.open`, para no ser bloqueada en iOS Safari); el `click` dispara además un `fetch` a `marcar()` con `navigator.sendBeacon`/`keepalive` para no interrumpir la navegación. El botón masivo recorre esos mismos `<a>` y los abre en secuencia solo en escritorio; en pantallas táctiles muestra la indicación de usar los enlaces fila por fila.
- `views/layout/header.php`: se agrega `nav_link('citasmanana', 'Citas mañana', $__cur)` justo después de "Citas" en los bloques de menú de Asistente y Médico.
- Sin cambios de base de datos ni parches SQL: se usan los procedimientos existentes (`spRegresaCitas`, `spNotificaCita`).

## Archivos a crear/actualizar (por prioridad)

1. `php-app/app/controllers/CitasmananaController.php` (nuevo) — listado de mañana y marca de notificado.
2. `php-app/app/views/citasmanana/index.php` (nuevo) — tabla y botones de WhatsApp.
3. `php-app/app/views/layout/header.php` — opción de menú "Citas mañana" para Asistente y Médico.
