# Guardar el mensaje como campo, sin tabla nueva

## Respuesta corta

Sí se puede, pero **no en la tabla `MEDICO`**: esa tabla ya no es la que identifica al médico de una cita. Desde el cambio en que las citas se asignan a *usuarios con perfil Médico*, la cita apunta a `USUARIOS`. El campo debe vivir en `USUARIOS`.

## Situación actual (verificada)

- `citas.CITA.id_MEDICO` tiene llave foránea hacia `citas.USUARIOS(id_USUARIOS)`, no hacia `citas.MEDICO`.
- El texto de notificación se guarda hoy en la tabla `citas.MENSAJE_MEDICO`, una fila por usuario médico (índice único por `id_USUARIOS`).
- Toda la aplicación lee y escribe ese texto únicamente a través de dos procedimientos: `spRegresaMensajeMedico` y `spGuardaMensajeMedico`. Ningún otro archivo consulta la tabla directamente.

Por eso el cambio se puede hacer **sin tocar código PHP**: basta con cambiar dónde guardan esos dos procedimientos.

## Propuesta

1. Agregar a `citas.USUARIOS` la columna `mensaje_whatsapp VARCHAR(1000) NULL` (nula para quien no sea médico o no haya definido texto).
2. Reescribir `spRegresaMensajeMedico` para que lea esa columna (devolviendo las mismas columnas `id_USUARIOS`, `plantilla`, para no alterar la aplicación).
3. Reescribir `spGuardaMensajeMedico` como un `UPDATE` sobre `USUARIOS`, conservando la validación de texto no vacío y el registro en `LOG`.
4. Migrar los textos ya capturados de `MENSAJE_MEDICO` a la nueva columna y eliminar la tabla.
5. Actualizar `schema.sql` para que una instalación nueva ya nazca con la columna.

## Ventajas y costos

- Ventaja: una tabla menos y una consulta menos; el texto viaja junto con el usuario.
- Costo: la columna queda vacía para asistentes y administradores, y `USUARIOS` es una tabla consultada en cada inicio de sesión; un texto largo la hace un poco más pesada. Es un costo menor con estos volúmenes.
- Se conserva la forma normal: el texto depende directamente del usuario, que es la llave.

## Archivos a modificar, por prioridad

1. `php-app/sql/patches/2026-09-16_mensaje_whatsapp_medico.sql` — se reemplaza por la versión con columna en `USUARIOS` (si ya lo ejecutaste, se incluye la migración de los textos y el borrado de la tabla).
2. `php-app/sql/schema.sql` — columna nueva en `USUARIOS`, procedimientos actualizados, se retira `MENSAJE_MEDICO`.
3. Sin cambios en PHP: `MensajeMedicoModel.php`, `MensajesController.php` y las vistas siguen funcionando igual.

## Alternativa

Si prefieres no tocar `USUARIOS`, dejar la tabla actual también es correcto y ya está funcionando; no hay ningún problema técnico con ella.
