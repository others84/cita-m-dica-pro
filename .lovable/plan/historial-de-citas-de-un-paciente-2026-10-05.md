# Historial de citas de un paciente

## Qué verá el usuario
- En las tablas de **Pacientes** y **Citas**, el nombre del paciente se vuelve un enlace (subrayado al pasar el cursor).
- Al darle clic se abre la nueva pantalla **"Historial del paciente"** con:
  - Encabezado con el nombre, teléfono, fecha de nacimiento y edad del paciente.
  - Resumen: total de citas, atendidas, canceladas, no asistió y pendientes.
  - Tabla con todas sus citas: Fecha, Hora, Médico, Especialidad, Consultorio, Estado, Precio, Observaciones.
  - Orden inicial por fecha de cita ascendente (la más antigua primero). Clic en el encabezado "Fecha" cambia a descendente y viceversa (flecha ▲/▼).
  - Botón "Regresar" que vuelve a la tabla de donde se vino (Pacientes o Citas).
- Solo consulta: no se editan citas desde esta pantalla.

## Quién lo ve
- Asistente y Administrador de clínica: todas las citas del paciente en su clínica.
- Médico: solo las citas de ese paciente que fueron con él (igual que hoy en Citas).
- Si el paciente pertenece a otra clínica, se niega el acceso (misma protección que el resto del sistema).

## Archivos a modificar (por prioridad)
1. `php-app/app/controllers/PacientesController.php` — nuevas acciones `historial` (abre la pantalla) y `historialOrden` (cambia asc/desc).
2. `php-app/app/views/pacientes/historial.php` — nueva pantalla.
3. `php-app/app/views/pacientes/_tabla.php` — nombre como enlace al historial.
4. `php-app/app/views/citas/index.php` — nombre del paciente como enlace al historial.
5. `php-app/public/assets/css/style.css` — estilo del enlace y del resumen.

Sin cambios en la base de datos.

## Detalles técnicos
- Enlace vía `post_button('pacientes/historial', ['id'=>id_PACIENTE, 'desde'=>'pacientes'|'citas'], nombre, 'link-paciente')` (POST + CSRF, sin id en la URL, igual que el resto); el id y el origen se guardan en `$_SESSION['ui']['historial']`.
- Datos: `CitaModel::listar($idMedico, null, null, $idClinicaPaciente)` filtrado por `id_PACIENTE` (el SP ya devuelve `id_PACIENTE`); médico: filtro por su `id_USUARIOS`.
- Validación: `PacienteModel::obtener()` + `clinicaPermitida()`; si falla, `denegarRecurso('PACIENTE', ...)`.
- Orden con `usort` por `fecha_cita` + `hora_inicio`, dirección en sesión (`asc` por defecto).
- Registro en `LOG`/`app.log` de la consulta del historial.
