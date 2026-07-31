# Citas: edición, tabla y datos del paciente

## 1. El botón "Editar" debe regresar los datos de la cita

Hoy `CitasController::form()` busca el registro recorriendo `CitaModel::listar()` sin filtros, mientras que los `<select>` del formulario se llenan solo con datos de la clínica activa del filtro. Si la cita pertenece a otra clínica (o el filtro está en otra), los combos no contienen la opción guardada y el formulario se ve vacío.

Cambios:
- Nuevo método `CitaModel::obtener(int $id)` para traer una sola cita.
- En `form()`: al editar, cargar la cita y fijar el contexto de clínica al de la propia cita (`id_CLINICA`), para que pacientes, médicos, consultorios y especialidades incluyan los valores guardados.
- Preseleccionar todos los campos: paciente, médico, consultorio, especialidad, fecha, horas, estado, precio, horas de anticipación, casillas de notificación y observaciones.
- Conservar el `id` en campo oculto para que "Actualizar" ejecute `spCambioCita` y no un alta.

## 2. Tabla "Citas registradas"

En `citas/index.php`: quitar la columna **ID** (encabezado y celda) y agregar la columna **Observaciones** antes de Acciones, con el texto recortado y `title` completo al pasar el mouse. Ajustar el `colspan` del mensaje "Sin citas en el rango".

## 3. Email y celular al seleccionar el paciente

`spRegresaPacientes` ya devuelve `email` y `telefono`. En `citas/form.php`:
- Cada `<option>` de paciente llevará `data-email` y `data-tel`.
- Un script rellena "Email notificacion" y "Celular notificacion (WA)" al cambiar el paciente; al editar se muestran los valores guardados de la cita.
- Esos dos campos quedan de solo lectura, porque `spAltaCita`/`spCambioCita` copian el email y el teléfono directamente del paciente y no los reciben como parámetros.

## Archivos afectados
- `php-app/app/models/CitaModel.php`
- `php-app/app/controllers/CitasController.php`
- `php-app/app/views/citas/form.php`
- `php-app/app/views/citas/index.php`