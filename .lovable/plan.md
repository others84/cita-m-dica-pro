# Mensaje en USUARIOS y retiro del catálogo MEDICO

## Qué se verificó

- `citas.CITA.id_MEDICO` apunta a `citas.USUARIOS`, no a `citas.MEDICO`.
- La pantalla "Médicos" ya trabaja **solo con usuarios de perfil médico** (`MedicosController` usa `UsuarioModel` y `UsuarioClinicaModel`).
- `MedicoModel.php` (el único archivo que consulta `citas.MEDICO`) **no lo carga ningún controlador ni vista**: es código muerto.
- `MEDICO_ESPECIALIDAD` no se lee en ninguna parte de la aplicación; las especialidades de citas vienen de `CATALOGO_ESPECIALIDAD`.
- Horarios y textos de notificación ya se guardan por usuario (`HORARIO_MEDICO.id_USUARIOS`, `MENSAJE_MEDICO.id_USUARIOS`).

Conclusión: la tabla `MEDICO` (y su tabla de especialidades) quedó sin uso; mantenerla solo genera confusión.

## Parte 1 — Mover el texto de notificación a USUARIOS

1. Agregar `mensaje_whatsapp VARCHAR(1000) NULL` a `citas.USUARIOS`.
2. Reescribir `spRegresaMensajeMedico` y `spGuardaMensajeMedico` para leer/escribir esa columna, devolviendo las mismas columnas de hoy.
3. Copiar los textos existentes de `MENSAJE_MEDICO` a la columna nueva y eliminar esa tabla.
4. No se toca PHP: `MensajeMedicoModel`, `MensajesController` y las vistas siguen igual.

## Parte 2 — Retirar el catálogo MEDICO

1. Migrar (informativo) los nombres que aún existan en `citas.MEDICO` al `LOG`, como respaldo del retiro.
2. Eliminar `citas.MEDICO_ESPECIALIDAD` y luego `citas.MEDICO`, junto con sus procedimientos: `spAltaMedico`, `spCambioMedico`, `spBajaMedico`, `spActivaMedico`, `spDesactivaMedico`, `spRegresaMedicos`, `spAltaMedicoEspecialidad`, `spBajaMedicoEspecialidad`, `spRegresaMedicoEspecialidades`.
3. Borrar `php-app/app/models/MedicoModel.php` (código muerto).
4. Quitar todo eso de `schema.sql` para que una instalación nueva ya no las cree.

La opción de menú "Médicos" **no cambia**: seguirá funcionando igual, porque se apoya en usuarios.

## Riesgo y reversa

El script incluirá una verificación previa: si `citas.MEDICO` tiene filas con datos que no estén representados en usuarios médicos, el script se detiene y avisa, en lugar de borrar. Así no se pierde información capturada por error en la tabla vieja.

## Archivos a modificar, por prioridad

1. `php-app/sql/patches/2026-09-16_mensaje_whatsapp_medico.sql` — se reemplaza por la versión con columna en `USUARIOS` + migración desde `MENSAJE_MEDICO`.
2. `php-app/sql/patches/2026-09-16_retiro_catalogo_medico.sql` (nuevo) — verificación y eliminación de `MEDICO`, `MEDICO_ESPECIALIDAD` y sus procedimientos.
3. `php-app/sql/schema.sql` — columna nueva en `USUARIOS`; se retiran `MENSAJE_MEDICO`, `MEDICO`, `MEDICO_ESPECIALIDAD` y sus procedimientos.
4. `php-app/app/models/MedicoModel.php` — se elimina.

Ambos scripts los ejecutas tú en el servidor; sugiero respaldo de la base antes del segundo.
