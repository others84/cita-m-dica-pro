# Padecimientos con precio en las citas

## Qué se va a ver
- Nueva opción de menú **"Padecimientos"** para Médico y Administrador de clínica.
  - El médico ve y administra solo los suyos.
  - El administrador de clínica elige un médico de sus clínicas y administra los de ese médico.
  - Cada padecimiento: nombre, especialidad (de las que tiene el médico), precio, activo/inactivo. Alta, edición y baja lógica (inactivar, para no perder historial).
- En **Agendar / Editar cita**: un campo de selección múltiple "Padecimientos" que muestra solo los padecimientos activos del médico y especialidad elegidos.
  - Al elegir o quitar padecimientos, el **Precio** se llena solo con la suma; se puede modificar a mano. Si el usuario lo cambió a mano, no se vuelve a sobrescribir sin avisar.
  - Es opcional; también se puede capturar al momento de "Atender".
- En la **cita pública**: el mismo campo, opcional, sin mostrar precios al paciente (el precio se calcula igual en segundo plano).
- En el **Historial del paciente** y la tabla de **Citas**: los padecimientos se muestran como texto junto a la cita.
- El precio queda guardado en cada cita: si después cambia el precio del catálogo, las citas anteriores no cambian.

## Archivos (por prioridad)
1. `sql/patches/2026-10-08_padecimientos.sql` (nuevo; ejecutar primero en `CitasMedicas` y `CitasMedicasDEMO`).
2. `app/models/PadecimientoModel.php` (nuevo).
3. `app/controllers/PadecimientosController.php` (nuevo; permisos: médico solo los suyos, admin de clínica solo médicos de sus clínicas).
4. `app/views/padecimientos/index.php` (nuevo).
5. `app/controllers/CitasController.php` (guardar/editar/atender con padecimientos; endpoint JSON por médico+especialidad).
6. `app/models/CitaModel.php` (guardar y leer padecimientos de la cita).
7. `app/views/citas/form.php` (campo múltiple y suma automática del precio).
8. `app/controllers/CitapublicaController.php` y `app/views/citapublica/*` (campo opcional).
9. `app/views/citas/index.php`, `app/views/pacientes/historial.php` (mostrar padecimientos).
10. `app/views/layout/header.php` (menú e icono), `app/assets/css/style.css`.
11. `sql/schema.sql` (agregar el parche al final).

## Detalles técnicos
- Tabla `PADECIMIENTO`: `id_PADECIMIENTO`, `id_MEDICO`, `id_ESPECIALIDAD`, `nombre`, `precio decimal(10,2)`, `activo bit`, columnas de auditoría; único (`id_MEDICO`, `id_ESPECIALIDAD`, `nombre`).
- Tabla `CITA_PADECIMIENTO`: `id_CITA`, `id_PADECIMIENTO`, `precio decimal(10,2)` (precio al momento de la cita); PK compuesta; borrado en cascada desde `CITA` (y `spBajaCita` actualizado).
- SPs: `spAltaPadecimiento`, `spCambioPadecimiento`, `spBajaPadecimiento` (inactiva), `spRegresaPadecimientos` (@id_MEDICO, @id_ESPECIALIDAD, @solo_activos), `spGuardaPadecimientosCita` (@id_CITA, lista CSV de ids; reemplaza el conjunto), `spRegresaPadecimientosCita`. Todo con registro en `LOG`.
- `CITA.precio` sigue siendo el total final (editable); no cambia su significado, reportes actuales intactos.
- El servidor valida que cada padecimiento pertenezca al médico y especialidad de la cita (evita IDOR) y recalcula el precio sugerido; el precio capturado se respeta si es ≥ 0.
- Selección múltiple con checkboxes en lista desplegable (funciona bien en celular), JS vanilla que recarga la lista al cambiar médico/especialidad.
