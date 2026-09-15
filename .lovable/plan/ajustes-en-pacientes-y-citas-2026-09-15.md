# Ajustes en Pacientes y Citas

## 1. El correo deja de ser obligatorio (Pacientes)

Al dar de alta o actualizar un paciente se podrá dejar el correo en blanco.

- El campo deja de marcarse como obligatorio en el formulario.
- Si se escribe algo, se sigue validando que tenga formato de correo válido; si está vacío, se guarda vacío sin error.
- Si no hay correo, la casilla "Enviar notificación por correo" queda desactivada (no tiene a dónde enviar).
- La base de datos hoy exige que el correo tenga forma de correo, así que hace falta un pequeño ajuste en la regla para aceptar el valor vacío. Se entrega como script para ejecutar en el servidor.

## 2. Valores por defecto en Pacientes

Al abrir el formulario para un paciente nuevo:

- Género: "Femenino" preseleccionado.
- País: "México" preseleccionado, de modo que la lista de Estados ya venga cargada.
- Al editar un paciente existente se respetan sus datos actuales, sin cambios.

Si en el catálogo no existiera alguno de esos valores, simplemente queda sin selección (no se crea nada automáticamente).

## 3. Filtros en la vista de Citas para el perfil Médico

El recuadro "Filtros de citas" (fecha y estado) hoy está oculto para el perfil Médico en cualquier dispositivo; por eso no aparece en el celular. Se mostrará también para el Médico, con el mismo comportamiento que para los demás perfiles: filtra sobre sus propias citas y el botón "Limpiar filtros" las regresa todas. El resto de la lógica de acceso del médico no cambia.

## Detalles técnicos

Archivos a modificar, por prioridad:

1. `php-app/app/views/pacientes/index.php` — quitar `required` del correo; preseleccionar género "Femenino" y país "México" cuando no hay `$editRow` (comparación sin acentos ni mayúsculas contra `$generos` y `$paises`), pasando `selPais` al script de cascada para que cargue estados.
2. `php-app/app/controllers/PacientesController.php` — en `guardar()`, sacar `email` de la lista de obligatorios: solo validar `FILTER_VALIDATE_EMAIL` cuando no esté vacío; forzar `notifica_email = 0` si el correo va vacío.
3. `php-app/app/views/citas/index.php` — eliminar el condicional `if ($rol !== 'medico')` que envuelve el bloque "Filtros de citas" (el controlador ya aplica `f_fecha` y `f_estado` para todos los roles).
4. `php-app/sql/patches/2026-09-15_paciente_email_opcional.sql` (nuevo) — reemplazar `CHK_email_PACIENTE` por `CHECK (email = '' OR email LIKE '%_@_%._%')`, manteniendo `NOT NULL`.
5. `php-app/sql/schema.sql` — actualizar la misma restricción para instalaciones nuevas.

`PacienteModel` ya envía cadena vacía en lugar de NULL, por lo que no requiere cambios.
