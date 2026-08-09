# Notificación por WhatsApp (wa.me) con botón manual

## Qué se agrega

En la tabla **Citas registradas**, para cada cita pendiente de notificar aparece un botón **WhatsApp** que abre WhatsApp (app o Web) en una pestaña nueva, con el mensaje ya escrito y dirigido al teléfono del paciente. El usuario solo presiona "Enviar" en WhatsApp.

Sin costo: no se usa ninguna API de pago, es un enlace `wa.me`.

## Mensaje

> Estimado usuario, su cita en la clínica "NOMBRE CLINICA" con el médico "NOMBRE MEDICO" con la especialidad "NOMBRE ESPECIALIDAD" el día "DD/MM/AAAA" a la hora "HH:MM". Favor de confirmar por este medio.

Los valores se toman de la cita seleccionada.

## Comportamiento

- El botón se muestra solo cuando la cita no está cancelada, no está atendida y aún no está notificada (mismas reglas que el botón "Notificado" actual).
- Si el paciente no tiene teléfono registrado, el botón se muestra deshabilitado con el aviso "Sin teléfono".
- Al abrir WhatsApp la cita **no** se marca automáticamente como notificada; el usuario sigue usando el botón "Notificado" para confirmarlo, así el conteo del menú solo baja cuando realmente se envió.
- Se registra en `app.log` que se generó el enlace de WhatsApp (cita, paciente, usuario, clínica).

## Detalles técnicos

- Número: se usa `celular_notif` de la cita (copiado del teléfono del paciente). Se normaliza quitando espacios, guiones, paréntesis y `+`; si queda con 10 dígitos se antepone el código de país **52** (México). El enlace queda `https://wa.me/<numero>?text=<mensaje urlencoded>`.
- Se agrega un helper PHP `wa_link($cita)` en el archivo de helpers de vistas, que arma número y texto.
- La vista `citas/index.php` renderiza `<a target="_blank" rel="noopener" class="btn btn-sec">WhatsApp</a>`.
- No requiere cambios en la base de datos ni parches SQL.

## Archivos a actualizar (por prioridad)

1. `php-app/app/views/citas/index.php` — botón WhatsApp en la columna Acciones.
2. `php-app/app/core/helpers.php` (archivo de helpers de vistas) — función `wa_link()`.
3. `php-app/app/controllers/CitasController.php` — asegurar que la vista reciba clínica, médico, especialidad, fecha, hora y celular; registro en `app.log`.

Sin parches SQL.