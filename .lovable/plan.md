# Mover el texto de notificación a la tabla USUARIOS

## Qué se verificó

- `citas.CITA.id_MEDICO` apunta a `citas.USUARIOS`, no a `citas.MEDICO`.
- La pantalla "Médicos" ya trabaja solo con usuarios de perfil médico.
- El texto de notificación vive hoy en `citas.MENSAJE_MEDICO`, una fila por usuario médico.
- Toda la aplicación lee y escribe ese texto solo con dos procedimientos: `spRegresaMensajeMedico` y `spGuardaMensajeMedico`. Ningún archivo PHP consulta la tabla directamente.

La tabla `MEDICO` y su código se quedan tal como están; no se tocan en este cambio.

## Cambio propuesto

1. Agregar a `citas.USUARIOS` la columna `mensaje_whatsapp VARCHAR(1000) NULL`.
2. Reescribir `spRegresaMensajeMedico` para leer esa columna, devolviendo las mismas columnas de hoy (`id_USUARIOS`, `plantilla`).
3. Reescribir `spGuardaMensajeMedico` como `UPDATE` sobre `USUARIOS`, conservando la validación de texto no vacío y el registro en `LOG`.
4. Copiar los textos ya capturados de `MENSAJE_MEDICO` a la columna nueva y eliminar esa tabla.
5. Dejar `schema.sql` alineado para instalaciones nuevas.

No se modifica PHP: `MensajeMedicoModel`, `MensajesController` y las vistas siguen funcionando igual.

## Archivos a modificar, por prioridad

1. `php-app/sql/patches/2026-09-16_mensaje_whatsapp_medico.sql` — se reemplaza por la versión con columna en `USUARIOS`, incluyendo la migración de textos y el borrado de `MENSAJE_MEDICO` (sirve tanto si ya lo ejecutaste como si no).
2. `php-app/sql/schema.sql` — columna nueva en `USUARIOS`, procedimientos actualizados, se retira `MENSAJE_MEDICO`.

El script lo ejecutas tú en el servidor.
